namespace Swappit.Models;

public class DatosMailNotificacion
{
    public string? Mail { get; set; }
    public string? Nombre { get; set; }

    public string? OtroNombre { get; set; }

    public List<string> MisArticulos { get; set; } = new List<string>();
    public List<string> SusArticulos { get; set; } = new List<string>();
}
