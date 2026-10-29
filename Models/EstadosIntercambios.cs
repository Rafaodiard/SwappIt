namespace Swappit.Models;
// Tabla EstadosIntercambios: Pendiente, Aceptado, Rechazado o Realizado. Intercambios.IdEstado apunta acá.
public class EstadosIntercambios
{
    // Nombres de la tabla (BD.cs busca el IdEstadosIntercambios por nombre para no depender de los ids).
    // Pendiente -> Aceptado -> Realizado, o Pendiente -> Rechazado.
    public const string Pendiente = "Pendiente";
    public const string Aceptado = "Aceptado";
    public const string Rechazado = "Rechazado";
    public const string Realizado = "Realizado";

    public int IdEstadosIntercambios { get; set; }
    public string? Nombre { get; set; }
}
