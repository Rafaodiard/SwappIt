using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Swappit.Models;
using Swappit.Models.ViewModels;

namespace Swappit.Controllers;

public class NotificacionesController : Controller
{
    private const int CantidadEnPopup = 20;

    private readonly ILogger<NotificacionesController> _logger;

    public NotificacionesController(ILogger<NotificacionesController> logger)
    {
        _logger = logger;
    }

    public IActionResult Lista()
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return Unauthorized();
        }

        List<NotificacionViewModel> notificaciones = new List<NotificacionViewModel>();
        bool errorCarga = false;
        try
        {
            notificaciones = NotificacionesBD.GetNotificaciones(usuarioId.Value, CantidadEnPopup);
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron cargar las notificaciones del usuario {IdUsuario}", usuarioId);
            errorCarga = true;
        }

        ViewBag.notificaciones = notificaciones;
        ViewBag.errorCarga = errorCarga;
        return PartialView("_Lista");
    }

    public IActionResult NoLeidas()
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return Unauthorized();
        }

        try
        {
            return Json(new { cantidad = NotificacionesBD.GetCantidadNotificacionesNoLeidas(usuarioId.Value) });
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo contar las notificaciones del usuario {IdUsuario}", usuarioId);
            return StatusCode(StatusCodes.Status500InternalServerError);
        }
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Ver(int id)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return RedirectToAction("Index", "Account");
        }

        NotificacionViewModel? notificacion;
        try
        {
            notificacion = NotificacionesBD.MarcarNotificacionLeida(id, usuarioId.Value);
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo marcar como leída la notificación {IdNotificacion}", id);
            return RedirectToAction("Index", "Intercambio");
        }

        if (notificacion == null)
        {
            return NotFound();
        }
        if (notificacion.Tipo == TipoNotificaciones.MensajeNuevo)
        {
            return RedirectToAction("Index", "Chat", new { id = notificacion.IdIntercambio });
        }
        return RedirectToAction("Detalle", "Intercambio", new { id = notificacion.IdIntercambio });
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult MarcarTodasLeidas()
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return Unauthorized();
        }

        try
        {
            NotificacionesBD.MarcarNotificacionesLeidas(usuarioId.Value);
            return NoContent();
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron marcar como leídas las notificaciones del usuario {IdUsuario}", usuarioId);
            return StatusCode(StatusCodes.Status500InternalServerError);
        }
    }
}
