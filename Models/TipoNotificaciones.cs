namespace Swappit.Models;
// Tabla TipoNotificaciones (se carga con BaseDatos/Notificaciones.sql). Notificaciones.IdTipoNotificacion apunta acá.
public class TipoNotificaciones
{
    // Nombres de la tabla (BD.cs busca el Id por nombre para no depender de los ids).
    // Propuesta recibida: al dueño del artículo pedido. Aceptada o rechazada: a quien propuso.
    // Intercambio cancelado: a la otra persona, cuando uno de los dos lo cancela.
    public const string PropuestaRecibida = "Propuesta recibida";
    public const string PropuestaAceptada = "Propuesta aceptada";
    public const string PropuestaRechazada = "Propuesta rechazada";
    public const string MensajeNuevo = "Mensaje nuevo";
    public const string IntercambioCancelado = "Intercambio cancelado";

    public int Id { get; set; }
    public string? Nombre { get; set; }
}
