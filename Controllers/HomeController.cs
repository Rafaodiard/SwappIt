using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Swappit.Models;
using Swappit.Models.ViewModels;

namespace Swappit.Controllers;

// Páginas generales del sitio: inicio, términos y privacidad, y la página de error.
public class HomeController : Controller
{
    private readonly ILogger<HomeController> _logger;

    public HomeController(ILogger<HomeController> logger)
    {
        _logger = logger;
    }

    public IActionResult Index()
    {
        // Objetos destacados: los 4 más recientes. Si la BD falla, la home se muestra igual sin destacados.
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
