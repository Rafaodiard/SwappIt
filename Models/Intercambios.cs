namespace Swappit.Models;
public class Intercambios
{
    public int IdIntercambios { get; set; }
    public DateTime Fecha { get; set; }
    public bool fueRealizado { get; set; }
    public int IdUsuarios1 { get; set; }
    public int IdUsuarios2 { get; set; }
    public int IdArticulos1 { get; set; }
    public int IdArticulos2 { get; set; }
}
