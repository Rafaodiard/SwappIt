using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Data.SqlClient;
using Swappit.Models;
using Swappit.Models.ViewModels;

namespace Swappit.Controllers;

public class PublicarController : BaseController
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
        PlanViewModel? plan = null;
        bool limiteAlcanzado = false;
        try
        {
            publicar = Publicaciones.Nueva(usuarioId.Value);
            plan = PlanesBD.GetPlanDeUsuario(usuarioId.Value);
            limiteAlcanzado = Publicaciones.LimiteAlcanzado(usuarioId.Value, plan);
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron leer los datos del usuario {IdUsuario}", usuarioId);
        }

        CargarFormulario(publicar, ObtenerCategorias(), ObtenerEstados(), limiteAlcanzado, plan);
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
        List<EstadosArticulos> estados = ObtenerEstados();
        List<IFormFile> fotos = Publicaciones.FotosConContenido(modelo.Fotos);
        Formularios.AgregarErrores(ModelState, Publicaciones.Validar(modelo, categorias, estados, fotos));

        PlanViewModel? plan = PlanesBD.GetPlanDeUsuario(usuarioId.Value);
        CargarFormulario(modelo, categorias, estados, false, plan);
        if (!ModelState.IsValid)
        {
            Publicaciones.AvisarFotosDeNuevo(ModelState, fotos);
            return View();
        }

        if (Publicaciones.LimiteAlcanzado(usuarioId.Value, plan))
        {
            ViewBag.limiteAlcanzado = true;
            return View();
        }

        try
        {
            int idArticulo = Publicaciones.Publicar(modelo, usuarioId.Value, fotos, _env.WebRootPath);
            TempData["MensajeArticulo"] = "¡Listo! Tu artículo ya está publicado.";
            return RedirectToAction("Detalle", "Articulos", new { id = idArticulo });
        }
        catch (Exception ex) when (ex is SqlException or IOException or UnauthorizedAccessException)
        {
            _logger.LogError(ex, "No se pudo publicar el artículo del usuario {IdUsuario}", usuarioId);
            ModelState.AddModelError(string.Empty, "No pudimos publicar tu artículo. Probá de nuevo en un rato.");
            Publicaciones.AvisarFotosDeNuevo(ModelState, fotos);
            return View();
        }
    }

    [HttpGet]
    public IActionResult Editar(int id)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null) return RedirectToAction("Index", "Account");

        Articulos? articulo = ArticulosBD.GetArticuloById(id);
        if (articulo == null || articulo.IdUsuarios != usuarioId.Value)
        {
            return RedirectToAction("Detalle", "Articulos", new { id });
        }

        PublicarArticuloViewModel modelo = new PublicarArticuloViewModel
        {
            IdArticulo = id,
            Titulo = articulo.Nombre ?? string.Empty,
            Descripcion = articulo.Descripcion ?? string.Empty,
            IdCategorias = articulo.IdCategorias,
            IdCategoriaACambio = articulo.IdCategoriaACambio,
            IdEstado = articulo.IdEstado,
            Ubicacion = articulo.Ubicacion ?? string.Empty,
            FotosExistentes = ArticulosBD.GetImagenesArticulo(id)
        };

        CargarFormulario(modelo, ObtenerCategorias(), ObtenerEstados(), false, null);
        ViewBag.esEdicion = true;
        return View("Index", modelo);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    [RequestSizeLimit(LimitePedidoPublicar)]
    [RequestFormLimits(MultipartBodyLengthLimit = LimitePedidoPublicar)]
    public IActionResult Editar(PublicarArticuloViewModel modelo)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null) return RedirectToAction("Index", "Account");
        if (!modelo.IdArticulo.HasValue) return RedirectToAction("Index", "Perfil");

        Articulos? actual = ArticulosBD.GetArticuloById(modelo.IdArticulo.Value);
        if (actual == null || actual.IdUsuarios != usuarioId.Value)
        {
            return RedirectToAction("Detalle", "Articulos", new { id = modelo.IdArticulo.Value });
        }

        List<SelectListItem> categorias = ObtenerCategorias();
        List<EstadosArticulos> estados = ObtenerEstados();
        List<IFormFile> fotos = Publicaciones.FotosConContenido(modelo.Fotos);
        Formularios.AgregarErrores(ModelState, Publicaciones.Validar(modelo, categorias, estados, fotos));

        List<string> existentes = ArticulosBD.GetImagenesArticulo(modelo.IdArticulo.Value);
        List<string> eliminar = modelo.FotosEliminar ?? new List<string>();
        int totalFinal = existentes.Count(e => !eliminar.Contains(e)) + fotos.Count;
        if (totalFinal > PublicarArticuloViewModel.MaxFotos)
        {
            ModelState.AddModelError("Fotos", $"Podés tener hasta {PublicarArticuloViewModel.MaxFotos} fotos.");
        }

        CargarFormulario(modelo, categorias, estados, false, null);
        modelo.FotosExistentes = existentes;
        ViewBag.esEdicion = true;
        if (!ModelState.IsValid)
        {
            return View("Index", modelo);
        }

        try
        {
            if (!Publicaciones.Editar(modelo, usuarioId.Value, modelo.IdArticulo.Value, fotos, _env.WebRootPath))
            {
                TempData["ErrorArticulo"] = "No pudimos editar el artículo.";
                return RedirectToAction("Detalle", "Articulos", new { id = modelo.IdArticulo.Value });
            }
            TempData["MensajeArticulo"] = "Cambios guardados.";
            return RedirectToAction("Detalle", "Articulos", new { id = modelo.IdArticulo.Value });
        }
        catch (Exception ex) when (ex is SqlException or IOException or UnauthorizedAccessException)
        {
            _logger.LogError(ex, "No se pudo editar el artículo {IdArticulo}", modelo.IdArticulo);
            ModelState.AddModelError(string.Empty, "No pudimos guardar los cambios. Probá de nuevo.");
            return View("Index", modelo);
        }
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Eliminar(int id)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null) return RedirectToAction("Index", "Account");

        int resultado = ArticulosBD.EliminarArticulo(id, usuarioId.Value);
        if (resultado == 1)
        {
            TempData["MensajePerfil"] = "La publicación fue eliminada.";
            return RedirectToAction("Index", "Perfil");
        }
        if (resultado == 2)
        {
            TempData["ErrorArticulo"] = "No se puede eliminar una publicación que participa en un intercambio.";
        }
        else
        {
            TempData["ErrorArticulo"] = "No pudimos eliminar esta publicación.";
        }
        return RedirectToAction("Detalle", "Articulos", new { id });
    }

    private void CargarFormulario(PublicarArticuloViewModel publicar, List<SelectListItem> categorias, List<EstadosArticulos> estados, bool limiteAlcanzado, PlanViewModel? plan)
    {
        ViewBag.plan = plan;
        ViewBag.publicar = publicar;
        ViewBag.categorias = categorias;
        ViewBag.estados = estados;
        ViewBag.limiteAlcanzado = limiteAlcanzado;
        ViewBag.requeridos = Publicaciones.MensajesRequeridos();
        ViewBag.categoriaElegida = publicar.IdCategorias?.ToString();
        ViewBag.categoriaACambioElegida = publicar.IdCategoriaACambio?.ToString();
        ViewBag.maxFotos = PublicarArticuloViewModel.MaxFotos;
        ViewBag.maxFotoMB = PublicarArticuloViewModel.MaxFotoMB;
        ViewBag.maxDescripcion = PublicarArticuloViewModel.MaxDescripcion;
    }

    private List<SelectListItem> ObtenerCategorias()
    {
        try
        {
            return Publicaciones.OpcionesCategorias();
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
