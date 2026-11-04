namespace Swappit.Models;

// Lo que necesita el mail de una notificación (ver BD.GetDatosMailNotificacion y Services/EmailService).
// "Mi" y "Su" son desde el punto de vista de quien recibe el mail.
public class DatosMailNotificacion
{
    // Destinatario (Usuarios.Mail y Usuarios.Nombre).
    public string? Mail { get; set; }
    public string? Nombre { get; set; }

    // La otra persona del intercambio.
    public string? OtroNombre { get; set; }

    // El artículo del destinatario y el de la otra persona en ese intercambio.
    public string? MiArticulo { get; set; }
    public string? SuArticulo { get; set; }
}
