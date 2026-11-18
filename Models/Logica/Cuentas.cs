using Swappit.Models.ViewModels;

namespace Swappit.Models;

public static class Cuentas
{
    public const int MinLargoContrasena = 8;
    public const int MaxLargoContrasena = 50;

    public static Usuarios? IniciarSesion(string mail, string contrasena)
    {
        Usuarios? usuario = UsuariosBD.GetUsuarioByMail(mail);
        if (usuario == null || !Contrasenas.Verificar(usuario.Contraseña, contrasena, out bool hayQueActualizar))
        {
            return null;
        }
        if (hayQueActualizar)
        {
            UsuariosBD.ActualizarContrasena(usuario.IdUsuarios, Contrasenas.Hashear(contrasena));
        }
        return usuario;
    }

    public static string? ValidarProvincia(List<Provincias> provincias, int? idProvincia)
    {
        if (idProvincia == null)
        {
            return null;
        }
        foreach (Provincias p in provincias)
        {
            if (p.IdProvincia == idProvincia)
            {
                return null;
            }
        }
        return "Elegí una provincia de la lista";
    }

    public static string? ContrasenaParaRepetir(RegistroViewModel r, string? password2, bool contrasenaValida)
    {
        return contrasenaValida && r.Contrasena == password2 ? r.Contrasena : null;
    }

    public static ErrorCampo? ValidarRegistro(RegistroViewModel r, string? password2)
    {
        if (UsuariosBD.UsuarioExiste(r.Mail))
        {
            return new ErrorCampo("", "Ya existe una cuenta con ese email.");
        }
        if (r.Contrasena != password2)
        {
            return new ErrorCampo("", "Las contraseñas no coinciden.");
        }

        int edad = CalcularEdad(r.FechaNacimiento!.Value);
        if (edad < RegistroViewModel.EdadMinima)
        {
            return new ErrorCampo(nameof(r.FechaNacimiento), $"Debes tener al menos {RegistroViewModel.EdadMinima} años para registrarte.");
        }
        if (edad > RegistroViewModel.EdadMaxima)
        {
            return new ErrorCampo(nameof(r.FechaNacimiento), $"La edad máxima permitida es {RegistroViewModel.EdadMaxima} años.");
        }

        if (!Telefonos.EsValido(Telefonos.Convertir(r.Telefono)))
        {
            return new ErrorCampo(nameof(r.Telefono), $"El teléfono tiene que tener entre {Telefonos.MinDigitos} y {Telefonos.MaxDigitos} dígitos.");
        }
        return null;
    }

    public static Usuarios? Registrar(RegistroViewModel r)
    {
        Usuarios u = new Usuarios
        {
            Nombre = r.Nombre,
            Apellido = r.Apellido,
            Mail = r.Mail,
            Contraseña = Contrasenas.Hashear(r.Contrasena),
            FechaNacimiento = r.FechaNacimiento!.Value,
            Edad = CalcularEdad(r.FechaNacimiento!.Value),
            Telefono = Telefonos.Convertir(r.Telefono),
            Usuario = r.Mail.Split('@')[0],
            Barrio = r.Barrio.Trim(),
            IdProvincias = r.IdProvincias!.Value
        };

        UsuariosBD.Register(u);
        return UsuariosBD.GetUsuarioByMail(u.Mail);
    }

    public static string? CambiarContrasena(Usuarios usuario, string? actual, string? nueva, string? confirmacion)
    {
        if (!Contrasenas.Verificar(usuario.Contraseña, actual ?? string.Empty, out _))
        {
            return "La contraseña actual es incorrecta.";
        }
        if (string.IsNullOrEmpty(nueva) || nueva.Length < MinLargoContrasena || nueva.Length > MaxLargoContrasena)
        {
            return $"La nueva contraseña tiene que tener entre {MinLargoContrasena} y {MaxLargoContrasena} caracteres.";
        }
        if (nueva != confirmacion)
        {
            return "Las nuevas contraseñas no coinciden.";
        }

        UsuariosBD.ActualizarContrasena(usuario.IdUsuarios, Contrasenas.Hashear(nueva));
        return null;
    }

    public static int CalcularEdad(DateTime fechaNacimiento)
    {
        int edad = DateTime.Today.Year - fechaNacimiento.Year;
        if (fechaNacimiento.Date > DateTime.Today.AddYears(-edad)) edad--;
        return edad;
    }
}
