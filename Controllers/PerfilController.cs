using Microsoft.AspNetCore.Mvc;
using Swappit.Models;
using Swappit.Models.ViewModels;

namespace Swappit.Controllers;

// Perfiles de usuario: mi perfil (/Perfil), editarlo con el pop up "Editar perfil" (POST /Perfil/Editar)
// y el perfil público de otro usuario (/Perfil/Publico/5).
public class PerfilController : Controller
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

        Usuarios? usuario = BD.GetUsuarioById(usuarioId.Value);
        if (usuario == null)
        {
            return RedirectToAction("Index", "Account");
        }

        ViewBag.usuario = usuario;
        ViewBag.provincia = BD.GetProvinciaById(usuario.IdProvincias);
        ViewBag.provincias = BD.GetProvincias();
        ViewBag.foto = BD.GetFotoUsuario(usuario.IdUsuarios);
        ViewBag.articulos = BD.GetArticulosCatalogo(idUsuario: usuario.IdUsuarios);
        return View();
    }

    public IActionResult Publico(int id)
    {
        if (HttpContext.Session.GetInt32("UsuarioId") == id)
        {
            return RedirectToAction("Index");
        }

        Usuarios? usuario = BD.GetUsuarioById(id);
        if (usuario == null)
        {
            Response.StatusCode = StatusCodes.Status404NotFound;
            ViewBag.usuario = null;
            return View();
        }

        ViewBag.usuario = new Usuarios
        {
            IdUsuarios = usuario.IdUsuarios,
            Nombre = usuario.Nombre,
            Apellido = usuario.Apellido,
            Usuario = usuario.Usuario,
            Barrio = usuario.Barrio,
            Descripcion = usuario.Descripcion
        };
        ViewBag.provincia = BD.GetProvinciaById(usuario.IdProvincias);
        ViewBag.foto = BD.GetFotoUsuario(usuario.IdUsuarios);
        ViewBag.articulos = BD.GetArticulosCatalogo(idUsuario: usuario.IdUsuarios);
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

        Usuarios? usuario = BD.GetUsuarioById(usuarioId.Value);

        if (usuario == null)
        {
            return RedirectToAction("Index", "Account");
        }

        if (!ModelState.IsValid)
        {
            TempData["ErrorPerfil"] = ModelState.Values.SelectMany(v => v.Errors).First().ErrorMessage;
            return RedirectToAction("Index");
        }

        if (e.Foto != null)
        {
            string extension = Path.GetExtension(e.Foto.FileName).ToLower();

            if (!EditarPerfilViewModel.ExtensionesFoto.Contains(extension))
            {
                TempData["ErrorPerfil"] = "La foto tiene que ser JPG o PNG.";
                return RedirectToAction("Index");
            }

            if (e.Foto.Length > EditarPerfilViewModel.MaxFotoMB * 1024 * 1024)
            {
                TempData["ErrorPerfil"] = $"La foto puede pesar hasta {EditarPerfilViewModel.MaxFotoMB} MB.";
                return RedirectToAction("Index");
            }

            BorrarFoto(BD.GetFotoUsuario(usuario.IdUsuarios));
            BD.GuardarFotoUsuario(usuario.IdUsuarios, GuardarFoto(e.Foto, usuario.IdUsuarios, extension));
        }
        else if (e.QuitarFoto)
        {
            BorrarFoto(BD.GetFotoUsuario(usuario.IdUsuarios));
            BD.BorrarFotoUsuario(usuario.IdUsuarios);
        }

        usuario.Nombre = e.Nombre.Trim();
        usuario.Apellido = e.Apellido.Trim();
        usuario.Usuario = e.Usuario.Trim().TrimStart('@');
        usuario.Telefono = Telefonos.Convertir(e.Telefono ?? string.Empty);
        usuario.Barrio = e.Barrio?.Trim() ?? string.Empty;
        usuario.IdProvincias = e.IdProvincias;
        usuario.Descripcion = string.IsNullOrWhiteSpace(e.Descripcion) ? null : e.Descripcion.Trim();

        BD.UpdateUsuario(usuario);
        SesionUsuario.GuardarDatosHeader(HttpContext.Session, usuario);

        TempData["MensajePerfil"] = "Perfil actualizado.";

        return RedirectToAction("Index");
    }

    // Las fotos de perfil se guardan en wwwroot/img/perfiles y la ruta va a Imagenes.Ruta,
    // que es varchar(50): por eso el nombre es corto (id + ticks en hexa, ~36 caracteres en total).
    private string GuardarFoto(IFormFile foto, int idUsuario, string extension)
    {
        string carpeta = Path.Combine(_env.WebRootPath, "img", "perfiles");
        Directory.CreateDirectory(carpeta);

        string nombreArchivo = $"{idUsuario}_{DateTime.Now.Ticks:x}{extension}";

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
}
