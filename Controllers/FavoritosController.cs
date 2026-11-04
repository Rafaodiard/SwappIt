using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Swappit.Models;
using Swappit.Models.ViewModels;

namespace Swappit.Controllers;

// Favoritos del usuario logueado (/Favoritos). Solo con sesión iniciada.
// Por ahora los IDs favoritos viven en el navegador (localStorage, ver wwwroot/js/favoritos.js):
// - GET /Favoritos: la página, con la lista vacía.
// - GET /Favoritos/Tarjetas?ids=3&ids=8: las cards de esos artículos (partial). La pide favoritos-lista.js.
// TODO backend: cuando exista la tabla de favoritos, Tarjetas tiene que leer los IDs de la BD
// (por usuario) en lugar de recibirlos por la URL, y la página puede armarse directo desde el servidor.
public class FavoritosController : Controller
{
    // Tope de IDs que se aceptan en la URL.
    private const int MaxFavoritos = 100;

    private readonly ILogger<FavoritosController> _logger;

    public FavoritosController(ILogger<FavoritosController> logger)
    {
        _logger = logger;
    }

    public IActionResult Index()
    {
        if (HttpContext.Session.GetInt32("UsuarioId") == null)
        {
            return RedirectToAction("Index", "Account");
        }

        return View();
    }

    // ids: en el orden en que se quieren mostrar (favoritos-lista.js manda primero los más nuevos).
    // Solo devuelve los artículos que siguen disponibles (los mismos que se ven en el catálogo);
    // los que ya se intercambiaron o se borraron no aparecen.
    public IActionResult Tarjetas(int[]? ids)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return Unauthorized();
        }

        List<int> pedidos = (ids ?? []).Where(id => id > 0).Distinct().Take(MaxFavoritos).ToList();
        List<ArticuloCardViewModel> articulos = new List<ArticuloCardViewModel>();

        if (pedidos.Count > 0)
        {
            try
            {
                // TODO backend: reemplazar por una consulta que traiga solo los favoritos del usuario.
                // Mientras tanto se reusa el catálogo (sin los artículos propios) y se filtra acá.
                Dictionary<int, ArticuloCardViewModel> disponibles = BD.GetArticulosCatalogo(excluirUsuario: usuarioId)
                    .ToDictionary(a => a.IdArticulos);
                articulos = pedidos.Where(disponibles.ContainsKey).Select(id => disponibles[id]).ToList();
            }
            catch (SqlException ex)
            {
                _logger.LogError(ex, "No se pudieron cargar los favoritos del usuario {IdUsuario}", usuarioId);
                return StatusCode(StatusCodes.Status503ServiceUnavailable);
            }
        }

        ViewBag.articulos = articulos;
        return PartialView("_Tarjetas");
    }
}
