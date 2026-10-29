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
// Todavía no se avisa al otro usuario (notificaciones): ve la propuesta al entrar a Mis intercambios o a su perfil.
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
    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Aceptar(int id)
    {
        return CambiarEstado(id, EstadosIntercambios.Pendiente, EstadosIntercambios.Aceptado, soloQuienRecibe: true,
            "Aceptaste el intercambio. Ahora coordinen dónde y cuándo hacerlo.");
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Rechazar(int id)
    {
        return CambiarEstado(id, EstadosIntercambios.Pendiente, EstadosIntercambios.Rechazado, soloQuienRecibe: true,
            "Rechazaste la propuesta.");
    }

    // Cualquiera de los dos, una vez aceptado.
    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult MarcarRealizado(int id)
    {
        return CambiarEstado(id, EstadosIntercambios.Aceptado, EstadosIntercambios.Realizado, soloQuienRecibe: false,
            "¡Intercambio realizado!");
    }

    private IActionResult CambiarEstado(int id, string estadoActual, string estadoNuevo, bool soloQuienRecibe, string mensaje)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return RedirectToAction("Index", "Account");
        }

        try
        {
            if (BD.CambiarEstadoIntercambio(id, usuarioId.Value, estadoActual, estadoNuevo, soloQuienRecibe))
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
