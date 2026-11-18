using Swappit.Models.ViewModels;

namespace Swappit.Models;

public static class Perfiles
{
    public static Usuarios DatosPublicos(Usuarios usuario)
    {
        return new Usuarios
        {
            IdUsuarios = usuario.IdUsuarios,
            Nombre = usuario.Nombre,
            Apellido = usuario.Apellido,
            Usuario = usuario.Usuario,
            Barrio = usuario.Barrio,
            Descripcion = usuario.Descripcion
        };
    }

    public static string Ubicacion(Usuarios usuario)
    {
        return Listas.UnirConComas(usuario.Barrio, UsuariosBD.GetProvinciaById(usuario.IdProvincias)?.Nombre);
    }

    public static bool TieneDescripcion(Usuarios usuario)
    {
        return !string.IsNullOrWhiteSpace(usuario.Descripcion);
    }

    public static string TextoOGuion(string? texto)
    {
        return string.IsNullOrEmpty(texto) ? "—" : texto;
    }

    public static string? Editar(Usuarios usuario, EditarPerfilViewModel e, string carpetaWeb)
    {
        string telefono = Telefonos.Convertir(e.Telefono);
        if (telefono.Length > 0 && !Telefonos.EsValido(telefono))
        {
            return $"El teléfono tiene que tener entre {Telefonos.MinDigitos} y {Telefonos.MaxDigitos} dígitos.";
        }

        if (e.Foto != null)
        {
            string extension = Path.GetExtension(e.Foto.FileName).ToLower();
            if (Array.IndexOf(EditarPerfilViewModel.ExtensionesFoto, extension) < 0)
            {
                return "La foto tiene que ser JPG o PNG.";
            }
            if (e.Foto.Length > EditarPerfilViewModel.MaxFotoMB * 1024 * 1024)
            {
                return $"La foto puede pesar hasta {EditarPerfilViewModel.MaxFotoMB} MB.";
            }

            BorrarFoto(UsuariosBD.GetFotoUsuario(usuario.IdUsuarios), carpetaWeb);
            UsuariosBD.GuardarFotoUsuario(usuario.IdUsuarios, GuardarFoto(e.Foto, usuario.IdUsuarios, extension, carpetaWeb));
        }
        else if (e.QuitarFoto)
        {
            BorrarFoto(UsuariosBD.GetFotoUsuario(usuario.IdUsuarios), carpetaWeb);
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
        return null;
    }

    private static string GuardarFoto(IFormFile foto, int idUsuario, string extension, string carpetaWeb)
    {
        string carpeta = Path.Combine(carpetaWeb, "img", "perfiles");
        Directory.CreateDirectory(carpeta);

        string nombreArchivo = $"{idUsuario}_{DateTime.Now.Ticks:x}{extension}";

        using (FileStream stream = new FileStream(Path.Combine(carpeta, nombreArchivo), FileMode.Create))
        {
            foto.CopyTo(stream);
        }

        return $"/img/perfiles/{nombreArchivo}";
    }

    private static void BorrarFoto(string? ruta, string carpetaWeb)
    {
        if (ruta == null || !ruta.StartsWith("/img/perfiles/")) return;

        string archivo = Path.Combine(carpetaWeb, "img", "perfiles", Path.GetFileName(ruta));
        if (File.Exists(archivo))
        {
            File.Delete(archivo);
        }
    }
}
