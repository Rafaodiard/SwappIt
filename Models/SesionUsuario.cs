namespace Swappit.Models;

// Datos del usuario logueado que se guardan en la session para mostrarlos en el header (_Layout.cshtml).
// Lo usan AccountController (al iniciar sesión o registrarse) y PerfilController (al editar el perfil).
public static class SesionUsuario
{
    // Iniciales y foto se guardan en la session para mostrarlas en el avatar del header.
    public static void GuardarDatosHeader(ISession session, Usuarios u)
    {
        session.SetString("Iniciales", ObtenerIniciales(u));

        string? foto = BD.GetFotoUsuario(u.IdUsuarios);
        if (foto != null)
        {
            session.SetString("Foto", foto);
        }
        else
        {
            session.Remove("Foto");
        }
    }

    private static string ObtenerIniciales(Usuarios u)
    {
        return $"{u.Nombre?.FirstOrDefault()}{u.Apellido?.FirstOrDefault()}".ToUpper();
    }
}
