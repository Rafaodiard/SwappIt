namespace Swappit.Models.ViewModels;

public class NotificacionViewModel
{
    public int Id { get; set; }
    public string Tipo { get; set; } = "";
    public bool Leida { get; set; }
    public DateTime Fecha { get; set; }
    public int IdIntercambio { get; set; }

    public string? OtroNombre { get; set; }
    public string? ArticuloNombre { get; set; }

    public string? CambioTipo { get; set; }
    public string? CambioArticulos { get; set; }

    public string Icono { get; set; } = "";
    public string Accion { get; set; } = "";
    public bool EsRechazo { get; set; }
    public bool MuestraOtro { get; set; }
    public string TextoMedio { get; set; } = "";
    public string? TextoDestacado { get; set; }
    public string TextoFinal { get; set; } = "";
    public string Hace { get; set; } = "";
    public string FechaHtml { get; set; } = "";

    public bool EsDeChat => Tipo == TipoNotificaciones.MensajeNuevo;
}
