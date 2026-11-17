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
            ViewBag.nombre = UsuariosBD.GetUsuarioById(usuarioId)?.Nombre;

            int porResponder = 0;
            int cantidadEnCurso = 0;
            foreach (CantidadPorEstado c in IntercambiosBD.ContarIntercambiosPorEstado(usuarioId))
            {
                if (c.Estado == EstadosIntercambios.Pendiente || c.Estado == EstadosIntercambios.Aceptado)
                {
                    cantidadEnCurso += c.Cantidad;
                    porResponder += c.PorResponder;
                }
            }

            ViewBag.intercambios = IntercambiosBD.GetIntercambios(usuarioId, enCurso: true, cantidad: CantidadIntercambiosInicio);
            ViewBag.porResponder = porResponder;
            ViewBag.cantidadEnCurso = cantidadEnCurso;
            ViewBag.cantidadArticulos = ArticulosBD.ContarArticulosActivos(usuarioId);
            ViewBag.destacados = RecomendacionesController.Destacados(usuarioId, CantidadDestacadosInicio);
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo cargar el inicio del usuario {UsuarioId}", usuarioId);
            ViewBag.errorCarga = true;
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

    private const int CantidadIntercambiosInicio = 4;
    private const int CantidadDestacadosInicio = 9;
    private const int CantidadDestacadosLanding = 4;

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
