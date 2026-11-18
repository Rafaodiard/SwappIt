namespace Swappit.Models;
public class TipoCambios
{
    public const string Agregar = "Agregar";
    public const string Sacar = "Sacar";
    public const string Pedir = "Pedir";

    public int Id { get; set; }
    public string? Nombre { get; set; }
}
