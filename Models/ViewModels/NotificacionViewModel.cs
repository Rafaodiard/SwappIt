namespace Swappit.Models.ViewModels;

// Una notificación del pop up del header (Views/Notificaciones/_Lista.cshtml).
// Sale de Notificaciones + TipoNotificaciones + el intercambio (la otra persona y el artículo pedido).
public class NotificacionViewModel
{
    public int Id { get; set; }
    // Nombre del tipo (ver TipoNotificaciones).
    public string Tipo { get; set; } = "";
    public bool Leida { get; set; }
    public DateTime Fecha { get; set; }
    public int IdIntercambio { get; set; }

    // La otra persona del intercambio.
    public string? OtroNombre { get; set; }
    // El artículo pedido (IdArticulos2): "tu" artículo si la propuesta la recibió el usuario, "su" artículo si la hizo él.
    public string? ArticuloNombre { get; set; }
}
