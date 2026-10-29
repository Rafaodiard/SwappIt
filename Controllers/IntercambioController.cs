using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Swappit.Models;
using Swappit.Models.ViewModels;

namespace Swappit.Controllers;

// Intercambios entre usuarios:
// - Proponer uno desde el detalle de un artículo (POST /Intercambio/Proponer).
// - Mis intercambios, enviados y recibidos, con filtro por estado (/Intercambio?estado=Pendiente).
// - Ver un intercambio (/Intercambio/Detalle/5): quien lo recibe lo acepta o lo rechaza, y cuando está
//   aceptado cualquiera de los dos lo marca como realizado.
// Al proponer, aceptar o rechazar se le avisa a la otra persona con una notificación (ver NotificacionesController).
// Marcar como realizado no avisa: no hay tipo de notificación para eso.
public class IntercambioController : Controller
{
    private readonly ILogger<IntercambioController> _logger;

    public IntercambioController(ILogger<IntercambioController> logger)
    {
        _logger = logger;
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

        // Solo se filtra por un estado que exista en la tabla; cualquier otro valor muestra todos.
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
            // Si el intercambio no existe o el usuario no es parte de él, se muestra "no encontrado".
            IntercambioViewModel? intercambio = BD.GetIntercambio(id, usuarioId.Value);
            if (intercambio == null)
            {
                Response.StatusCode = StatusCodes.Status404NotFound;
            }
            else
            {
                ViewBag.fotoOtro = BD.GetFotoUsuario(intercambio.OtroIdUsuario);
                // Una propuesta pendiente no se puede aceptar si alguno de los dos artículos ya se comprometió en otro intercambio.
                ViewBag.articuloComprometido = intercambio.Estado == EstadosIntercambios.Pendiente
                    && (BD.ArticuloComprometido(intercambio.MiArticuloId) || BD.ArticuloComprometido(intercambio.SuArticuloId));
                // Si quien la recibió la acepta, estas otras propuestas pendientes con los mismos artículos se rechazan solas.
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

    // Lo manda el pop up "Proponer intercambio" de Articulos/Detalle.
    // idArticuloPedido: el artículo que se está mirando. idArticuloOfrecido: uno de los artículos del usuario logueado.
    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Proponer(int idArticuloPedido, int idArticuloOfrecido)
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

            string? error = null;
            Articulos? ofrecido = idArticuloOfrecido > 0 ? BD.GetArticuloById(idArticuloOfrecido) : null;
            if (pedido.IdUsuarios == usuarioId)
            {
                error = "No podés proponer un intercambio por un artículo tuyo.";
            }
            else if (ofrecido == null || ofrecido.IdUsuarios != usuarioId)
            {
                error = "Elegí uno de tus artículos para ofrecer a cambio.";
            }
            else if (BD.ArticuloComprometido(pedido.IdArticulos))
            {
                error = "Este artículo ya tiene un intercambio aceptado.";
            }
            else if (BD.ArticuloComprometido(ofrecido.IdArticulos))
            {
                error = "El artículo que elegiste ya tiene un intercambio aceptado. Elegí otro.";
            }

            if (error != null)
            {
                TempData["ErrorArticulo"] = error;
                return RedirectToAction("Detalle", "Articulos", new { id = idArticuloPedido });
            }

            int? idIntercambio = BD.ProponerIntercambio(usuarioId.Value, idArticuloOfrecido, pedido.IdUsuarios, idArticuloPedido);
            if (idIntercambio == null)
            {
                TempData["ErrorArticulo"] = "Ya tenés una propuesta en curso por este artículo.";
                return RedirectToAction("Detalle", "Articulos", new { id = idArticuloPedido });
            }

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

    // Solo quien recibió la propuesta (dueño del artículo pedido) y mientras esté Pendiente.
    // Las otras propuestas pendientes con esos artículos se rechazan solas (BD.CambiarEstadoIntercambio).
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
            // Solo es para el mensaje: si falla, CambiarEstado igual intenta aceptar y maneja el error.
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

    // Cualquiera de los dos, una vez aceptado.
    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult MarcarRealizado(int id)
    {
        return CambiarEstado(id, EstadosIntercambios.Aceptado, EstadosIntercambios.Realizado, soloQuienRecibe: false,
            tipoNotificacion: null, "¡Intercambio realizado!");
    }

    // tipoNotificacion: la que le llega a la otra persona si el cambio se hizo (null = no se avisa).
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
            if (BD.CambiarEstadoIntercambio(id, usuarioId.Value, estadoActual, estadoNuevo, soloQuienRecibe, tipoNotificacion))
            {
                TempData["MensajeIntercambio"] = mensaje;
            }
            else
            {
                // No es parte del intercambio, no le toca a él o el estado ya cambió (por ejemplo, la otra persona ya respondió).
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
