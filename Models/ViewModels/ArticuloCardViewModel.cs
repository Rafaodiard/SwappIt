namespace Swappit.Models.ViewModels;

// Datos que necesita la card de un artículo (Views/Shared/_CardObjeto.cshtml).
// Sale de Articulos + Usuarios (barrio del dueño) + Imagenes (primera foto del artículo).
public class ArticuloCardViewModel
{
    public int IdArticulos { get; set; }
    public string Nombre { get; set; } = "";
    public string Estado { get; set; } = "";
    public string? Barrio { get; set; }
    public string? Imagen { get; set; }
}
