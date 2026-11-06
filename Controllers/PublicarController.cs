using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Data.SqlClient;
using Swappit.Models;
using Swappit.Models.ViewModels;

namespace Swappit.Controllers;

public class PublicarController : Controller
{
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
        if (modelo.IdCategoriaACambio.HasValue && !categorias.Any(c => c.Value == modelo.IdCategoriaACambio.Value.ToString()))
        {
            ModelState.AddModelError(nameof(modelo.IdCategoriaACambio), "Elegí una categoría de la lista o dejalo abierto a propuestas");
        }
        List<EstadosArticulos> estados = ObtenerEstados();
        if (modelo.IdEstado.HasValue && !estados.Any(e => e.IdEstadosArticulos == modelo.IdEstado.Value))
        {
            ModelState.AddModelError(nameof(modelo.IdEstado), "Elegí uno de los estados de la lista");
        }

        List<IFormFile> fotos = (modelo.Fotos ?? []).Where(f => f.Length > 0).ToList();
        ValidarFotos(fotos);

        ViewBag.publicar = modelo;
        ViewBag.categorias = categorias;
        ViewBag.estados = estados;
        if (!ModelState.IsValid)
        {
            AvisarFotosDeNuevo(fotos);
            return View();
        }

        if (BD.ContarArticulosActivos(usuarioId.Value) >= 5)
        {
            ModelState.AddModelError(string.Empty, "Ya llegaste al máximo de 5 objetos publicados a la vez.");
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
                IdCategoriaACambio = modelo.IdCategoriaACambio,
                FechaPublicacion = DateTime.Today
            };
            int idArticulo = BD.PublicarArticulo(articulo, rutasFotos);

            TempData["MensajeArticulo"] = "¡Listo! Tu artículo ya está publicado.";
            return RedirectToAction("Detalle", "Articulos", new { id = idArticulo });
        }
        catch (Exception ex) when (ex is SqlException or IOException or UnauthorizedAccessException)
        {
            _logger.LogError(ex, "No se pudo publicar el artículo del usuario {IdUsuario}", usuarioId);
            BorrarFotosArticulo(rutasFotos);
            ModelState.AddModelError(string.Empty, "No pudimos publicar tu artículo. Probá de nuevo en un rato.");
            AvisarFotosDeNuevo(fotos);
            return View();
        }
    }

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

    private void AvisarFotosDeNuevo(List<IFormFile> fotos)
    {
        if (fotos.Count > 0 && ModelState["Fotos"]?.Errors.Count is null or 0)
        {
            ModelState.AddModelError("Fotos", "Volvé a elegir las fotos antes de publicar.");
        }
    }

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
