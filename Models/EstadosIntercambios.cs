namespace Swappit.Models;
// Tabla EstadosIntercambios: Pendiente, Aceptado, Rechazado, Realizado o Cancelado. Intercambios.IdEstado apunta acá.
public class EstadosIntercambios
{
    // Nombres de la tabla (BD.cs busca el IdEstadosIntercambios por nombre para no depender de los ids).
    // Pendiente -> Aceptado -> Realizado, o Pendiente -> Rechazado.
    // Cancelado: quien propuso retira una propuesta Pendiente, o cualquiera de los dos cancela uno Aceptado.
    public const string Pendiente = "Pendiente";
    public const string Aceptado = "Aceptado";
    public const string Rechazado = "Rechazado";
    public const string Realizado = "Realizado";
    public const string Cancelado = "Cancelado";

    public int IdEstadosIntercambios { get; set; }
    public string? Nombre { get; set; }
}
