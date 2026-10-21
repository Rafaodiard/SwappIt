namespace Swappit.Models;
public class Usuarios
{
    public int IdUsuarios { get; set; }
    public string? Nombre { get; set; }
    public string? Apellido { get; set; }
    public string? Usuario { get; set; }
    public string? Mail { get; set; }
    public int Telefono { get; set; }
    public string? Contraseña { get; set; }
    public string? Barrio { get; set; }
    public DateTime FechaNacimiento { get; set; }
    public int Edad { get; set; }
    public int IdProvincias { get; set; }
}
