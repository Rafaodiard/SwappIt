using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.ModelBinding;
using Swappit.Models;
using Swappit.Models.ViewModels;

namespace Swappit.Controllers;

public class AccountController : BaseController
{
    public IActionResult Index()
    {
        return View("Login");
    }

    public IActionResult Registro(int? plan)
    {
        List<PlanViewModel> planes = Suscripciones.Planes();
        CargarRegistro(null, UsuariosBD.GetProvincias(), planes, Suscripciones.PlanElegido(planes, plan), null);
        return View();
    }

    public IActionResult CambiarContrasena()
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");

        if (usuarioId == null)
        {
            return RedirectToAction("Index", "Account");
        }

        return View();
    }

    [HttpPost]
    public IActionResult Login(LoginViewModel l)
    {
        ViewBag.login = l;
        if (!ModelState.IsValid) return View("Login");

        Usuarios? u = Cuentas.IniciarSesion(l.Mail, l.Contrasena);
        if (u == null)
        {
            ViewBag.Error = "Email o contraseña incorrectos";
            return View("Login");
        }

        SesionUsuario.Iniciar(HttpContext.Session, u);
        return RedirectToAction("Index", "Home");
    }

    [HttpPost]
    public IActionResult Registro(RegistroViewModel r, string password2)
    {
        List<Provincias> provincias = UsuariosBD.GetProvincias();
        string? errorProvincia = Cuentas.ValidarProvincia(provincias, r.IdProvincias);
        if (errorProvincia != null)
        {
            ModelState.AddModelError(nameof(r.IdProvincias), errorProvincia);
        }

        List<PlanViewModel> planes = Suscripciones.Planes();
        string? errorPlan = Suscripciones.ValidarPlan(planes, r.IdPlan);
        if (errorPlan != null)
        {
            ModelState.AddModelError(nameof(r.IdPlan), errorPlan);
        }

        bool contrasenaValida = ModelState.GetFieldValidationState(nameof(r.Contrasena)) == ModelValidationState.Valid;
        CargarRegistro(r, provincias, planes, Suscripciones.PlanElegido(planes, r.IdPlan), Cuentas.ContrasenaParaRepetir(r, password2, contrasenaValida));
        if (!ModelState.IsValid) return View();

        ErrorCampo? error = Cuentas.ValidarRegistro(r, password2);
        if (error != null)
        {
            if (error.EsGeneral)
            {
                ViewBag.Error = error.Mensaje;
            }
            else
            {
                ModelState.AddModelError(error.Campo, error.Mensaje);
            }
            return View();
        }

        int idPlanInicial = Suscripciones.PlanAlRegistrarse(planes, r.IdPlan!.Value);
        Usuarios? usuario = Cuentas.Registrar(r, idPlanInicial);
        if (usuario == null)
        {
            return RedirectToAction("Index", "Home");
        }

        SesionUsuario.Iniciar(HttpContext.Session, usuario);
        if (idPlanInicial != r.IdPlan)
        {
            return RedirectToAction("Pago", "Planes", new { id = r.IdPlan });
        }
        return RedirectToAction("Index", "Home");
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult CambiarContrasena(
        string? contrasenaActual,
        string? contrasenaNueva,
        string? confirmarContrasena)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        Usuarios? usuario = usuarioId == null ? null : UsuariosBD.GetUsuarioById(usuarioId.Value);
        if (usuario == null)
        {
            return Unauthorized();
        }

        string? error = Cuentas.CambiarContrasena(usuario, contrasenaActual, contrasenaNueva, confirmarContrasena);
        if (error != null)
        {
            return Json(new { ok = false, mensaje = error });
        }
        return Json(new { ok = true, mensaje = "Contraseña cambiada exitosamente." });
    }

    public IActionResult Logout()
    {
        HttpContext.Session.Clear();

        return RedirectToAction("Index", "Account");
    }

    private void CargarRegistro(RegistroViewModel? r, List<Provincias> provincias, List<PlanViewModel> planes, int? idPlanElegido, string? contrasena)
    {
        ViewBag.registro = r;
        ViewBag.provincias = provincias;
        ViewBag.planes = planes;
        ViewBag.idPlanElegido = idPlanElegido;
        ViewBag.contrasena = contrasena;
        ViewBag.fechaNacimiento = r?.FechaNacimiento?.ToString("yyyy-MM-dd");
        ViewBag.edadMinima = RegistroViewModel.EdadMinima;
        ViewBag.edadMaxima = RegistroViewModel.EdadMaxima;
    }
}
