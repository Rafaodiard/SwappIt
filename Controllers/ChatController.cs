using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Swappit.Models;
using Swappit.Models.ViewModels;
using Swappit.Services;

namespace Swappit.Controllers;

public class ChatController : BaseController
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

        ViewBag.contactos = new List<ContactoChatViewModel>();
        ViewBag.abierta = null;
        ViewBag.mensajes = new List<MensajeChatViewModel>();
        ViewBag.puedeEscribir = false;
        ViewBag.textoNoPuedeEscribir = "";
        ViewBag.fotoOtro = null;
        ViewBag.errorCarga = false;
        try
        {
            List<IntercambioViewModel> conversaciones = IntercambiosBD.GetIntercambios(usuarioId.Value, conChat: true);
            IntercambioViewModel? abierta = Chats.Abierta(conversaciones, id, usuarioId.Value);
            List<Mensajes> mensajes = new List<Mensajes>();
            if (abierta != null)
            {
                mensajes = Chats.Abrir(abierta.IdIntercambios, usuarioId.Value);
                ViewBag.fotoOtro = UsuariosBD.GetFotoUsuario(abierta.OtroIdUsuario);
                ViewBag.textoNoPuedeEscribir = Chats.TextoNoPuedeEscribir(abierta);
            }
            else if (id != null)
            {
                Response.StatusCode = StatusCodes.Status404NotFound;
            }

            ViewBag.contactos = Chats.Contactos(conversaciones, usuarioId.Value, abierta?.IdIntercambios);
            ViewBag.abierta = abierta;
            ViewBag.mensajes = Chats.ParaMostrar(mensajes, usuarioId.Value);
            ViewBag.puedeEscribir = Chats.PuedeEscribir(abierta, mensajes);
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo cargar el chat del usuario {IdUsuario}", usuarioId);
            ViewBag.errorCarga = true;
        }

        ViewBag.idPedido = id;
        ViewBag.largoMaximo = Models.Mensajes.LargoMaximoTexto;
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
            ViewBag.mensajes = Chats.ParaMostrar(Chats.Abrir(id, usuarioId.Value), usuarioId.Value);
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
            return Unauthorized();
        }

        try
        {
            Resultado resultado = Chats.Enviar(id, usuarioId.Value, texto);
            if (resultado.Error == null)
            {
                _emailService.EnviarNotificaciones(resultado.Notificaciones, Url);
            }
            return Json(new { error = resultado.Error });
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo guardar el mensaje en el intercambio {IdIntercambio}", id);
            return Json(new { error = "No pudimos mandar el mensaje. Probá de nuevo en un rato." });
        }
    }
}
