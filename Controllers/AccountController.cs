using Microsoft.AspNetCore.Mvc;
using Swappit.Models;
using Swappit.Models.ViewModels;

namespace Swappit.Controllers;

public class AccountController : Controller
{
    private readonly IWebHostEnvironment _env;

    public AccountController(IWebHostEnvironment env)
    {
        _env = env;
    }

    public IActionResult Index()
    {
        return View("Login", new LoginViewModel());
    }
    public IActionResult Perfil()
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
            if (usuarioId == null)
            {
                return RedirectToAction("Index");
            }

            Usuarios? usuario = BD.GetUsuarioById(usuarioId.Value);
            if (usuario == null)
            {
                return RedirectToAction("Index");
            }

            ViewBag.usuario = usuario;
            ViewBag.provincia = BD.GetProvinciaById(usuario.IdProvincias);
            ViewBag.provincias = BD.GetProvincias();
            return View();
    }
    public IActionResult Registro()
    {
        return View(new RegistroViewModel());
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
        if (!ModelState.IsValid) return View("Login", l);

        Usuarios? u = BD.Login(l);

        if (u != null)
        {
            HttpContext.Session.SetInt32("UsuarioId", u.IdUsuarios);
            GuardarDatosHeader(u);

            return RedirectToAction("Index", "Home");
        }

        ViewBag.Error = "Email o contraseña incorrectos";
        return View("Login", l);
    }

    [HttpPost]
    public IActionResult Registro(RegistroViewModel r, string password2)
    {
        if (!ModelState.IsValid) return View(r);

        if (BD.UsuarioExiste(r.Mail))
        {
            ViewBag.Error = "Ya existe una cuenta con ese email.";
            return View(r);
        }

        if (r.Contrasena != password2)
        {
            ViewBag.Error = "Las contraseñas no coinciden.";
            return View(r);
        }

        Usuarios u = new Usuarios
        {
            Nombre = r.Nombre,
            Apellido = r.Apellido,
            Mail = r.Mail,
            Contraseña = r.Contrasena,
            FechaNacimiento = r.FechaNacimiento!.Value,
            Edad = CalcularEdad(r.FechaNacimiento.Value),
            Telefono = ConvertirTelefono(r.Telefono),
            // TODO: el formulario no pide Usuario, Barrio ni Provincia.
            Usuario = r.Mail.Split('@')[0],
            Barrio = string.Empty,
            IdProvincias = 1
        };

        BD.Register(u);

        LoginViewModel login = new LoginViewModel
        {
            Mail = u.Mail,
            Contrasena = u.Contraseña
        };

        Usuarios? usuario = BD.Login(login);

        if (usuario != null)
        {
            HttpContext.Session.SetInt32("UsuarioId", usuario.IdUsuarios);
            GuardarDatosHeader(usuario);
        }

        return RedirectToAction("Index", "Home");
    }

    [HttpPost]
    public IActionResult CambiarContrasena(
        string contrasenaActual,
        string contrasenaNueva,
        string confirmarContrasena)
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

        if (usuario.Contraseña != contrasenaActual)
        {
            ViewBag.Error = "La contraseña actual es incorrecta.";
            return View();
        }

        if (contrasenaNueva != confirmarContrasena)
        {
            ViewBag.Error = "Las nuevas contraseñas no coinciden.";
            return View();
        }

        usuario.Contraseña = contrasenaNueva;

        BD.UpdateUsuario(usuario);

        ViewBag.Message = "Contraseña cambiada exitosamente.";

        return View();
    }

    [HttpPost]
    public IActionResult EditarPerfil(EditarPerfilViewModel e)
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

        // Los errores se muestran en el pop up: Perfil lo vuelve a abrir si hay TempData["ErrorPerfil"]
        if (!ModelState.IsValid)
        {
            TempData["ErrorPerfil"] = ModelState.Values.SelectMany(v => v.Errors).First().ErrorMessage;
            return RedirectToAction("Perfil");
        }

        if (e.Foto != null)
        {
            string extension = Path.GetExtension(e.Foto.FileName).ToLower();

            if (!EditarPerfilViewModel.ExtensionesFoto.Contains(extension))
            {
                TempData["ErrorPerfil"] = "La foto tiene que ser JPG o PNG.";
                return RedirectToAction("Perfil");
            }

            if (e.Foto.Length > EditarPerfilViewModel.MaxFotoMB * 1024 * 1024)
            {
                TempData["ErrorPerfil"] = $"La foto puede pesar hasta {EditarPerfilViewModel.MaxFotoMB} MB.";
                return RedirectToAction("Perfil");
            }

            BorrarFoto(usuario.Foto);
            usuario.Foto = GuardarFoto(e.Foto, usuario.IdUsuarios, extension);
        }
        else if (e.QuitarFoto)
        {
            BorrarFoto(usuario.Foto);
            usuario.Foto = null;
        }

        usuario.Nombre = e.Nombre.Trim();
        usuario.Apellido = e.Apellido.Trim();
        usuario.Usuario = e.Usuario.Trim().TrimStart('@');
        usuario.Telefono = ConvertirTelefono(e.Telefono ?? string.Empty);
        usuario.Barrio = e.Barrio?.Trim() ?? string.Empty;
        usuario.IdProvincias = e.IdProvincias;
        usuario.Descripcion = string.IsNullOrWhiteSpace(e.Descripcion) ? null : e.Descripcion.Trim();

        BD.UpdateUsuario(usuario);
        GuardarDatosHeader(usuario);

        TempData["MensajePerfil"] = "Perfil actualizado.";

        return RedirectToAction("Perfil");
    }

    public IActionResult Logout()
    {
        HttpContext.Session.Clear();

        return RedirectToAction("Index", "Account");
    }

    // Iniciales y foto se guardan en la session para mostrarlas en el avatar del header.
    private void GuardarDatosHeader(Usuarios u)
    {
        HttpContext.Session.SetString("Iniciales", ObtenerIniciales(u));

        if (u.Foto != null)
        {
            HttpContext.Session.SetString("Foto", u.Foto);
        }
        else
        {
            HttpContext.Session.Remove("Foto");
        }
    }

    private static string ObtenerIniciales(Usuarios u)
    {
        return $"{u.Nombre?.FirstOrDefault()}{u.Apellido?.FirstOrDefault()}".ToUpper();
    }

    // Las fotos de perfil se guardan en wwwroot/img/perfiles y en la BD queda la ruta.
    private string GuardarFoto(IFormFile foto, int idUsuario, string extension)
    {
        string carpeta = Path.Combine(_env.WebRootPath, "img", "perfiles");
        Directory.CreateDirectory(carpeta);

        string nombreArchivo = $"{idUsuario}_{Guid.NewGuid():N}{extension}";

        using (FileStream stream = new FileStream(Path.Combine(carpeta, nombreArchivo), FileMode.Create))
        {
            foto.CopyTo(stream);
        }

        return $"/img/perfiles/{nombreArchivo}";
    }

    private void BorrarFoto(string? ruta)
    {
        if (ruta == null || !ruta.StartsWith("/img/perfiles/")) return;

        string archivo = Path.Combine(_env.WebRootPath, "img", "perfiles", Path.GetFileName(ruta));
        if (System.IO.File.Exists(archivo))
        {
            System.IO.File.Delete(archivo);
        }
    }

    private static int CalcularEdad(DateTime fechaNacimiento)
    {
        int edad = DateTime.Today.Year - fechaNacimiento.Year;
        if (fechaNacimiento.Date > DateTime.Today.AddYears(-edad)) edad--;
        return edad;
    }

    // TODO: la columna Telefono es int y no entra un número completo (+54 9 11 ...).
    // Conviene pasarla a varchar; mientras tanto, si no entra se guarda 0.
    private static int ConvertirTelefono(string telefono)
    {
        string digitos = new string(telefono.Where(char.IsDigit).ToArray());
        return int.TryParse(digitos, out int numero) ? numero : 0;
    }
}
