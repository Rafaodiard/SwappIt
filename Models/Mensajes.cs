namespace Swappit.Models;
// Tabla Mensajes: cada mensaje es del chat de un intercambio (IdIntercambio) y lo manda una de las dos partes (IdUsuariosManda).
// fueVisto y FechaRecibido se completan cuando la otra persona abre el chat (BD.MarcarMensajesVistos).
public class Mensajes
{
    // Largo de la columna Texto (varchar(500), ver BaseDatos/Chat.sql).
    public const int LargoMaximoTexto = 500;

    public int IdMensajes { get; set; }
    public string? Texto { get; set; }
    public bool fueVisto { get; set; }
    public DateTime FechaEnviado { get; set; }
    public DateTime? FechaRecibido { get; set; }
    public int IdUsuariosManda { get; set; }
    public int IdIntercambio { get; set; }
}
