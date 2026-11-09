using System.ComponentModel.DataAnnotations;

namespace Swappit.Models.ViewModels
{
    public class EditarPerfilViewModel
    {
        public const int MaxFotoMB = 5;
        public const int MaxDescripcion = 500;
        public static readonly string[] ExtensionesFoto = { ".jpg", ".jpeg", ".png" };

        [Required(ErrorMessage = "Ingresá tu nombre")]
        [StringLength(50, ErrorMessage = "El nombre puede tener hasta {1} caracteres")]
        public string Nombre { get; set; } = string.Empty;

        [Required(ErrorMessage = "Ingresá tu apellido")]
        [StringLength(50, ErrorMessage = "El apellido puede tener hasta {1} caracteres")]
        public string Apellido { get; set; } = string.Empty;

        [Required(ErrorMessage = "Ingresá un nombre de usuario")]
        [StringLength(50, ErrorMessage = "El usuario puede tener hasta {1} caracteres")]
        public string Usuario { get; set; } = string.Empty;

        [Phone(ErrorMessage = "Ingresá un teléfono válido")]
        public string? Telefono { get; set; }

        [StringLength(50, ErrorMessage = "El barrio puede tener hasta {1} caracteres")]
        public string? Barrio { get; set; }

        [StringLength(MaxDescripcion, ErrorMessage = "La descripción puede tener hasta {1} caracteres")]
        public string? Descripcion { get; set; }

        [Required(ErrorMessage = "Elegí una provincia")]
        public int IdProvincias { get; set; }

        public IFormFile? Foto { get; set; }

        public bool QuitarFoto { get; set; }
    }
}
