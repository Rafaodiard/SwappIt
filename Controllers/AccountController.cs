using Microsoft.AspNetCore.Mvc;
using Swappit.Models;
using Swappit.Models.ViewModels;

namespace Swappit.Controllers;

// Cuenta del usuario: iniciar sesión (/Account), registrarse, cambiar la contraseña y cerrar sesión.
// Ver y editar el perfil está en PerfilController.
public class AccountController : Controller
{
    public IActionResult Index()
    {
        return View("Login");
    }

    public IActionResult Registro()
    {
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

        Usuarios? u = BD.GetUsuarioByMail(l.Mail);

        if (u != null && Contrasenas.Verificar(u.Contraseña, l.Contrasena, out bool hayQueActualizar))
        {
            if (hayQueActualizar)
            {
                BD.ActualizarContrasena(u.IdUsuarios, Contrasenas.Hashear(l.Contrasena));
            }

            HttpContext.Session.SetInt32("UsuarioId", u.IdUsuarios);
            SesionUsuario.GuardarDatosHeader(HttpContext.Session, u);

            return RedirectToAction("Index", "Home");
        }

        ViewBag.Error = "Email o contraseña incorrectos";
        return View("Login");
    }

    [HttpPost]
    public IActionResult Registro(RegistroViewModel r, string password2)
    {
        ViewBag.registro = r;
        if (!ModelState.IsValid) return View();

        if (BD.UsuarioExiste(r.Mail))
        {
            ViewBag.Error = "Ya existe una cuenta con ese email.";
            return View();
        }

        if (r.Contrasena != password2)
        {
            ViewBag.Error = "Las contraseñas no coinciden.";
            return View();
        }

        Usuarios u = new Usuarios
        {
            Nombre = r.Nombre,
            Apellido = r.Apellido,
            Mail = r.Mail,
            Contraseña = Contrasenas.Hashear(r.Contrasena),
            FechaNacimiento = r.FechaNacimiento!.Value,
            Edad = CalcularEdad(r.FechaNacimiento.Value),
            Telefono = Telefonos.Convertir(r.Telefono),
            Usuario = r.Mail.Split('@')[0],
            Barrio = string.Empty,
            IdProvincias = 1
        };

        BD.Register(u);

        Usuarios? usuario = BD.GetUsuarioByMail(u.Mail);

        if (usuario != null)
        {
            HttpContext.Session.SetInt32("UsuarioId", usuario.IdUsuarios);
            SesionUsuario.GuardarDatosHeader(HttpContext.Session, usuario);
        }

        return RedirectToAction("Index", "Home");
    }

    [HttpPost]
    public IActionResult CambiarContrasena(
        string? contrasenaActual,
        string? contrasenaNueva,
        string? confirmarContrasena)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");

        if (usuarioId == null)
        {
            return RedirectToAction("Index", "Account");
        }

        Usuarios? usuario = BD.GetUsuarioById(usuarioId.Value);

        if (usuario == null)
        {
            return RedirectToAction("Index", "Account");
        }

        if (!Contrasenas.Verificar(usuario.Contraseña, contrasenaActual ?? string.Empty, out _))
        {
            ViewBag.Error = "La contraseña actual es incorrecta.";
            return View();
        }

        if (string.IsNullOrEmpty(contrasenaNueva) || contrasenaNueva.Length < 8 || contrasenaNueva.Length > 50)
        {
            ViewBag.Error = "La nueva contraseña tiene que tener entre 8 y 50 caracteres.";
            return View();
        }

        if (contrasenaNueva != confirmarContrasena)
        {
            ViewBag.Error = "Las nuevas contraseñas no coinciden.";
            return View();
        }

        BD.ActualizarContrasena(usuario.IdUsuarios, Contrasenas.Hashear(contrasenaNueva));

        ViewBag.Message = "Contraseña cambiada exitosamente.";

        return View();
    }

    public IActionResult Logout()
    {
        HttpContext.Session.Clear();

        return RedirectToAction("Index", "Account");
    }

    private static int CalcularEdad(DateTime fechaNacimiento)
    {
        int edad = DateTime.Today.Year - fechaNacimiento.Year;
        if (fechaNacimiento.Date > DateTime.Today.AddYears(-edad)) edad--;
        return edad;
    }
}
