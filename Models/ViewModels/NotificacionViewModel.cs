namespace Swappit.Models.ViewModels;

public class NotificacionViewModel
{
    public int Id { get; set; }
    public string Tipo { get; set; } = "";
    public bool Leida { get; set; }
    public DateTime Fecha { get; set; }
    public int IdIntercambio { get; set; }

    public string? OtroNombre { get; set; }
    public string? ArticuloNombre { get; set; }

    public string? CambioTipo { get; set; }
    public string? CambioArticulos { get; set; }
}
