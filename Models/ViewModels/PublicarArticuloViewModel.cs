using System.ComponentModel.DataAnnotations;

namespace Swappit.Models.ViewModels
{
    // Datos del formulario de Views/Home/Publicar.cshtml (llegan por POST).
    // Los nombres de las propiedades coinciden con los name de los inputs de la vista.
    // Las opciones de categorías y estados van aparte, en ViewBag.categorias y ViewBag.estados.
    public class PublicarArticuloViewModel
    {
        public const int MaxFotos = 6;
        public const int MaxFotoMB = 10;
        public const int MaxDescripcion = 500;
        public static readonly string[] ExtensionesFoto = { ".jpg", ".jpeg", ".png" };

        [Required(ErrorMessage = "Ponele un título a tu objeto")]
        [StringLength(50, ErrorMessage = "Máximo {1} caracteres")]
        [Display(Name = "Título")]
        public string Titulo { get; set; } = string.Empty;

        [Required(ErrorMessage = "Elegí una categoría")]
        [Display(Name = "Categoría")]
        public int? IdCategorias { get; set; }

        [Required(ErrorMessage = "Indicá dónde está el objeto")]
        [StringLength(100, ErrorMessage = "Máximo {1} caracteres")]
        [Display(Name = "Ubicación")]
        public string Ubicacion { get; set; } = string.Empty;

        [Required(ErrorMessage = "Elegí el estado del objeto")]
        [Display(Name = "Estado del objeto")]
        // Un IdEstadosArticulos de la tabla EstadosArticulos. Se guarda en Articulos.IdEstado.
        public int? IdEstado { get; set; }

        [Required(ErrorMessage = "Contá cómo es tu objeto")]
        [StringLength(MaxDescripcion, ErrorMessage = "Máximo {1} caracteres")]
        [Display(Name = "Descripción")]
        public string Descripcion { get; set; } = string.Empty;

        // Opcional: se puede dejar abierto a propuestas.
        [StringLength(100, ErrorMessage = "Máximo {1} caracteres")]
        [Display(Name = "¿Qué te gustaría recibir a cambio?")]
        public string? ACambio { get; set; }

        // Hasta MaxFotos imágenes JPG/PNG de máx. MaxFotoMB. La primera es la portada.
        // Se guardan en wwwroot/img/articulos y en la tabla Imagenes (con IdArticulos).
        public List<IFormFile>? Fotos { get; set; }

        // Titulo -> Articulos.Nombre.
    }
}
