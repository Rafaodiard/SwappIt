using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Swappit.Models;

namespace Swappit.Controllers;

public class RecomendacionesController : BaseController
{
    private readonly ILogger<RecomendacionesController> _logger;

    public RecomendacionesController(ILogger<RecomendacionesController> logger)
    {
        _logger = logger;
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Vista(int idArticulo)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return Unauthorized();
        }

        try
        {
            int? idInteraccion = Recomendaciones.RegistrarVista(usuarioId.Value, idArticulo);
            if (idInteraccion == null)
            {
                return NoContent();
            }
            return Json(new { idInteraccion });
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo registrar la vista del artículo {IdArticulo}", idArticulo);
            return StatusCode(StatusCodes.Status503ServiceUnavailable);
        }
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Tiempo(int idInteraccion, int segundos)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return Unauthorized();
        }

        try
        {
            Recomendaciones.GuardarTiempo(idInteraccion, usuarioId.Value, segundos);
            return NoContent();
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo guardar el tiempo de la vista {IdInteraccion}", idInteraccion);
            return StatusCode(StatusCodes.Status503ServiceUnavailable);
        }
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Busqueda(string? texto, int[]? categorias)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return Unauthorized();
        }

        try
        {
            Recomendaciones.RegistrarBusqueda(usuarioId.Value, texto, categorias);
            return NoContent();
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo registrar la búsqueda del usuario {IdUsuario}", usuarioId);
            return StatusCode(StatusCodes.Status503ServiceUnavailable);
        }
    }
}
