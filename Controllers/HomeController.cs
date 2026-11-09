using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Swappit.Models;
using Swappit.Models.ViewModels;

namespace Swappit.Controllers;

public class HomeController : Controller
{
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
            ViewBag.destacados = RecomendacionesController.Destacados(null, CantidadDestacadosLanding);
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron cargar los artículos destacados");
            ViewBag.destacados = new List<ArticuloCardViewModel>();
        }
        return View();
    }

    private IActionResult Inicio(int usuarioId)
    {
        ViewBag.nombre = null;
        ViewBag.intercambios = new List<IntercambioViewModel>();
        ViewBag.porResponder = 0;
        ViewBag.cantidadEnCurso = 0;
        ViewBag.cantidadArticulos = 0;
        ViewBag.destacados = new List<ArticuloCardViewModel>();
        ViewBag.mensajesSinLeer = null;
        ViewBag.errorCarga = false;
        try
        {
            ViewBag.nombre = BD.GetUsuarioById(usuarioId)?.Nombre;

            List<IntercambioViewModel> enCurso = BD.GetIntercambios(usuarioId)
                .Where(i => i.Estado == EstadosIntercambios.Pendiente || i.Estado == EstadosIntercambios.Aceptado)
                .ToList();

            ViewBag.intercambios = enCurso.OrderByDescending(PorResponder).Take(CantidadIntercambiosInicio).ToList();
            ViewBag.porResponder = enCurso.Count(PorResponder);
            ViewBag.cantidadEnCurso = enCurso.Count;
            ViewBag.cantidadArticulos = BD.GetArticulosCatalogo(idUsuario: usuarioId).Count;
            ViewBag.destacados = RecomendacionesController.Destacados(usuarioId, CantidadDestacadosInicio);
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo cargar el inicio del usuario {UsuarioId}", usuarioId);
            ViewBag.errorCarga = true;
        }

        try
        {
            ViewBag.mensajesSinLeer = BD.GetResumenesChat(usuarioId).Sum(r => r.NoLeidos);
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron contar los mensajes sin leer del usuario {UsuarioId}", usuarioId);
        }

        return View("Inicio");
    }

    private const int CantidadIntercambiosInicio = 4;
    private const int CantidadDestacadosInicio = 9;
    private const int CantidadDestacadosLanding = 4;

    private static bool PorResponder(IntercambioViewModel i)
    {
        return i.EsRecibido && i.Estado == EstadosIntercambios.Pendiente;
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
