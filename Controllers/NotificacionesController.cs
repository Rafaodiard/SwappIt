using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Swappit.Models;
using Swappit.Models.ViewModels;

namespace Swappit.Controllers;

// Notificaciones del pop up del header (campana de _Layout). Las usa notificaciones.js:
// - GET /Notificaciones/Lista: la lista del pop up (partial), se pide cada vez que se abre.
// - GET /Notificaciones/NoLeidas: cuántas sin leer hay, para el contador de la campana.
// - POST /Notificaciones/Ver/5: la marca como leída y lleva al intercambio.
// - POST /Notificaciones/MarcarTodasLeidas: botón "Marcar todas como leídas".
// Las notificaciones se crean en BD.ProponerIntercambio y BD.CambiarEstadoIntercambio.
public class NotificacionesController : Controller
{
    // Las del pop up (las más nuevas).
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
            notificaciones = BD.GetNotificaciones(usuarioId.Value, CantidadEnPopup);
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
            return Json(new { cantidad = BD.GetCantidadNotificacionesNoLeidas(usuarioId.Value) });
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

        int? idIntercambio;
        try
        {
            idIntercambio = BD.MarcarNotificacionLeida(id, usuarioId.Value);
        }
        catch (SqlException ex)
        {
            // Sin el intercambio de la notificación, se va a Mis intercambios (que avisa si la base no responde).
            _logger.LogError(ex, "No se pudo marcar como leída la notificación {IdNotificacion}", id);
            return RedirectToAction("Index", "Intercambio");
        }

        // No es del usuario o no existe.
        if (idIntercambio == null)
        {
            return NotFound();
        }
        return RedirectToAction("Detalle", "Intercambio", new { id = idIntercambio });
    }

    // Lo llama notificaciones.js con fetch; después vuelve a pedir la lista y el contador.
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
            BD.MarcarNotificacionesLeidas(usuarioId.Value);
            return NoContent();
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron marcar como leídas las notificaciones del usuario {IdUsuario}", usuarioId);
            return StatusCode(StatusCodes.Status500InternalServerError);
        }
    }
}
