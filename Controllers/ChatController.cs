using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Swappit.Models;
using Swappit.Models.ViewModels;

namespace Swappit.Controllers;

// Chat para coordinar los intercambios. Hay una conversación por intercambio, entre sus dos partes.
// - GET /Chat: lista de conversaciones y la primera abierta. GET /Chat/Index/5: el chat del intercambio 5.
// - POST /Chat/Enviar/5: manda un mensaje (form normal: guarda y vuelve a cargar la página).
// - GET /Chat/Mensajes/5: solo los mensajes (partial _Mensajes). chat.js lo pide cada pocos segundos
//   para mostrar los mensajes nuevos de la otra persona sin recargar.
// Se puede escribir mientras el intercambio está Pendiente o Aceptado; si se rechazó o ya se realizó, el chat queda para leer.
// Al mandar un mensaje, la otra persona recibe la notificación "Mensaje nuevo" (ver BD.EnviarMensaje).
public class ChatController : Controller
{
    private readonly ILogger<ChatController> _logger;

    public ChatController(ILogger<ChatController> logger)
    {
        _logger = logger;
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
            List<IntercambioViewModel> intercambios = BD.GetIntercambios(usuarioId.Value);
            resumenes = BD.GetResumenesChat(usuarioId.Value).ToDictionary(r => r.IdIntercambio);

            // En la lista van los intercambios en curso y los que ya tienen mensajes; primero los que tienen el mensaje más nuevo.
            conversaciones = intercambios
                .Where(i => EnCurso(i.Estado) || resumenes.ContainsKey(i.IdIntercambios))
                .OrderByDescending(i => resumenes.TryGetValue(i.IdIntercambios, out ConversacionViewModel? r) ? r.UltimaFecha : i.Fecha)
                .ToList();

            // Sin id se abre la primera. Con id, cualquiera de sus intercambios (aunque no esté en la lista).
            abierta = id == null ? conversaciones.FirstOrDefault() : intercambios.FirstOrDefault(i => i.IdIntercambios == id);
            if (abierta != null)
            {
                BD.MarcarMensajesVistos(abierta.IdIntercambios, usuarioId.Value);
                mensajes = BD.GetMensajes(abierta.IdIntercambios, usuarioId.Value);
                ViewBag.fotoOtro = BD.GetFotoUsuario(abierta.OtroIdUsuario);
                if (resumenes.TryGetValue(abierta.IdIntercambios, out ConversacionViewModel? resumen))
                {
                    resumen.NoLeidos = 0;
                }
            }
            else if (id != null)
            {
                // El intercambio no existe o el usuario no es parte de él.
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
        ViewBag.puedeEscribir = abierta != null && EnCurso(abierta.Estado);
        ViewBag.usuarioId = usuarioId.Value;
        ViewBag.idPedido = id;
        ViewBag.errorCarga = errorCarga;
        return View();
    }

    // Para chat.js: los mensajes del chat abierto (y los marca como vistos, porque el usuario lo está mirando).
    public IActionResult Mensajes(int id)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return Unauthorized();
        }

        try
        {
            BD.MarcarMensajesVistos(id, usuarioId.Value);
            ViewBag.mensajes = BD.GetMensajes(id, usuarioId.Value);
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
            if (!BD.EnviarMensaje(id, usuarioId.Value, texto))
            {
                // No es parte del intercambio o el intercambio ya no está en curso.
                TempData["ErrorChat"] = "No se pudo mandar el mensaje: este intercambio ya no está en curso.";
            }
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo guardar el mensaje en el intercambio {IdIntercambio}", id);
            TempData["ErrorChat"] = "No pudimos mandar el mensaje. Probá de nuevo en un rato.";
            TempData["TextoChat"] = texto;
        }
        return RedirectToAction("Index", new { id });
    }

    // Pendiente o Aceptado: todavía se puede escribir.
    private static bool EnCurso(string estado) =>
        estado == EstadosIntercambios.Pendiente || estado == EstadosIntercambios.Aceptado;
}
