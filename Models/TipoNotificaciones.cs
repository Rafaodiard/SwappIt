namespace Swappit.Models;
public class TipoNotificaciones
{
    public const string PropuestaRecibida = "Propuesta recibida";
    public const string PropuestaAceptada = "Propuesta aceptada";
    public const string PropuestaRechazada = "Propuesta rechazada";
    public const string MensajeNuevo = "Mensaje nuevo";
    public const string IntercambioCancelado = "Intercambio cancelado";

    public int Id { get; set; }
    public string? Nombre { get; set; }
}
