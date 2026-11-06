namespace Swappit.Models.ViewModels;

public class ArticuloCardViewModel
{
    public int IdArticulos { get; set; }
    public string Nombre { get; set; } = "";
    public string Estado { get; set; } = "";
    public string? Barrio { get; set; }
    public string? Imagen { get; set; }

    public int IdUsuarios { get; set; }
    public int IdCategorias { get; set; }
    public int? IdCategoriaACambio { get; set; }

    public string? Motivo { get; set; }
}
