namespace Swappit.Models.ViewModels;

// Datos que necesita la card de un artículo (Views/Shared/_CardObjeto.cshtml).
// Sale de Articulos + Usuarios + Imagenes (primera foto del artículo).
// Barrio = Articulos.Ubicacion, o el barrio del dueño si el artículo no tiene ubicación.
public class ArticuloCardViewModel
{
    public int IdArticulos { get; set; }
    public string Nombre { get; set; } = "";
    public string Estado { get; set; } = "";
    public string? Barrio { get; set; }
    public string? Imagen { get; set; }

    // Para ordenar y recomendar (RecomendacionesController). No se muestran en la card.
    public int IdUsuarios { get; set; }
    public int IdCategorias { get; set; }
    public int? IdCategoriaACambio { get; set; }

    // Por qué se recomienda (ej: "Le interesa algo tuyo"). Solo lo completa RecomendacionesController;
    // si es null, la card no muestra nada.
    public string? Motivo { get; set; }
}
