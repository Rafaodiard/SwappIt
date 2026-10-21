using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
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
        return View();
    }

    public IActionResult Privacy()
    {
        return View();
    }

    public IActionResult Perfil()
    {
        return View();
    }

    public IActionResult Buscar(string? q)
    {
        return View();
    }

    public IActionResult Chat()
    {
        return View();
    }

    // ===== Registro =====
    [HttpGet]
    public IActionResult Registro()
    {
        return View(new RegistroViewModel());
    }

    [HttpPost]
    public IActionResult Registro(RegistroViewModel modelo)
    {
        if (!ModelState.IsValid) return View(modelo);

        // TODO: crear el usuario (validar que el mail no exista, hashear la contraseña,
        // calcular Edad a partir de FechaNacimiento) y redirigir a Login.
        return View(modelo);
    }

    // ===== Login =====
    [HttpGet]
    public IActionResult Login()
    {
        return View(new LoginViewModel());
    }

    [HttpPost]
    public IActionResult Login(LoginViewModel modelo)
    {
        if (!ModelState.IsValid) return View(modelo);

        // TODO: validar credenciales e iniciar sesión.
        // Si fallan: ModelState.AddModelError(string.Empty, "Email o contraseña incorrectos");
        return View(modelo);
    }

    // ===== Publicar objeto =====
    [HttpGet]
    public IActionResult Publicar()
    {
        // TODO: requerir usuario logueado.
        return View(new PublicarArticuloViewModel { Categorias = ObtenerCategorias() });
    }

    [HttpPost]
    public IActionResult Publicar(PublicarArticuloViewModel modelo)
    {
        // TODO: requerir usuario logueado.
        modelo.Categorias = ObtenerCategorias();
        if (!ModelState.IsValid) return View(modelo);

        // TODO: guardar el artículo (y sus fotos) con IdUsuarios del usuario logueado.
        return View(modelo);
    }

    // TODO: reemplazar por la consulta a la tabla Categorias.
    private static IEnumerable<SelectListItem> ObtenerCategorias() => new List<SelectListItem>
    {
        new("Muebles", "1"),
        new("Electrodomésticos", "2"),
        new("Cocina y vajilla", "3"),
        new("Decoración", "4"),
        new("Iluminación", "5"),
        new("Ropa de cama", "6"),
    };

    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
        return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
    }
}
