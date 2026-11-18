using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Swappit.Models;
using Swappit.Models.ViewModels;

namespace Swappit.Controllers;

public class HomeController : BaseController
{
    private const int CantidadIntercambiosInicio = 4;
    private const int CantidadDestacadosInicio = 9;
    private const int CantidadDestacadosLanding = 4;

    private readonly ILogger<HomeController> _logger;

    public HomeController(ILogger<HomeController> logger)
    {
        _logger = logger;
    }

    public IActionResult Index()
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId != null)
        {
            return Inicio(usuarioId.Value);
        }

        try
        {
            ViewBag.destacados = Recomendaciones.Destacados(null, CantidadDestacadosLanding);
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron cargar los artículos destacados");
            ViewBag.destacados = new List<ArticuloCardViewModel>();
        }

        try
        {
            ViewBag.planes = Suscripciones.Planes();
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron cargar los planes");
            ViewBag.planes = new List<PlanViewModel>();
        }
        return View();
    }

    private IActionResult Inicio(int usuarioId)
    {
        ViewBag.saludo = Inicios.Saludo(null);
        ViewBag.intercambios = new List<IntercambioViewModel>();
        ViewBag.porResponder = 0;
        ViewBag.textoVerTodos = "Ver todos";
        ViewBag.cantidadArticulos = 0;
        ViewBag.destacados = new List<ArticuloCardViewModel>();
        ViewBag.mensajesSinLeer = null;
        ViewBag.errorCarga = false;
        ViewBag.estadoPendiente = EstadosIntercambios.Pendiente;
        ViewBag.ordenParaVos = Recomendaciones.OrdenParaVos;
        ViewBag.planes = new List<PlanViewModel>();
        ViewBag.idPlanActual = null;
        try
        {
            Usuarios? usuario = UsuariosBD.GetUsuarioById(usuarioId);
            ViewBag.saludo = Inicios.Saludo(usuario?.Nombre);
            ViewBag.idPlanActual = usuario?.IdPlan;
            ResumenEnCurso enCurso = GestionIntercambios.ContarEnCurso(usuarioId);
            List<IntercambioViewModel> intercambios = IntercambiosBD.GetIntercambios(usuarioId, enCurso: true, cantidad: CantidadIntercambiosInicio);

            ViewBag.intercambios = intercambios;
            ViewBag.porResponder = enCurso.PorResponder;
            ViewBag.textoVerTodos = Inicios.TextoVerTodos(enCurso.Cantidad, intercambios.Count);
            ViewBag.cantidadArticulos = ArticulosBD.ContarArticulosActivos(usuarioId);
            ViewBag.destacados = Recomendaciones.Destacados(usuarioId, CantidadDestacadosInicio);
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo cargar el inicio del usuario {UsuarioId}", usuarioId);
            ViewBag.errorCarga = true;
        }

        try
        {
            ViewBag.planes = Suscripciones.Planes();
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron cargar los planes");
        }

        try
        {
            ViewBag.mensajesSinLeer = ChatBD.ContarMensajesNoLeidos(usuarioId);
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron contar los mensajes sin leer del usuario {UsuarioId}", usuarioId);
        }

        return View("Inicio");
    }

    public IActionResult Privacy()
    {
        return View();
    }

    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
        ViewBag.requestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier;
        return View();
    }
}
