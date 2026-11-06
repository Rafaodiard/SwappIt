namespace Swappit.Models;
public class TipoInteracciones
{
    public const string Vista = "Vista";
    public const string Busqueda = "Búsqueda";
    public const string FiltroCategoria = "Filtro por categoría";
    public const string Favorito = "Favorito";

    public int Id { get; set; }
    public string? Nombre { get; set; }
}
