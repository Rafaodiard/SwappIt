using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Data.SqlClient;
using Swappit.Models;
using Swappit.Models.ViewModels;

namespace Swappit.Controllers;

// Publicar un artículo nuevo (/Publicar): formulario, validación, guardado de fotos en wwwroot/img/articulos
// y alta en la base. Hay que estar logueado: el artículo se guarda con IdUsuarios = UsuarioId de la sesión.
public class PublicarController : Controller
{
    // 6 fotos de 10 MB superan el límite por defecto de Kestrel por pedido (~28 MB): se amplía solo acá.
    private const long LimitePedidoPublicar = (PublicarArticuloViewModel.MaxFotos * PublicarArticuloViewModel.MaxFotoMB + 1) * 1024L * 1024L;

    private readonly ILogger<PublicarController> _logger;
    private readonly IWebHostEnvironment _env;

    public PublicarController(ILogger<PublicarController> logger, IWebHostEnvironment env)
    {
        _logger = logger;
        _env = env;
    }

    [HttpGet]
    public IActionResult Index()
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return RedirectToAction("Index", "Account");
        }

        // La ubicación arranca con el barrio del perfil; el usuario la puede cambiar.
        PublicarArticuloViewModel publicar = new PublicarArticuloViewModel();
        try
        {
            publicar.Ubicacion = BD.GetUsuarioById(usuarioId.Value)?.Barrio ?? string.Empty;
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo leer el barrio del usuario {IdUsuario}", usuarioId);
        }

        ViewBag.publicar = publicar;
        ViewBag.categorias = ObtenerCategorias();
        ViewBag.estados = ObtenerEstados();
        return View();
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    [RequestSizeLimit(LimitePedidoPublicar)]
    [RequestFormLimits(MultipartBodyLengthLimit = LimitePedidoPublicar)]
    public IActionResult Index(PublicarArticuloViewModel modelo)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return RedirectToAction("Index", "Account");
        }

        List<SelectListItem> categorias = ObtenerCategorias();
        if (modelo.IdCategorias.HasValue && !categorias.Any(c => c.Value == modelo.IdCategorias.Value.ToString()))
        {
            ModelState.AddModelError(nameof(modelo.IdCategorias), "Elegí una categoría de la lista");
        }
        List<EstadosArticulos> estados = ObtenerEstados();
        if (modelo.IdEstado.HasValue && !estados.Any(e => e.IdEstadosArticulos == modelo.IdEstado.Value))
        {
            ModelState.AddModelError(nameof(modelo.IdEstado), "Elegí uno de los estados de la lista");
        }

        List<IFormFile> fotos = (modelo.Fotos ?? []).Where(f => f.Length > 0).ToList();
        ValidarFotos(fotos);

        // Si hay errores, la vista vuelve a mostrar lo que el usuario cargó.
        ViewBag.publicar = modelo;
        ViewBag.categorias = categorias;
        ViewBag.estados = estados;
        if (!ModelState.IsValid)
        {
            AvisarFotosDeNuevo(fotos);
            return View();
        }

        List<string> rutasFotos = new List<string>();
        try
        {
            GuardarFotosArticulo(fotos, usuarioId.Value, rutasFotos);

            Articulos articulo = new Articulos
            {
                Nombre = modelo.Titulo.Trim(),
                Descripcion = modelo.Descripcion.Trim(),
                IdEstado = modelo.IdEstado!.Value,
                IdUsuarios = usuarioId.Value,
                IdCategorias = modelo.IdCategorias!.Value,
                Ubicacion = modelo.Ubicacion.Trim(),
                ACambio = string.IsNullOrWhiteSpace(modelo.ACambio) ? null : modelo.ACambio.Trim()
            };
            int idArticulo = BD.PublicarArticulo(articulo, rutasFotos);

            TempData["MensajeArticulo"] = "¡Listo! Tu artículo ya está publicado.";
            return RedirectToAction("Detalle", "Articulos", new { id = idArticulo });
        }
        catch (Exception ex) when (ex is SqlException or IOException or UnauthorizedAccessException)
        {
            // No quedan fotos sueltas en wwwroot de un artículo que no se guardó.
            _logger.LogError(ex, "No se pudo publicar el artículo del usuario {IdUsuario}", usuarioId);
            BorrarFotosArticulo(rutasFotos);
            ModelState.AddModelError(string.Empty, "No pudimos publicar tu artículo. Probá de nuevo en un rato.");
            AvisarFotosDeNuevo(fotos);
            return View();
        }
    }

    // Mismas reglas que las fotos de perfil (PerfilController.Editar): extensión JPG/PNG y tamaño máximo.
    private void ValidarFotos(List<IFormFile> fotos)
    {
        if (fotos.Count > PublicarArticuloViewModel.MaxFotos)
        {
            ModelState.AddModelError("Fotos", $"Podés subir hasta {PublicarArticuloViewModel.MaxFotos} fotos.");
        }
        else if (fotos.Any(f => !PublicarArticuloViewModel.ExtensionesFoto.Contains(Path.GetExtension(f.FileName).ToLower())))
        {
            ModelState.AddModelError("Fotos", "Las fotos tienen que ser JPG o PNG.");
        }
        else if (fotos.Any(f => f.Length > PublicarArticuloViewModel.MaxFotoMB * 1024 * 1024))
        {
            ModelState.AddModelError("Fotos", $"Cada foto puede pesar hasta {PublicarArticuloViewModel.MaxFotoMB} MB.");
        }
    }

    // El navegador no vuelve a cargar un <input type="file"> cuando la página vuelve con errores.
    private void AvisarFotosDeNuevo(List<IFormFile> fotos)
    {
        if (fotos.Count > 0 && ModelState["Fotos"]?.Errors.Count is null or 0)
        {
            ModelState.AddModelError("Fotos", "Volvé a elegir las fotos antes de publicar.");
        }
    }

    // Las fotos van a wwwroot/img/articulos y la ruta a Imagenes.Ruta, que es varchar(50):
    // nombre corto con id del usuario + ticks en hexa + número de foto (~48 caracteres como máximo).
    // Agrega cada ruta a rutasFotos antes de escribirla, para poder borrarlas si algo falla después.
    private void GuardarFotosArticulo(List<IFormFile> fotos, int idUsuario, List<string> rutasFotos)
    {
        string carpeta = Path.Combine(_env.WebRootPath, "img", "articulos");
        Directory.CreateDirectory(carpeta);

        long ticks = DateTime.Now.Ticks;
        for (int i = 0; i < fotos.Count; i++)
        {
            string extension = Path.GetExtension(fotos[i].FileName).ToLower();
            string nombreArchivo = $"{idUsuario}_{ticks:x}_{i + 1}{extension}";
            rutasFotos.Add($"/img/articulos/{nombreArchivo}");

            using (FileStream stream = new FileStream(Path.Combine(carpeta, nombreArchivo), FileMode.Create))
            {
                fotos[i].CopyTo(stream);
            }
        }
    }

    private void BorrarFotosArticulo(List<string> rutasFotos)
    {
        foreach (string ruta in rutasFotos)
        {
            string archivo = Path.Combine(_env.WebRootPath, "img", "articulos", Path.GetFileName(ruta));
            if (System.IO.File.Exists(archivo))
            {
                System.IO.File.Delete(archivo);
            }
        }
    }

    // Opciones del <select> de categorías, desde la tabla Categorias.
    // Si la BD falla, el select queda vacío y el POST no valida (no se puede publicar sin categoría).
    private List<SelectListItem> ObtenerCategorias()
    {
        try
        {
            return BD.GetCategorias().Select(c => new SelectListItem(c.Nombre, c.IdCategorias.ToString())).ToList();
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron cargar las categorías");
            return new List<SelectListItem>();
        }
    }

    // Opciones de "Estado del objeto", desde la tabla EstadosArticulos.
    // Si la BD falla, no hay opciones y el POST no valida (no se puede publicar sin estado).
    private List<EstadosArticulos> ObtenerEstados()
    {
        try
        {
            return BD.GetEstadosArticulos();
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron cargar los estados");
            return new List<EstadosArticulos>();
        }
    }
}
