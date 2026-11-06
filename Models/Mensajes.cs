namespace Swappit.Models;
public class Mensajes
{
    public const int LargoMaximoTexto = 500;

    public int IdMensajes { get; set; }
    public string? Texto { get; set; }
    public bool fueVisto { get; set; }
    public DateTime FechaEnviado { get; set; }
    public DateTime? FechaRecibido { get; set; }
    public int IdUsuariosManda { get; set; }
    public int IdIntercambio { get; set; }
}
