namespace Swappit.Models;
public class TipoNotificaciones
{
    public const string PropuestaRecibida = "Propuesta recibida";
    public const string PropuestaAceptada = "Propuesta aceptada";
    public const string PropuestaRechazada = "Propuesta rechazada";
    public const string MensajeNuevo = "Mensaje nuevo";
    public const string IntercambioCancelado = "Intercambio cancelado";
    public const string ArticuloAgregado = "Artículo agregado";
    public const string PedidoArticulo = "Pedido de artículo";
    public const string PedidoSacar = "Pedido para sacar";
    public const string CambioAceptado = "Cambio aceptado";
    public const string CambioRechazado = "Cambio rechazado";
    public const string MarcadoRealizado = "Marcado como realizado";
    public const string IntercambioRealizado = "Intercambio realizado";
    public const string CalificacionRecibida = "Calificación recibida";

    public int Id { get; set; }
    public string? Nombre { get; set; }
}
