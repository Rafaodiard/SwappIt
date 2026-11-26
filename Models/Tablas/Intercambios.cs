namespace Swappit.Models;
public class Intercambios
{
    public const int MaxArticulosOfrecidos = 3;

    public int IdIntercambios { get; set; }
    public DateTime Fecha { get; set; }
    public int IdEstado { get; set; }
    public int IdUsuarios1 { get; set; }
    public int IdUsuarios2 { get; set; }
    public bool RealizadoUsuario1 { get; set; }
    public bool RealizadoUsuario2 { get; set; }
}
