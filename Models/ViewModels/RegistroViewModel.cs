using System.ComponentModel.DataAnnotations;

namespace Swappit.Models.ViewModels
{
    // Datos del formulario de Views/Home/Registro.cshtml
    // Los nombres de las propiedades coinciden con los asp-for de la vista.
    // Longitudes máximas = columnas de la tabla Usuarios (varchar(50)).
    public class RegistroViewModel
    {
        [Required(ErrorMessage = "Ingresá tu nombre")]
        [StringLength(50, ErrorMessage = "Máximo {1} caracteres")]
        [Display(Name = "Nombre")]
        public string Nombre { get; set; } = string.Empty;

        [Required(ErrorMessage = "Ingresá tu apellido")]
        [StringLength(50, ErrorMessage = "Máximo {1} caracteres")]
        [Display(Name = "Apellido")]
        public string Apellido { get; set; } = string.Empty;

        [Required(ErrorMessage = "Ingresá tu email")]
        [EmailAddress(ErrorMessage = "Ingresá un email válido")]
        [StringLength(50, ErrorMessage = "Máximo {1} caracteres")]
        [Display(Name = "Email")]
        public string Mail { get; set; } = string.Empty;

        [Required(ErrorMessage = "Elegí una contraseña")]
        [StringLength(50, MinimumLength = 8, ErrorMessage = "Tiene que tener entre {2} y {1} caracteres")]
        [DataType(DataType.Password)]
        [Display(Name = "Contraseña")]
        public string Contrasena { get; set; } = string.Empty;

        [Required(ErrorMessage = "Ingresá tu fecha de nacimiento")]
        [DataType(DataType.Date)]
        [Display(Name = "Fecha de nacimiento")]
        public DateTime? FechaNacimiento { get; set; }

        [Required(ErrorMessage = "Ingresá tu número de teléfono")]
        [Phone(ErrorMessage = "Ingresá un teléfono válido")]
        [Display(Name = "Número de teléfono")]
        public string Telefono { get; set; } = string.Empty;

        // TODO (BD): la tabla Usuarios también pide Usuario, Barrio e IdProvincias,
        // que el diseño de Figma no incluye. Hay que agregarlos al formulario
        // o resolverlos del lado del servidor antes de guardar.
    }
}
