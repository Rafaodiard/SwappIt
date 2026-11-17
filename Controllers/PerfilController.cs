using Microsoft.AspNetCore.Mvc;
using Swappit.Models;
using Swappit.Models.ViewModels;

namespace Swappit.Controllers;

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

        Usuarios? usuario = UsuariosBD.GetUsuarioById(usuarioId.Value);
        if (usuario == null)
        {
            return RedirectToAction("Index", "Account");
        }

        ViewBag.usuario = usuario;
        ViewBag.provincia = UsuariosBD.GetProvinciaById(usuario.IdProvincias);
        ViewBag.provincias = UsuariosBD.GetProvincias();
        ViewBag.foto = UsuariosBD.GetFotoUsuario(usuario.IdUsuarios);
        ViewBag.articulos = ArticulosBD.GetArticulosCatalogo(idUsuario: usuario.IdUsuarios, incluirEnIntercambio: true);
        ViewBag.intercambios = IntercambiosBD.GetIntercambios(usuario.IdUsuarios, cantidad: 3);
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
        ViewBag.provincia = UsuariosBD.GetProvinciaById(usuario.IdProvincias);
        ViewBag.foto = UsuariosBD.GetFotoUsuario(usuario.IdUsuarios);
        ViewBag.articulos = ArticulosBD.GetArticulosCatalogo(idUsuario: usuario.IdUsuarios);
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
            TempData["ErrorPerfil"] = PrimerError();
            return RedirectToAction("Index");
        }

        string telefono = Telefonos.Convertir(e.Telefono);

        if (telefono.Length > 0 && !Telefonos.EsValido(telefono))
        {
            TempData["ErrorPerfil"] = $"El teléfono tiene que tener entre {Telefonos.MinDigitos} y {Telefonos.MaxDigitos} dígitos.";
            return RedirectToAction("Index");
        }

        if (e.Foto != null)
        {
            string extension = Path.GetExtension(e.Foto.FileName).ToLower();

            if (Array.IndexOf(EditarPerfilViewModel.ExtensionesFoto, extension) < 0)
            {
                TempData["ErrorPerfil"] = "La foto tiene que ser JPG o PNG.";
                return RedirectToAction("Index");
            }

            if (e.Foto.Length > EditarPerfilViewModel.MaxFotoMB * 1024 * 1024)
            {
                TempData["ErrorPerfil"] = $"La foto puede pesar hasta {EditarPerfilViewModel.MaxFotoMB} MB.";
                return RedirectToAction("Index");
            }

            BorrarFoto(UsuariosBD.GetFotoUsuario(usuario.IdUsuarios));
            UsuariosBD.GuardarFotoUsuario(usuario.IdUsuarios, GuardarFoto(e.Foto, usuario.IdUsuarios, extension));
        }
        else if (e.QuitarFoto)
        {
            BorrarFoto(UsuariosBD.GetFotoUsuario(usuario.IdUsuarios));
            UsuariosBD.BorrarFotoUsuario(usuario.IdUsuarios);
        }

        usuario.Nombre = e.Nombre.Trim();
        usuario.Apellido = e.Apellido.Trim();
        usuario.Usuario = e.Usuario.Trim().TrimStart('@');
        usuario.Telefono = telefono;
        usuario.Barrio = e.Barrio?.Trim() ?? string.Empty;
        usuario.IdProvincias = e.IdProvincias;
        usuario.Descripcion = string.IsNullOrWhiteSpace(e.Descripcion) ? null : e.Descripcion.Trim();

        UsuariosBD.UpdateUsuario(usuario);
        SesionUsuario.GuardarDatosHeader(HttpContext.Session, usuario);

        TempData["MensajePerfil"] = "Perfil actualizado.";

        return RedirectToAction("Index");
    }

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

    private string PrimerError()
    {
        foreach (var campo in ModelState.Values)
        {
            foreach (var error in campo.Errors)
            {
                return error.ErrorMessage;
            }
        }
        return "";
    }
}
