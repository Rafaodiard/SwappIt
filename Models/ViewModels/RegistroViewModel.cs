using System.ComponentModel.DataAnnotations;

namespace Swappit.Models.ViewModels
{
    public class RegistroViewModel : IValidatableObject
    {
        public const int EdadMinima = 18;
        public const int EdadMaxima = 100;

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

        [Required(ErrorMessage = "Elegí tu provincia")]
        [Display(Name = "Provincia")]
        public int? IdProvincias { get; set; }

        [Required(ErrorMessage = "Ingresá tu barrio")]
        [StringLength(50, ErrorMessage = "Máximo {1} caracteres")]
        [Display(Name = "Barrio")]
        public string Barrio { get; set; } = string.Empty;

        [Display(Name = "Tipo de suscripción")]
        public string PlanSuscripcion { get; set; } = "Gratis";

        public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
        {
            if (!FechaNacimiento.HasValue)
            {
                yield break;
            }

            int edad = CalcularEdad(FechaNacimiento.Value);

            if (edad < EdadMinima)
            {
                yield return new ValidationResult($"Debes tener al menos {EdadMinima} años para registrarte.", new[] { nameof(FechaNacimiento) });
            }

            if (edad > EdadMaxima)
            {
                yield return new ValidationResult($"La edad máxima permitida es {EdadMaxima} años.", new[] { nameof(FechaNacimiento) });
            }
        }

        private static int CalcularEdad(DateTime fechaNacimiento)
        {
            int edad = DateTime.Today.Year - fechaNacimiento.Year;
            if (fechaNacimiento.Date > DateTime.Today.AddYears(-edad)) edad--;
            return edad;
        }
    }
}
