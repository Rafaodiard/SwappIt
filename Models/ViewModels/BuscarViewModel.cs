namespace Swappit.Models.ViewModels;

// Datos de Views/Home/Buscar.cshtml: resultados + estado de la búsqueda y los filtros.
public class BuscarViewModel
{
    public List<ArticuloCardViewModel> Articulos { get; set; } = new();

    // Texto del buscador del header (q).
    public string? Busqueda { get; set; }

    public List<OpcionFiltroViewModel> Categorias { get; set; } = new();
    public List<OpcionFiltroViewModel> Estados { get; set; } = new();

    // Lo que el usuario tiene marcado en el panel de filtros.
    public List<int> CategoriasSeleccionadas { get; set; } = new();
    public List<string> EstadosSeleccionados { get; set; } = new();

    // true si no se pudo leer la BD (para distinguir "error" de "sin resultados").
    public bool ErrorCarga { get; set; }

    public bool HayFiltros => CategoriasSeleccionadas.Count > 0 || EstadosSeleccionados.Count > 0;
}
