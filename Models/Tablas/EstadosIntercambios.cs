namespace Swappit.Models;
public class EstadosIntercambios
{
    public const string Pendiente = "Pendiente";
    public const string Aceptado = "Aceptado";
    public const string Rechazado = "Rechazado";
    public const string Realizado = "Realizado";
    public const string Cancelado = "Cancelado";

    public int IdEstadosIntercambios { get; set; }
    public string? Nombre { get; set; }
}
