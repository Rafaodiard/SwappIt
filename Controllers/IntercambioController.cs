using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Swappit.Models;
using Swappit.Models.ViewModels;
using Swappit.Services;

namespace Swappit.Controllers;

public class IntercambioController : BaseController
{
    private readonly ILogger<IntercambioController> _logger;
    private readonly EmailService _emailService;

    public IntercambioController(ILogger<IntercambioController> logger, EmailService emailService)
    {
        _logger = logger;
        _emailService = emailService;
    }

    public IActionResult Index(string? estado)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return RedirectToAction("Index", "Account");
        }

        ViewBag.intercambios = new List<IntercambioViewModel>();
        ViewBag.filtros = new List<FiltroEstadoViewModel>();
        ViewBag.total = 0;
        ViewBag.estadoElegido = null;
        ViewBag.errorCarga = false;
        try
        {
            List<EstadosIntercambios> estados = IntercambiosBD.GetEstadosIntercambios();
            string? estadoElegido = GestionIntercambios.EstadoValido(estados, estado);
            ViewBag.intercambios = IntercambiosBD.GetIntercambios(usuarioId.Value, estado: estadoElegido);
            ViewBag.filtros = GestionIntercambios.FiltrosPorEstado(usuarioId.Value, estados, estadoElegido, out int total);
            ViewBag.total = total;
            ViewBag.estadoElegido = estadoElegido?.ToLowerInvariant();
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron cargar los intercambios del usuario {IdUsuario}", usuarioId);
            ViewBag.errorCarga = true;
        }
        return View();
    }

    public IActionResult Detalle(int id)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return RedirectToAction("Index", "Account");
        }

        ViewBag.errorCarga = false;
        ViewBag.detalle = null;
        try
        {
            DetalleIntercambioViewModel? detalle = DetalleIntercambio.Armar(id, usuarioId.Value);
            if (detalle == null)
            {
                Response.StatusCode = StatusCodes.Status404NotFound;
            }
            ViewBag.detalle = detalle;
            ViewBag.Title = DetalleIntercambio.Titulo(detalle?.Intercambio);
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo cargar el intercambio {IdIntercambio}", id);
            ViewBag.errorCarga = true;
            ViewBag.detalle = null;
            ViewBag.Title = DetalleIntercambio.Titulo(null);
        }
        ViewBag.mensaje = TempData["MensajeIntercambio"] as string;
        ViewBag.error = TempData["ErrorIntercambio"] as string;
        return View();
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Proponer(int idArticuloPedido, int[]? idsArticulosOfrecidos)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return RedirectToAction("Index", "Account");
        }

        try
        {
            Resultado resultado = GestionIntercambios.Proponer(usuarioId.Value, idArticuloPedido, idsArticulosOfrecidos);
            if (resultado.NoExiste)
            {
                return NotFound();
            }
            if (resultado.Error != null)
            {
                TempData["ErrorArticulo"] = resultado.Error;
                return RedirectToAction("Detalle", "Articulos", new { id = idArticuloPedido });
            }

            _emailService.EnviarNotificaciones(resultado.Notificaciones, Url);
            TempData["MensajeIntercambio"] = resultado.Mensaje;
            return RedirectToAction("Detalle", new { id = resultado.Id });
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo guardar la propuesta por el artículo {IdArticulo}", idArticuloPedido);
            TempData["ErrorArticulo"] = "No pudimos enviar la propuesta. Probá de nuevo en un rato.";
            return RedirectToAction("Detalle", "Articulos", new { id = idArticuloPedido });
        }
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Aceptar(int id, int ultimoCambio)
    {
        return Responder(id, idUsuario => GestionIntercambios.Aceptar(id, idUsuario, ultimoCambio),
            "No pudimos actualizar el intercambio. Probá de nuevo en un rato.");
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Rechazar(int id)
    {
        return Responder(id, idUsuario => GestionIntercambios.Rechazar(id, idUsuario),
            "No pudimos actualizar el intercambio. Probá de nuevo en un rato.");
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult MarcarRealizado(int id)
    {
        return Responder(id, idUsuario => GestionIntercambios.MarcarRealizado(id, idUsuario),
            "No pudimos actualizar el intercambio. Probá de nuevo en un rato.");
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Cancelar(int id)
    {
        return Responder(id, idUsuario => GestionIntercambios.Cancelar(id, idUsuario),
            "No pudimos cancelar el intercambio. Probá de nuevo en un rato.");
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult AgregarArticulos(int id, int[]? idsArticulos)
    {
        return Responder(id, idUsuario => GestionIntercambios.AgregarArticulos(id, idUsuario, idsArticulos),
            "No pudimos guardar el cambio. Probá de nuevo en un rato.");
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult PedirArticulo(int id, int idArticulo)
    {
        return Responder(id, idUsuario => GestionIntercambios.PedirArticulo(id, idUsuario, idArticulo),
            "No pudimos guardar el cambio. Probá de nuevo en un rato.");
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult SacarArticulo(int id, int idArticulo)
    {
        return Responder(id, idUsuario => GestionIntercambios.SacarArticulo(id, idUsuario, idArticulo),
            "No pudimos guardar el cambio. Probá de nuevo en un rato.");
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult ResponderCambio(int id, int idCambio, bool aceptar)
    {
        return Responder(id, idUsuario => GestionIntercambios.ResponderCambio(id, idUsuario, idCambio, aceptar),
            "No pudimos guardar el cambio. Probá de nuevo en un rato.");
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult CancelarCambio(int id, int idCambio)
    {
        return Responder(id, idUsuario => GestionIntercambios.CancelarCambio(id, idUsuario, idCambio),
            "No pudimos guardar el cambio. Probá de nuevo en un rato.");
    }

    private IActionResult Responder(int id, Func<int, Resultado> accion, string errorBase)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return RedirectToAction("Index", "Account");
        }

        try
        {
            Resultado resultado = accion(usuarioId.Value);
            if (resultado.NoExiste)
            {
                return NotFound();
            }
            if (resultado.Error != null)
            {
                TempData["ErrorIntercambio"] = resultado.Error;
            }
            else
            {
                _emailService.EnviarNotificaciones(resultado.Notificaciones, Url);
                TempData["MensajeIntercambio"] = resultado.Mensaje;
            }
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo actualizar el intercambio {IdIntercambio}", id);
            TempData["ErrorIntercambio"] = errorBase;
        }
        return RedirectToAction("Detalle", new { id });
    }
}
