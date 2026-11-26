using Microsoft.AspNetCore.Mvc;
using Swappit.Models;
using Swappit.Models.ViewModels;

namespace Swappit.Controllers;

public class PerfilController : BaseController
{
    private readonly IWebHostEnvironment _env;

    public PerfilController(IWebHostEnvironment env)
    {
        _env = env;
    }

    public IActionResult Index()
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return RedirectToAction("Index", "Account");
        }

        Usuarios? usuario = UsuariosBD.GetUsuarioById(usuarioId.Value);
        if (usuario == null)
        {
            return RedirectToAction("Index", "Account");
        }

        ViewBag.usuario = usuario;
        ViewBag.iniciales = SesionUsuario.Iniciales(usuario.Nombre, usuario.Apellido);
        ViewBag.ubicacion = Perfiles.TextoOGuion(Perfiles.Ubicacion(usuario));
        ViewBag.tieneDescripcion = Perfiles.TieneDescripcion(usuario);
        ViewBag.telefono = Perfiles.TextoOGuion(usuario.Telefono);
        ViewBag.provincias = UsuariosBD.GetProvincias();
        ViewBag.foto = UsuariosBD.GetFotoUsuario(usuario.IdUsuarios);
        ViewBag.articulos = ArticulosBD.GetArticulosCatalogo(idUsuario: usuario.IdUsuarios, incluirEnIntercambio: true);
        ViewBag.ocultarFavorito = true;
        ViewBag.intercambios = IntercambiosBD.GetIntercambios(usuario.IdUsuarios, cantidad: 3);
        ViewBag.plan = Suscripciones.Buscar(Suscripciones.Planes(), usuario.IdPlan);
        ViewBag.articulosActivos = ArticulosBD.ContarArticulosActivos(usuario.IdUsuarios);
        ViewBag.intercambiosActivos = IntercambiosBD.ContarIntercambiosActivos(usuario.IdUsuarios);
        ViewBag.reputacion = CalificacionesBD.GetReputacionUsuario(usuario.IdUsuarios);
        ViewBag.opiniones = CalificacionesBD.GetCalificacionesUsuario(usuario.IdUsuarios, Reputaciones.OpinionesEnPerfil);
        ViewBag.textoSinOpiniones = "Todavía no te calificaron. Cuando termines un intercambio, la otra persona te va a poder calificar.";
        ViewBag.maxFotoMB = EditarPerfilViewModel.MaxFotoMB;
        ViewBag.maxDescripcion = EditarPerfilViewModel.MaxDescripcion;
        ViewBag.errorPerfil = TempData["ErrorPerfil"] as string;
        ViewBag.mensaje = TempData["MensajePerfil"] as string;
        return View();
    }

    public IActionResult Publico(int id)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");

        if (usuarioId == null)
        {
            return RedirectToAction("Index", "Account");
        }

        if (usuarioId == id)
        {
            return RedirectToAction("Index");
        }

        Usuarios? usuario = UsuariosBD.GetUsuarioById(id);
        if (usuario == null)
        {
            Response.StatusCode = StatusCodes.Status404NotFound;
            ViewBag.usuario = null;
            ViewBag.Title = "Usuario no encontrado";
            return View();
        }

        ViewBag.usuario = Perfiles.DatosPublicos(usuario);
        ViewBag.Title = $"{usuario.Nombre} {usuario.Apellido}";
        ViewBag.iniciales = SesionUsuario.Iniciales(usuario.Nombre, usuario.Apellido);
        ViewBag.ubicacion = Perfiles.Ubicacion(usuario);
        ViewBag.tieneDescripcion = Perfiles.TieneDescripcion(usuario);
        ViewBag.foto = UsuariosBD.GetFotoUsuario(usuario.IdUsuarios);
        ViewBag.articulos = ArticulosBD.GetArticulosCatalogo(idUsuario: usuario.IdUsuarios);
        ViewBag.plan = Suscripciones.Buscar(Suscripciones.Planes(), usuario.IdPlan);
        ViewBag.reputacion = CalificacionesBD.GetReputacionUsuario(usuario.IdUsuarios);
        ViewBag.opiniones = CalificacionesBD.GetCalificacionesUsuario(usuario.IdUsuarios, Reputaciones.OpinionesEnPerfil);
        ViewBag.textoSinOpiniones = $"{usuario.Nombre} todavía no tiene calificaciones.";
        return View();
    }

    [HttpPost]
    public IActionResult Editar(EditarPerfilViewModel e)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");

        if (usuarioId == null)
        {
            return RedirectToAction("Index", "Account");
        }

        Usuarios? usuario = UsuariosBD.GetUsuarioById(usuarioId.Value);

        if (usuario == null)
        {
            return RedirectToAction("Index", "Account");
        }

        if (!ModelState.IsValid)
        {
            TempData["ErrorPerfil"] = Formularios.PrimerError(ModelState);
            return RedirectToAction("Index");
        }

        string? error = Perfiles.Editar(usuario, e, _env.WebRootPath);
        if (error != null)
        {
            TempData["ErrorPerfil"] = error;
            return RedirectToAction("Index");
        }

        SesionUsuario.GuardarDatosHeader(HttpContext.Session, usuario);
        TempData["MensajePerfil"] = "Perfil actualizado.";

        return RedirectToAction("Index");
    }
}
