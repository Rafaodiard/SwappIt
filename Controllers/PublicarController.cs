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
        bool limiteAlcanzado = false;
        try
        {
            publicar.Ubicacion = UsuariosBD.GetUsuarioById(usuarioId.Value)?.Barrio ?? string.Empty;
            limiteAlcanzado = ArticulosBD.ContarArticulosActivos(usuarioId.Value) >= PublicarArticuloViewModel.MaxPublicados;
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron leer los datos del usuario {IdUsuario}", usuarioId);
        }

        ViewBag.publicar = publicar;
        ViewBag.limiteAlcanzado = limiteAlcanzado;
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
        if (modelo.IdCategorias.HasValue && !EstaEnLista(categorias, modelo.IdCategorias.Value))
        {
            ModelState.AddModelError(nameof(modelo.IdCategorias), "Elegí una categoría de la lista");
        }
        if (modelo.IdCategoriaACambio.HasValue && !EstaEnLista(categorias, modelo.IdCategoriaACambio.Value))
        {
            ModelState.AddModelError(nameof(modelo.IdCategoriaACambio), "Elegí una categoría de la lista o dejalo abierto a propuestas");
        }
        List<EstadosArticulos> estados = ObtenerEstados();
        if (modelo.IdEstado.HasValue && !ExisteEstado(estados, modelo.IdEstado.Value))
        {
            ModelState.AddModelError(nameof(modelo.IdEstado), "Elegí uno de los estados de la lista");
        }

        List<IFormFile> fotos = new List<IFormFile>();
        foreach (IFormFile foto in modelo.Fotos ?? [])
        {
            if (foto.Length > 0)
            {
                fotos.Add(foto);
            }
        }
        ValidarFotos(fotos);

        ViewBag.publicar = modelo;
        ViewBag.categorias = categorias;
        ViewBag.estados = estados;
        ViewBag.limiteAlcanzado = false;
        if (!ModelState.IsValid)
        {
            AvisarFotosDeNuevo(fotos);
            return View();
        }

        if (ArticulosBD.ContarArticulosActivos(usuarioId.Value) >= PublicarArticuloViewModel.MaxPublicados)
        {
            ViewBag.limiteAlcanzado = true;
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
            int idArticulo = ArticulosBD.PublicarArticulo(articulo, rutasFotos);

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
        bool extensionInvalida = false;
        bool muyPesada = false;
        foreach (IFormFile foto in fotos)
        {
            if (Array.IndexOf(PublicarArticuloViewModel.ExtensionesFoto, Path.GetExtension(foto.FileName).ToLower()) < 0)
            {
                extensionInvalida = true;
            }
            if (foto.Length > PublicarArticuloViewModel.MaxFotoMB * 1024 * 1024)
            {
                muyPesada = true;
            }
        }

        if (fotos.Count > PublicarArticuloViewModel.MaxFotos)
        {
            ModelState.AddModelError("Fotos", $"Podés subir hasta {PublicarArticuloViewModel.MaxFotos} fotos.");
        }
        else if (extensionInvalida)
        {
            ModelState.AddModelError("Fotos", "Las fotos tienen que ser JPG o PNG.");
        }
        else if (muyPesada)
        {
            ModelState.AddModelError("Fotos", $"Cada foto puede pesar hasta {PublicarArticuloViewModel.MaxFotoMB} MB.");
        }
    }

    private static bool EstaEnLista(List<SelectListItem> opciones, int valor)
    {
        foreach (SelectListItem opcion in opciones)
        {
            if (opcion.Value == valor.ToString())
            {
                return true;
            }
        }
        return false;
    }

    private static bool ExisteEstado(List<EstadosArticulos> estados, int idEstado)
    {
        foreach (EstadosArticulos estado in estados)
        {
            if (estado.IdEstadosArticulos == idEstado)
            {
                return true;
            }
        }
        return false;
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
            List<SelectListItem> opciones = new List<SelectListItem>();
            foreach (Categorias c in ArticulosBD.GetCategorias())
            {
                opciones.Add(new SelectListItem(c.Nombre, c.IdCategorias.ToString()));
            }
            return opciones;
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
            return ArticulosBD.GetEstadosArticulos();
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron cargar los estados");
            return new List<EstadosArticulos>();
        }
    }
}
