namespace Swappit.Models;

public static class SesionUsuario
{
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
