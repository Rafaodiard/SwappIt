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
