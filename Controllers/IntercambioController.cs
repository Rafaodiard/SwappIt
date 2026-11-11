using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Swappit.Models;
using Swappit.Models.ViewModels;
using Swappit.Services;

namespace Swappit.Controllers;

public class IntercambioController : Controller
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

        List<IntercambioViewModel> intercambios = new List<IntercambioViewModel>();
        List<EstadosIntercambios> estados = new List<EstadosIntercambios>();
        bool errorCarga = false;
        try
        {
            intercambios = BD.GetIntercambios(usuarioId.Value);
            estados = BD.GetEstadosIntercambios();
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron cargar los intercambios del usuario {IdUsuario}", usuarioId);
            errorCarga = true;
        }

        string? estadoElegido = estados.Any(e => e.Nombre == estado) ? estado : null;

        ViewBag.intercambios = estadoElegido == null ? intercambios : intercambios.Where(i => i.Estado == estadoElegido).ToList();
        ViewBag.total = intercambios.Count;
        ViewBag.cantidadPorEstado = intercambios.GroupBy(i => i.Estado).ToDictionary(g => g.Key, g => g.Count());
        ViewBag.estados = estados;
        ViewBag.estadoElegido = estadoElegido;
        ViewBag.errorCarga = errorCarga;
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
        try
        {
            IntercambioViewModel? intercambio = BD.GetIntercambio(id, usuarioId.Value);
            if (intercambio == null)
            {
                Response.StatusCode = StatusCodes.Status404NotFound;
            }
            else
            {
                List<ArticuloCardViewModel> articulos = BD.GetArticulosDeIntercambio(id, usuarioId.Value);
                ViewBag.misArticulos = articulos.Where(a => a.IdUsuarios == usuarioId).ToList();
                ViewBag.susArticulos = articulos.Where(a => a.IdUsuarios != usuarioId).ToList();
                ViewBag.fotoOtro = BD.GetFotoUsuario(intercambio.OtroIdUsuario);
                ViewBag.articuloComprometido = intercambio.Estado == EstadosIntercambios.Pendiente
                    && BD.IntercambioConArticuloComprometido(intercambio.IdIntercambios);
                ViewBag.pendientesQueSeRechazan = intercambio.EsRecibido && intercambio.Estado == EstadosIntercambios.Pendiente
                    ? BD.ContarPendientesDeArticulos(intercambio.IdIntercambios)
                    : 0;
            }
            ViewBag.intercambio = intercambio;
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo cargar el intercambio {IdIntercambio}", id);
            ViewBag.errorCarga = true;
            ViewBag.intercambio = null;
        }
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
            Articulos? pedido = BD.GetArticuloById(idArticuloPedido);
            if (pedido == null)
            {
                return NotFound();
            }

            List<int> idsOfrecidos = (idsArticulosOfrecidos ?? Array.Empty<int>()).Where(id => id > 0).Distinct().ToList();
            string? error = null;
            if (pedido.IdUsuarios == usuarioId)
            {
                error = "No podés proponer un intercambio por un artículo tuyo.";
            }
            else if (idsOfrecidos.Count == 0)
            {
                error = "Elegí al menos uno de tus artículos para ofrecer a cambio.";
            }
            else if (idsOfrecidos.Count > Intercambios.MaxArticulosOfrecidos)
            {
                error = $"Podés ofrecer hasta {Intercambios.MaxArticulosOfrecidos} artículos en una propuesta.";
            }
            else if (idsOfrecidos.Any(id => BD.GetArticuloById(id)?.IdUsuarios != usuarioId))
            {
                error = "Solo podés ofrecer artículos tuyos.";
            }
            else if (BD.ContarIntercambiosActivos(usuarioId.Value) >= 5)
            {
                error = "Tenés 5 intercambios activos. Cuando uno se resuelva, podés hacer otro.";
            }
            else if (BD.ArticuloComprometido(pedido.IdArticulos))
            {
                error = "Este artículo ya tiene un intercambio aceptado.";
            }
            else if (idsOfrecidos.Any(BD.ArticuloComprometido))
            {
                error = idsOfrecidos.Count == 1
                    ? "El artículo que elegiste ya tiene un intercambio aceptado. Elegí otro."
                    : "Uno de los artículos que elegiste ya tiene un intercambio aceptado. Sacalo y probá de nuevo.";
            }

            if (error != null)
            {
                TempData["ErrorArticulo"] = error;
                return RedirectToAction("Detalle", "Articulos", new { id = idArticuloPedido });
            }

            List<NotificacionCreada> creadas = new List<NotificacionCreada>();
            int? idIntercambio = BD.ProponerIntercambio(usuarioId.Value, idsOfrecidos, pedido.IdUsuarios, idArticuloPedido, creadas);
            if (idIntercambio == null)
            {
                TempData["ErrorArticulo"] = "Ya tenés una propuesta en curso por este artículo.";
                return RedirectToAction("Detalle", "Articulos", new { id = idArticuloPedido });
            }
            _emailService.EnviarNotificaciones(creadas, Url);

            TempData["MensajeIntercambio"] = "¡Listo! Enviaste tu propuesta. Cuando la respondan, la vas a ver acá.";
            return RedirectToAction("Detalle", new { id = idIntercambio });
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
    public IActionResult Aceptar(int id)
    {
        string mensaje = "Aceptaste el intercambio. Ahora coordinen dónde y cuándo hacerlo.";
        try
        {
            int pendientes = BD.ContarPendientesDeArticulos(id);
            if (pendientes > 0)
            {
                mensaje += pendientes == 1
                    ? " Se rechazó automáticamente otra propuesta que incluía estos artículos."
                    : $" Se rechazaron automáticamente otras {pendientes} propuestas que incluían estos artículos.";
            }
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron contar las propuestas pendientes del intercambio {IdIntercambio}", id);
        }
        return CambiarEstado(id, EstadosIntercambios.Pendiente, EstadosIntercambios.Aceptado, soloQuienRecibe: true,
            TipoNotificaciones.PropuestaAceptada, mensaje);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Rechazar(int id)
    {
        return CambiarEstado(id, EstadosIntercambios.Pendiente, EstadosIntercambios.Rechazado, soloQuienRecibe: true,
            TipoNotificaciones.PropuestaRechazada, "Rechazaste la propuesta.");
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult MarcarRealizado(int id)
    {
        return CambiarEstado(id, EstadosIntercambios.Aceptado, EstadosIntercambios.Realizado, soloQuienRecibe: false,
            tipoNotificacion: null, "¡Intercambio realizado!");
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Cancelar(int id)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return RedirectToAction("Index", "Account");
        }

        try
        {
            List<NotificacionCreada> creadas = new List<NotificacionCreada>();
            if (BD.CancelarIntercambio(id, usuarioId.Value, creadas))
            {
                _emailService.EnviarNotificaciones(creadas, Url);
                TempData["MensajeIntercambio"] = "Cancelaste el intercambio. Le avisamos a la otra persona.";
            }
            else
            {
                TempData["ErrorIntercambio"] = "No se pudo cancelar el intercambio. Puede que ya haya cambiado de estado.";
            }
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo cancelar el intercambio {IdIntercambio}", id);
            TempData["ErrorIntercambio"] = "No pudimos cancelar el intercambio. Probá de nuevo en un rato.";
        }
        return RedirectToAction("Detalle", new { id });
    }

    private IActionResult CambiarEstado(int id, string estadoActual, string estadoNuevo, bool soloQuienRecibe,
        string? tipoNotificacion, string mensaje)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return RedirectToAction("Index", "Account");
        }

        try
        {
            List<NotificacionCreada> creadas = new List<NotificacionCreada>();
            if (BD.CambiarEstadoIntercambio(id, usuarioId.Value, estadoActual, estadoNuevo, soloQuienRecibe, tipoNotificacion, creadas))
            {
                _emailService.EnviarNotificaciones(creadas, Url);
                TempData["MensajeIntercambio"] = mensaje;
            }
            else
            {
                TempData["ErrorIntercambio"] = "No se pudo actualizar el intercambio. Puede que ya haya cambiado de estado.";
            }
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo pasar el intercambio {IdIntercambio} a {Estado}", id, estadoNuevo);
            TempData["ErrorIntercambio"] = "No pudimos actualizar el intercambio. Probá de nuevo en un rato.";
        }
        return RedirectToAction("Detalle", new { id });
    }
}
