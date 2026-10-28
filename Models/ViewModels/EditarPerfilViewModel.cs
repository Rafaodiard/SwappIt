using System.ComponentModel.DataAnnotations;

namespace Swappit.Models.ViewModels
{
    // Datos del pop up "Editar perfil" de Views/Account/Perfil.cshtml
    // Los nombres de las propiedades coinciden con los name de los inputs del formulario.
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

        // Columna Usuarios.Descripcion (varchar(500), opcional). Se muestra en Perfil/Index y Perfil/Publico.
        [StringLength(MaxDescripcion, ErrorMessage = "La descripción puede tener hasta {1} caracteres")]
        public string? Descripcion { get; set; }

        [Required(ErrorMessage = "Elegí una provincia")]
        public int IdProvincias { get; set; }

        // Nueva foto de perfil (opcional). JPG/PNG de máx. MaxFotoMB. Se guarda en la tabla Imagenes.
        public IFormFile? Foto { get; set; }

        // true si el usuario tocó "Quitar foto".
        public bool QuitarFoto { get; set; }
    }
}
