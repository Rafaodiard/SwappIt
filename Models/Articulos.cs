namespace Swappit.Models;
public class Articulos
{
    public int IdArticulos { get; set; }
    public string? Nombre { get; set; }
    public string? Descripcion { get; set; }
    public int IdEstado { get; set; }
    public int IdUsuarios { get; set; }
    public int IdCategorias { get; set; }
    public string? Ubicacion { get; set; }
    // Categoría que el dueño quiere recibir a cambio (null = abierto a propuestas).
    public int? IdCategoriaACambio { get; set; }
    public DateTime FechaPublicacion { get; set; }
}
