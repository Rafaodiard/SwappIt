namespace Swappit.Models;

public static class SesionUsuario
{
    public static void GuardarDatosHeader(ISession session, Usuarios u)
    {
        session.SetString("Iniciales", Iniciales(u.Nombre, u.Apellido));

        string? foto = UsuariosBD.GetFotoUsuario(u.IdUsuarios);
        if (foto != null)
        {
            session.SetString("Foto", foto);
        }
        else
        {
            session.Remove("Foto");
        }
    }

    public static string Iniciales(string? nombre, string? apellido)
    {
        string iniciales = "";
        if (!string.IsNullOrEmpty(nombre))
        {
            iniciales += nombre[0];
        }
        if (!string.IsNullOrEmpty(apellido))
        {
            iniciales += apellido[0];
        }
        return iniciales.ToUpper();
    }
}
