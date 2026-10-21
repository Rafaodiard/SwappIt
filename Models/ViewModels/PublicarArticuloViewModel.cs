using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Mvc.ModelBinding.Validation;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace Swappit.Models.ViewModels
{
    // Datos del formulario de Views/Home/Publicar.cshtml
    // Los nombres de las propiedades coinciden con los asp-for de la vista.
    public class PublicarArticuloViewModel
    {
        public const int MaxFotos = 6;
        public const int MaxDescripcion = 500;

        // Valores del selector de estado (chips). Se guardan como texto en Articulos.Estado.
        public static readonly string[] Estados = { "Como nuevo", "Muy buen estado", "Buen estado", "Usado" };

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
        public string Estado { get; set; } = "Muy buen estado";

        [Required(ErrorMessage = "Contá cómo es tu objeto")]
        [StringLength(MaxDescripcion, ErrorMessage = "Máximo {1} caracteres")]
        [Display(Name = "Descripción")]
        public string Descripcion { get; set; } = string.Empty;

        // Opcional: se puede dejar abierto a propuestas.
        [StringLength(100, ErrorMessage = "Máximo {1} caracteres")]
        [Display(Name = "¿Qué te gustaría recibir a cambio?")]
        public string? ACambio { get; set; }

        // Hasta MaxFotos imágenes JPG/PNG de máx. 10 MB. La primera es la portada.
        public List<IFormFile>? Fotos { get; set; }

        // Opciones del <select> de categorías (tabla Categorias).
        [ValidateNever]
        public IEnumerable<SelectListItem> Categorias { get; set; } = new List<SelectListItem>();

        // TODO (BD): la tabla Articulos hoy solo tiene Nombre, Descripcion (varchar(50)),
        // Estado, IdUsuarios e IdCategorias. Faltan columnas/tablas para fotos,
        // ubicación y "a cambio", y Descripcion tiene que ampliarse a 500 caracteres.
    }
}
