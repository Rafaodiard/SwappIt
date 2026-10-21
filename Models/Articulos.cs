namespace Swappit.Models;
public class Articulos
{
    public int IdArticulos { get; set; }
    public string? Nombre { get; set; }
    public string? Descripcion { get; set; }
    public string? Estado { get; set; }
    public int IdUsuarios { get; set; }
    public int IdCategorias { get; set; }
}
