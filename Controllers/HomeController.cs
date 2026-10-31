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

    // "/" muestra la landing a quien no inició sesión y el inicio (Views/Home/Inicio.cshtml) a quien sí.
    public IActionResult Index()
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId != null)
        {
            return Inicio(usuarioId.Value);
        }

        try
        {
            ViewBag.destacados = BD.GetArticulosCatalogo(cantidad: 4);
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron cargar los artículos destacados");
            ViewBag.destacados = new List<ArticuloCardViewModel>();
        }
        return View();
    }

    // Inicio del usuario logueado: sus intercambios en curso (primero los que tiene que responder),
    // un resumen de lo que tiene pendiente y artículos recomendados de los demás.
    private IActionResult Inicio(int usuarioId)
    {
        ViewBag.nombre = null;
        ViewBag.intercambios = new List<IntercambioViewModel>();
        ViewBag.porResponder = 0;
        ViewBag.cantidadEnCurso = 0;
        ViewBag.cantidadArticulos = 0;
        ViewBag.recomendados = new List<ArticuloCardViewModel>();
        ViewBag.mensajesSinLeer = null;
        ViewBag.errorCarga = false;
        try
        {
            ViewBag.nombre = BD.GetUsuarioById(usuarioId)?.Nombre;

            List<IntercambioViewModel> enCurso = BD.GetIntercambios(usuarioId)
                .Where(i => i.Estado == EstadosIntercambios.Pendiente || i.Estado == EstadosIntercambios.Aceptado)
                .ToList();

            // GetIntercambios ya viene del más nuevo al más viejo: acá solo se suben los que esperan respuesta.
            ViewBag.intercambios = enCurso.OrderByDescending(PorResponder).Take(CantidadIntercambiosInicio).ToList();
            ViewBag.porResponder = enCurso.Count(PorResponder);
            ViewBag.cantidadEnCurso = enCurso.Count;
            ViewBag.cantidadArticulos = BD.GetArticulosCatalogo(idUsuario: usuarioId).Count;
            // Por ahora los recomendados son los últimos artículos disponibles de los demás:
            // no hay datos de gustos ni de búsquedas del usuario para elegirlos de otra forma.
            ViewBag.recomendados = BD.GetArticulosCatalogo(cantidad: CantidadRecomendadosInicio, excluirUsuario: usuarioId);
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo cargar el inicio del usuario {UsuarioId}", usuarioId);
            ViewBag.errorCarga = true;
        }

        // Aparte: si falta correr BaseDatos/Chat.sql no se rompe todo el inicio, solo no se muestra ese número.
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
    private const int CantidadRecomendadosInicio = 9;

    // Propuesta que le llegó al usuario y que todavía tiene que aceptar o rechazar.
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
