using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Swappit.Models;
using Swappit.Models.ViewModels;

namespace Swappit.Controllers;

public class FavoritosController : Controller
{
    private const int MaxImportar = 100;

    private readonly ILogger<FavoritosController> _logger;

    public FavoritosController(ILogger<FavoritosController> logger)
    {
        _logger = logger;
    }

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
