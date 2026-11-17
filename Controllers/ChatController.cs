using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Swappit.Models;
using Swappit.Models.ViewModels;
using Swappit.Services;

namespace Swappit.Controllers;

public class ChatController : Controller
{
    private readonly ILogger<ChatController> _logger;
    private readonly EmailService _emailService;

    public ChatController(ILogger<ChatController> logger, EmailService emailService)
    {
        _logger = logger;
        _emailService = emailService;
    }

    public IActionResult Index(int? id)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return RedirectToAction("Index", "Account");
        }

        List<IntercambioViewModel> conversaciones = new List<IntercambioViewModel>();
        Dictionary<int, ConversacionViewModel> resumenes = new Dictionary<int, ConversacionViewModel>();
        IntercambioViewModel? abierta = null;
        List<Mensajes> mensajes = new List<Mensajes>();
        bool errorCarga = false;
        try
        {
            List<IntercambioViewModel> intercambios = IntercambiosBD.GetIntercambios(usuarioId.Value);
            resumenes = ChatBD.GetResumenesChat(usuarioId.Value).ToDictionary(r => r.IdIntercambio);

            conversaciones = intercambios
                .Where(i => PuedeEscribir(i, false) || resumenes.ContainsKey(i.IdIntercambios))
                .OrderByDescending(i => resumenes.TryGetValue(i.IdIntercambios, out ConversacionViewModel? r) ? r.UltimaFecha : i.Fecha)
                .ToList();

            abierta = id == null ? conversaciones.FirstOrDefault() : intercambios.FirstOrDefault(i => i.IdIntercambios == id);
            if (abierta != null)
            {
                ChatBD.MarcarMensajesVistos(abierta.IdIntercambios, usuarioId.Value);
                mensajes = ChatBD.GetMensajes(abierta.IdIntercambios, usuarioId.Value);
                ViewBag.fotoOtro = UsuariosBD.GetFotoUsuario(abierta.OtroIdUsuario);
                if (resumenes.TryGetValue(abierta.IdIntercambios, out ConversacionViewModel? resumen))
                {
                    resumen.NoLeidos = 0;
                }
            }
            else if (id != null)
            {
                Response.StatusCode = StatusCodes.Status404NotFound;
            }
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo cargar el chat del usuario {IdUsuario}", usuarioId);
            errorCarga = true;
        }

        ViewBag.conversaciones = conversaciones;
        ViewBag.resumenes = resumenes;
        ViewBag.abierta = abierta;
        ViewBag.mensajes = mensajes;
        ViewBag.puedeEscribir = abierta != null && PuedeEscribir(abierta, mensajes.Any(m => m.IdUsuariosManda == abierta.OtroIdUsuario));
        ViewBag.usuarioId = usuarioId.Value;
        ViewBag.idPedido = id;
        ViewBag.errorCarga = errorCarga;
        return View();
    }

    public IActionResult Mensajes(int id)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return Unauthorized();
        }

        try
        {
            ChatBD.MarcarMensajesVistos(id, usuarioId.Value);
            ViewBag.mensajes = ChatBD.GetMensajes(id, usuarioId.Value);
            ViewBag.usuarioId = usuarioId.Value;
            return PartialView("_Mensajes");
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron cargar los mensajes del intercambio {IdIntercambio}", id);
            return StatusCode(StatusCodes.Status500InternalServerError);
        }
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Enviar(int id, string? texto)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return RedirectToAction("Index", "Account");
        }

        texto = texto?.Trim();
        if (string.IsNullOrEmpty(texto))
        {
            return RedirectToAction("Index", new { id });
        }
        if (texto.Length > Models.Mensajes.LargoMaximoTexto)
        {
            TempData["ErrorChat"] = $"El mensaje puede tener hasta {Models.Mensajes.LargoMaximoTexto} caracteres.";
            TempData["TextoChat"] = texto;
            return RedirectToAction("Index", new { id });
        }

        try
        {
            List<NotificacionCreada> creadas = new List<NotificacionCreada>();
            if (!ChatBD.EnviarMensaje(id, usuarioId.Value, texto, creadas))
            {
                TempData["ErrorChat"] = "No se pudo mandar el mensaje: este intercambio ya no está en curso.";
            }
            _emailService.EnviarNotificaciones(creadas, Url);
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo guardar el mensaje en el intercambio {IdIntercambio}", id);
            TempData["ErrorChat"] = "No pudimos mandar el mensaje. Probá de nuevo en un rato.";
            TempData["TextoChat"] = texto;
        }
        return RedirectToAction("Index", new { id });
    }

    private static bool PuedeEscribir(IntercambioViewModel intercambio, bool elOtroYaEscribio) =>
        intercambio.Estado == EstadosIntercambios.Aceptado
        || (intercambio.Estado == EstadosIntercambios.Pendiente && (intercambio.EsRecibido || elOtroYaEscribio));
}
