namespace Swappit.Models;

public class Resultado
{
    public string? Error { get; set; }
    public string? Mensaje { get; set; }
    public int? Id { get; set; }
    public bool NoExiste { get; set; }
    public List<NotificacionCreada> Notificaciones { get; } = new List<NotificacionCreada>();

    public static Resultado ConError(string error)
    {
        return new Resultado { Error = error };
    }

    public static Resultado ConMensaje(string mensaje)
    {
        return new Resultado { Mensaje = mensaje };
    }
}
