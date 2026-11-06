using System.ComponentModel.DataAnnotations;

namespace Swappit.Models.ViewModels
{
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
        public int? IdEstado { get; set; }

        [Required(ErrorMessage = "Contá cómo es tu objeto")]
        [StringLength(MaxDescripcion, ErrorMessage = "Máximo {1} caracteres")]
        [Display(Name = "Descripción")]
        public string Descripcion { get; set; } = string.Empty;

        [Display(Name = "¿Qué te gustaría recibir a cambio?")]
        public int? IdCategoriaACambio { get; set; }

        public List<IFormFile>? Fotos { get; set; }
    }
}
