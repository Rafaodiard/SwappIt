using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Swappit.Models;
using Swappit.Models.ViewModels;

namespace Swappit.Controllers;

// Favoritos del usuario logueado. Se guardan en la tabla Interacciones con el tipo "Favorito"
// (una fila por artículo mientras siga siendo favorito). El algoritmo de recomendaciones también los usa
// (RecomendacionesController): un favorito es la señal de gusto que más pesa.
// - GET  /Favoritos: la página con las cards de los favoritos.
// - GET  /Favoritos/Ids: los IDs de los favoritos, para que favoritos.js pinte los corazones de cualquier página.
// - POST /Favoritos/Alternar: marca o desmarca un favorito (corazón de las cards).
// - POST /Favoritos/Importar: pasa a la BD los favoritos que quedaron guardados en el navegador de antes (localStorage).
public class FavoritosController : Controller
{
    // Tope de IDs que se aceptan al importar.
    private const int MaxImportar = 100;

    private readonly ILogger<FavoritosController> _logger;

    public FavoritosController(ILogger<FavoritosController> logger)
    {
        _logger = logger;
    }

    // Solo los que siguen disponibles (los mismos que se ven en el catálogo); el último que marcaste primero.
    public IActionResult Index()
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return RedirectToAction("Index", "Account");
        }

        ViewBag.articulos = new List<ArticuloCardViewModel>();
        ViewBag.errorCarga = false;
        try
        {
            ViewBag.articulos = BD.GetFavoritos(usuarioId.Value);
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron cargar los favoritos del usuario {IdUsuario}", usuarioId);
            ViewBag.errorCarga = true;
        }
        return View();
    }

    [HttpGet]
    public IActionResult Ids()
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return Unauthorized();
        }

        try
        {
            return Json(BD.GetIdsFavoritos(usuarioId.Value));
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron leer los favoritos del usuario {IdUsuario}", usuarioId);
            return StatusCode(StatusCodes.Status503ServiceUnavailable);
        }
    }

    // Devuelve { esFavorito } con cómo quedó. 404 si el artículo no existe o es tuyo.
    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Alternar(int idArticulo)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return Unauthorized();
        }

        try
        {
            bool? esFavorito = BD.AlternarFavorito(usuarioId.Value, idArticulo);
            if (esFavorito == null)
            {
                return NotFound();
            }
            return Json(new { esFavorito });
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo cambiar el favorito {IdArticulo} del usuario {IdUsuario}", idArticulo, usuarioId);
            return StatusCode(StatusCodes.Status503ServiceUnavailable);
        }
    }

    // Antes los favoritos vivían solo en el navegador: favoritos.js los manda una vez y después los borra de ahí.
    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Importar(int[]? ids)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return Unauthorized();
        }

        List<int> pedidos = (ids ?? []).Where(id => id > 0).Distinct().Take(MaxImportar).ToList();
        try
        {
            BD.ImportarFavoritos(usuarioId.Value, pedidos);
            return Json(BD.GetIdsFavoritos(usuarioId.Value));
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron importar los favoritos del usuario {IdUsuario}", usuarioId);
            return StatusCode(StatusCodes.Status503ServiceUnavailable);
        }
    }
}
