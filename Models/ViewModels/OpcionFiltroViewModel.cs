namespace Swappit.Models.ViewModels;

// Una opción de los filtros de Buscar (categoría o estado) y cuántos artículos la tienen.
public class OpcionFiltroViewModel
{
    public string Valor { get; set; } = "";
    public string Texto { get; set; } = "";
    public int Cantidad { get; set; }
}
