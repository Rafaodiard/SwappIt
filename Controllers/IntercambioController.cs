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
        Dictionary<string, int> cantidadPorEstado = new Dictionary<string, int>();
        int total = 0;
        string? estadoElegido = null;
        bool errorCarga = false;
        try
        {
            estados = IntercambiosBD.GetEstadosIntercambios();
            foreach (EstadosIntercambios e in estados)
            {
                if (e.Nombre == estado)
                {
                    estadoElegido = estado;
                }
            }

            intercambios = IntercambiosBD.GetIntercambios(usuarioId.Value, estado: estadoElegido);
            foreach (CantidadPorEstado c in IntercambiosBD.ContarIntercambiosPorEstado(usuarioId.Value))
            {
                cantidadPorEstado[c.Estado] = c.Cantidad;
                total += c.Cantidad;
            }
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron cargar los intercambios del usuario {IdUsuario}", usuarioId);
            errorCarga = true;
        }

        ViewBag.intercambios = intercambios;
        ViewBag.total = total;
        ViewBag.cantidadPorEstado = cantidadPorEstado;
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
            IntercambioViewModel? intercambio = IntercambiosBD.GetIntercambio(id, usuarioId.Value);
            if (intercambio == null)
            {
                Response.StatusCode = StatusCodes.Status404NotFound;
            }
            else
            {
                List<ArticuloCardViewModel> articulos = IntercambiosBD.GetArticulosDeIntercambio(id, usuarioId.Value);
                List<ArticuloCardViewModel> misArticulos = new List<ArticuloCardViewModel>();
                List<ArticuloCardViewModel> susArticulos = new List<ArticuloCardViewModel>();
                foreach (ArticuloCardViewModel a in articulos)
                {
                    if (a.IdUsuarios == usuarioId)
                    {
                        misArticulos.Add(a);
                    }
                    else
                    {
                        susArticulos.Add(a);
                    }
                }
                ViewBag.misArticulos = misArticulos;
                ViewBag.susArticulos = susArticulos;
                ViewBag.fotoOtro = UsuariosBD.GetFotoUsuario(intercambio.OtroIdUsuario);
                ViewBag.articuloComprometido = intercambio.Estado == EstadosIntercambios.Pendiente
                    && IntercambiosBD.IntercambioConArticuloComprometido(intercambio.IdIntercambios);
                ViewBag.pendientesQueSeRechazan = intercambio.EsRecibido && intercambio.Estado == EstadosIntercambios.Pendiente
                    ? IntercambiosBD.ContarPendientesDeArticulos(intercambio.IdIntercambios)
                    : 0;

                List<CambioIntercambioViewModel> cambios = IntercambiosBD.GetCambiosIntercambio(id, usuarioId.Value);
                List<CambioIntercambioViewModel> pendientes = new List<CambioIntercambioViewModel>();
                int ultimoCambio = 0;
                bool tengoPorResponder = false;
                foreach (CambioIntercambioViewModel c in cambios)
                {
                    if (c.EsPendiente)
                    {
                        pendientes.Add(c);
                        if (c.IdUsuario != usuarioId)
                        {
                            tengoPorResponder = true;
                        }
                    }
                    if (c.Id > ultimoCambio)
                    {
                        ultimoCambio = c.Id;
                    }
                }

                ContextoCambio contexto = new ContextoCambio(usuarioId.Value, intercambio, articulos, pendientes);
                bool puedeCambiar = intercambio.Estado == EstadosIntercambios.Pendiente || intercambio.Estado == EstadosIntercambios.Aceptado;
                int lugarMio = puedeCambiar ? contexto.Lugar(usuarioId.Value) : 0;
                int lugarSuyo = puedeCambiar ? contexto.Lugar(intercambio.OtroIdUsuario) : 0;

                ViewBag.cambios = cambios;
                ViewBag.pendientes = pendientes;
                ViewBag.puedeCambiar = puedeCambiar;
                ViewBag.ultimoCambio = ultimoCambio;
                ViewBag.lugarMio = lugarMio;
                ViewBag.lugarSuyo = lugarSuyo;
                ViewBag.tengoPorResponder = tengoPorResponder;
                ViewBag.hayPendientes = pendientes.Count > 0;
                ViewBag.paraAgregar = lugarMio > 0
                    ? ArticulosBD.GetArticulosCatalogo(idUsuario: usuarioId.Value, fueraDeIntercambio: id)
                    : new List<ArticuloCardViewModel>();
                ViewBag.paraPedir = lugarSuyo > 0
                    ? ArticulosBD.GetArticulosCatalogo(idUsuario: intercambio.OtroIdUsuario, fueraDeIntercambio: id)
                    : new List<ArticuloCardViewModel>();
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
            Articulos? pedido = ArticulosBD.GetArticuloById(idArticuloPedido);
            if (pedido == null)
            {
                return NotFound();
            }

            List<int> idsOfrecidos = Listas.IdsValidos(idsArticulosOfrecidos);
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
            else if (!SonDelUsuario(idsOfrecidos, usuarioId.Value))
            {
                error = "Solo podés ofrecer artículos tuyos.";
            }
            else if (IntercambiosBD.ContarIntercambiosActivos(usuarioId.Value) >= 5)
            {
                error = "Tenés 5 intercambios activos. Cuando uno se resuelva, podés hacer otro.";
            }
            else if (IntercambiosBD.ArticuloComprometido(pedido.IdArticulos))
            {
                error = "Este artículo ya tiene un intercambio aceptado.";
            }
            else if (AlgunoComprometido(idsOfrecidos))
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
            int? idIntercambio = IntercambiosBD.ProponerIntercambio(usuarioId.Value, idsOfrecidos, pedido.IdUsuarios, idArticuloPedido, creadas);
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
    public IActionResult Aceptar(int id, int ultimoCambio)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return RedirectToAction("Index", "Account");
        }

        string mensaje = "Aceptaste el intercambio. Ahora coordinen dónde y cuándo hacerlo.";
        try
        {
            IntercambioViewModel? intercambio = IntercambiosBD.GetIntercambio(id, usuarioId.Value);
            if (intercambio != null)
            {
                if (IntercambiosBD.ContarCambiosPendientes(id, usuarioId.Value, soloDelOtro: true) > 0)
                {
                    TempData["ErrorIntercambio"] = $"Respondé los cambios de {intercambio.OtroNombre} antes de aceptar.";
                    return RedirectToAction("Detalle", new { id });
                }
                if (IntercambiosBD.GetUltimoCambio(id) > ultimoCambio)
                {
                    TempData["ErrorIntercambio"] = $"{intercambio.OtroNombre} cambió el intercambio mientras lo mirabas. Revisalo y aceptá de nuevo.";
                    return RedirectToAction("Detalle", new { id });
                }
            }

            int pendientes = IntercambiosBD.ContarPendientesDeArticulos(id);
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
            TipoNotificaciones.PropuestaAceptada, mensaje, ultimoCambio);
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
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        try
        {
            if (usuarioId != null && IntercambiosBD.ContarCambiosPendientes(id, usuarioId.Value) > 0)
            {
                TempData["ErrorIntercambio"] = "Hay cambios sin responder. Respondelos o cancelalos antes de marcarlo como realizado.";
                return RedirectToAction("Detalle", new { id });
            }
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron revisar los cambios del intercambio {IdIntercambio}", id);
        }
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
            if (IntercambiosBD.CancelarIntercambio(id, usuarioId.Value, creadas))
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

    private record ContextoCambio(int IdUsuario, IntercambioViewModel Intercambio, List<ArticuloCardViewModel> Articulos,
        List<CambioIntercambioViewModel> Pendientes)
    {
        public int Confirmados(int dueno)
        {
            int cantidad = 0;
            foreach (ArticuloCardViewModel a in Articulos)
            {
                if (a.IdUsuarios == dueno)
                {
                    cantidad++;
                }
            }
            return cantidad;
        }

        public int PendientesDe(int dueno, string tipo)
        {
            int cantidad = 0;
            foreach (CambioIntercambioViewModel c in Pendientes)
            {
                if (c.IdDuenoArticulo == dueno && c.Tipo == tipo)
                {
                    cantidad++;
                }
            }
            return cantidad;
        }

        public int Lugar(int dueno) =>
            Math.Max(0, Intercambios.MaxArticulosOfrecidos - Confirmados(dueno) - PendientesDe(dueno, TipoCambios.Pedir));

        public ArticuloCardViewModel? Articulo(int idArticulo)
        {
            foreach (ArticuloCardViewModel a in Articulos)
            {
                if (a.IdArticulos == idArticulo)
                {
                    return a;
                }
            }
            return null;
        }

        public CambioIntercambioViewModel? PendienteDeArticulo(int idArticulo)
        {
            foreach (CambioIntercambioViewModel c in Pendientes)
            {
                if (c.IdArticulo == idArticulo)
                {
                    return c;
                }
            }
            return null;
        }

        public CambioIntercambioViewModel? Pendiente(int idCambio)
        {
            foreach (CambioIntercambioViewModel c in Pendientes)
            {
                if (c.Id == idCambio)
                {
                    return c;
                }
            }
            return null;
        }

        public bool EnJuego(int idArticulo) => Articulo(idArticulo) != null || PendienteDeArticulo(idArticulo) != null;
    }

    private static bool SonDelUsuario(List<int> idsArticulos, int idUsuario)
    {
        foreach (int idArticulo in idsArticulos)
        {
            if (ArticulosBD.GetArticuloById(idArticulo)?.IdUsuarios != idUsuario)
            {
                return false;
            }
        }
        return true;
    }

    private static bool AlgunoComprometido(List<int> idsArticulos)
    {
        foreach (int idArticulo in idsArticulos)
        {
            if (IntercambiosBD.ArticuloComprometido(idArticulo))
            {
                return true;
            }
        }
        return false;
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult AgregarArticulos(int id, int[]? idsArticulos)
    {
        List<int> ids = Listas.IdsValidos(idsArticulos);
        List<string> nombres = new List<string>();
        return HacerCambio(id, c =>
        {
            if (ids.Count == 0)
            {
                return "Elegí al menos uno de tus artículos para agregar.";
            }
            if (c.Confirmados(c.IdUsuario) + c.PendientesDe(c.IdUsuario, TipoCambios.Pedir) + ids.Count > Intercambios.MaxArticulosOfrecidos)
            {
                return $"Cada lado puede tener hasta {Intercambios.MaxArticulosOfrecidos} artículos.";
            }
            nombres.Clear();
            foreach (int idArticulo in ids)
            {
                Articulos? elegido = ArticulosBD.GetArticuloById(idArticulo);
                if (elegido == null || elegido.IdUsuarios != c.IdUsuario)
                {
                    return "Solo podés agregar artículos tuyos.";
                }
                nombres.Add(elegido.Nombre ?? "");
            }
            foreach (int idArticulo in ids)
            {
                if (c.EnJuego(idArticulo))
                {
                    return "Ese artículo ya está en el intercambio o tiene un cambio pendiente.";
                }
            }
            if (AlgunoComprometido(ids))
            {
                return "Uno de los artículos ya tiene un intercambio aceptado. Elegí otro.";
            }
            return null;
        }, (c, creadas) => IntercambiosBD.AgregarArticulos(id, c.IdUsuario, ids, creadas) > 0
            ? $"Sumaste {Listas.UnirNombres(nombres)}. A {c.Intercambio.OtroNombre} le llegó un aviso."
            : null);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult PedirArticulo(int id, int idArticulo)
    {
        Articulos? articulo = null;
        return HacerCambio(id, c =>
        {
            articulo = ArticulosBD.GetArticuloById(idArticulo);
            if (articulo == null || articulo.IdUsuarios != c.Intercambio.OtroIdUsuario)
            {
                return $"Solo podés pedir artículos de {c.Intercambio.OtroNombre}.";
            }
            if (c.EnJuego(idArticulo))
            {
                return "Ese artículo ya está en el intercambio o tiene un cambio pendiente.";
            }
            if (c.Confirmados(articulo.IdUsuarios) + c.PendientesDe(articulo.IdUsuarios, TipoCambios.Pedir) >= Intercambios.MaxArticulosOfrecidos)
            {
                return $"Cada lado puede tener hasta {Intercambios.MaxArticulosOfrecidos} artículos.";
            }
            if (IntercambiosBD.ArticuloComprometido(idArticulo))
            {
                return "Ese artículo ya tiene un intercambio aceptado. Elegí otro.";
            }
            return null;
        }, (c, creadas) => IntercambiosBD.PedirArticulo(id, c.IdUsuario, idArticulo, creadas)
            ? $"Le pediste {articulo!.Nombre} a {c.Intercambio.OtroNombre}. Se suma cuando lo acepte."
            : null);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult SacarArticulo(int id, int idArticulo)
    {
        ArticuloCardViewModel? articulo = null;
        return HacerCambio(id, c =>
        {
            articulo = c.Articulo(idArticulo);
            if (articulo == null || articulo.IdUsuarios != c.IdUsuario)
            {
                return "Solo podés sacar artículos tuyos que estén en el intercambio.";
            }
            if (c.PendienteDeArticulo(idArticulo) != null)
            {
                return "Ese artículo ya está en el intercambio o tiene un cambio pendiente.";
            }
            if (c.Confirmados(c.IdUsuario) - c.PendientesDe(c.IdUsuario, TipoCambios.Sacar) < 2)
            {
                return "No podés sacar tu único artículo del intercambio.";
            }
            return null;
        }, (c, creadas) => IntercambiosBD.PedirSacarArticulo(id, c.IdUsuario, idArticulo, creadas)
            ? $"Le pediste a {c.Intercambio.OtroNombre} sacar {articulo!.Nombre}. Se saca cuando lo acepte."
            : null);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult ResponderCambio(int id, int idCambio, bool aceptar)
    {
        return HacerCambio(id, c =>
        {
            CambioIntercambioViewModel? cambio = c.Pendiente(idCambio);
            if (cambio == null || cambio.IdUsuario == c.IdUsuario)
            {
                return "Ese cambio ya no está pendiente.";
            }
            if (aceptar && cambio.Tipo == TipoCambios.Pedir && IntercambiosBD.ArticuloComprometido(cambio.IdArticulo))
            {
                return $"{cambio.ArticuloNombre} ya tiene otro intercambio aceptado, así que no se puede sumar. Tocá No para cerrar el pedido.";
            }
            return null;
        }, (c, creadas) => IntercambiosBD.ResponderCambio(idCambio, c.IdUsuario, aceptar, creadas)
            ? (aceptar ? "Aceptaste el cambio." : $"Rechazaste el cambio. Le avisamos a {c.Intercambio.OtroNombre}.")
            : null);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult CancelarCambio(int id, int idCambio)
    {
        return HacerCambio(id, c => c.Pendiente(idCambio)?.IdUsuario == c.IdUsuario ? null : "Ese pedido ya no está pendiente.",
            (c, creadas) => IntercambiosBD.CancelarCambio(idCambio, c.IdUsuario) ? "Cancelaste el pedido." : null);
    }

    private IActionResult HacerCambio(int id, Func<ContextoCambio, string?> validar, Func<ContextoCambio, List<NotificacionCreada>, string?> hacer)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return RedirectToAction("Index", "Account");
        }

        try
        {
            IntercambioViewModel? intercambio = IntercambiosBD.GetIntercambio(id, usuarioId.Value);
            if (intercambio == null)
            {
                return NotFound();
            }

            string? error = null;
            if (intercambio.Estado != EstadosIntercambios.Pendiente && intercambio.Estado != EstadosIntercambios.Aceptado)
            {
                error = "Este intercambio ya terminó: no se puede cambiar.";
            }
            else
            {
                ContextoCambio contexto = new ContextoCambio(usuarioId.Value, intercambio,
                    IntercambiosBD.GetArticulosDeIntercambio(id, usuarioId.Value),
                    IntercambiosBD.GetCambiosIntercambio(id, usuarioId.Value, soloPendientes: true));
                error = validar(contexto);
                if (error == null)
                {
                    List<NotificacionCreada> creadas = new List<NotificacionCreada>();
                    string? mensaje = hacer(contexto, creadas);
                    if (mensaje != null)
                    {
                        _emailService.EnviarNotificaciones(creadas, Url);
                        TempData["MensajeIntercambio"] = mensaje;
                    }
                    else
                    {
                        error = "No se pudo hacer el cambio. Puede que el intercambio haya cambiado: revisalo y probá de nuevo.";
                    }
                }
            }

            if (error != null)
            {
                TempData["ErrorIntercambio"] = error;
            }
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo guardar un cambio del intercambio {IdIntercambio}", id);
            TempData["ErrorIntercambio"] = "No pudimos guardar el cambio. Probá de nuevo en un rato.";
        }
        return RedirectToAction("Detalle", new { id });
    }

    private IActionResult CambiarEstado(int id, string estadoActual, string estadoNuevo, bool soloQuienRecibe,
        string? tipoNotificacion, string mensaje, int? ultimoCambioVisto = null)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return RedirectToAction("Index", "Account");
        }

        try
        {
            List<NotificacionCreada> creadas = new List<NotificacionCreada>();
            if (IntercambiosBD.CambiarEstadoIntercambio(id, usuarioId.Value, estadoActual, estadoNuevo, soloQuienRecibe, tipoNotificacion, creadas, ultimoCambioVisto))
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
