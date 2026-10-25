using System.ComponentModel.DataAnnotations;

namespace Swappit.Models.ViewModels
{
    // Datos del formulario de Views/Account/Login.cshtml (llegan por POST).
    // Los nombres de las propiedades coinciden con los name de los inputs de la vista.
    public class LoginViewModel
    {
        [Required(ErrorMessage = "Ingresá tu email")]
        [EmailAddress(ErrorMessage = "Ingresá un email válido")]
        [StringLength(50)]
        [Display(Name = "Email")]
        public string Mail { get; set; } = string.Empty;

        [Required(ErrorMessage = "Ingresá tu contraseña")]
        [DataType(DataType.Password)]
        [Display(Name = "Contraseña")]
        public string Contrasena { get; set; } = string.Empty;
    }
}
