using Swappit.Models.ViewModels;

namespace Swappit.Models;

public static class Notificaciones
{
    public static List<NotificacionViewModel> Filtrar(List<NotificacionViewModel> notificaciones, bool leidas)
    {
        List<NotificacionViewModel> elegidas = new List<NotificacionViewModel>();
        foreach (NotificacionViewModel n in notificaciones)
        {
            if (n.Leida == leidas)
            {
                Preparar(n);
                elegidas.Add(n);
            }
        }
        return elegidas;
    }

    private static void Preparar(NotificacionViewModel n)
    {
        n.EsRechazo = n.Tipo == TipoNotificaciones.PropuestaRechazada || n.Tipo == TipoNotificaciones.IntercambioCancelado
            || n.Tipo == TipoNotificaciones.CambioRechazado;
        n.Icono = Icono(n.Tipo);
        n.Accion = Accion(n.Tipo);
        n.Hace = Fechas.Hace(n.Fecha);
        n.FechaHtml = Fechas.ParaHtml(n.Fecha);
        n.MuestraOtro = true;

        string sumarOSacar = n.CambioTipo == TipoCambios.Sacar ? "que saques" : "sumar";
        switch (n.Tipo)
        {
            case TipoNotificaciones.PropuestaRecibida:
                Texto(n, " te propuso un intercambio por tu ", n.ArticuloNombre, ".");
                break;
            case TipoNotificaciones.PropuestaAceptada:
                Texto(n, " aceptó tu propuesta por su ", n.ArticuloNombre, ".");
                break;
            case TipoNotificaciones.PropuestaRechazada:
                Texto(n, " rechazó tu propuesta por su ", n.ArticuloNombre, ".");
                break;
            case TipoNotificaciones.MensajeNuevo:
                Texto(n, " te mandó un mensaje por el intercambio de ", n.ArticuloNombre, ".");
                break;
            case TipoNotificaciones.IntercambioCancelado:
                Texto(n, " canceló el intercambio de ", n.ArticuloNombre, ".");
                break;
            case TipoNotificaciones.ArticuloAgregado:
                Texto(n, " agregó ", n.CambioArticulos, " al intercambio.");
                break;
            case TipoNotificaciones.PedidoArticulo:
                Texto(n, " te pidió tu ", n.CambioArticulos, ".");
                break;
            case TipoNotificaciones.PedidoSacar:
                Texto(n, " quiere sacar su ", n.CambioArticulos, " del intercambio.");
                break;
            case TipoNotificaciones.CambioAceptado:
                Texto(n, $" aceptó {sumarOSacar} ", n.CambioArticulos, ".");
                break;
            case TipoNotificaciones.CambioRechazado:
                Texto(n, $" no aceptó {sumarOSacar} ", n.CambioArticulos, ".");
                break;
            default:
                n.MuestraOtro = false;
                Texto(n, n.Tipo, null, "");
                break;
        }
    }

    private static void Texto(NotificacionViewModel n, string medio, string? destacado, string final)
    {
        n.TextoMedio = medio;
        n.TextoDestacado = destacado;
        n.TextoFinal = final;
    }

    private static string Icono(string tipo)
    {
        switch (tipo)
        {
            case TipoNotificaciones.PropuestaRecibida:
                return "bi-arrow-left-right";
            case TipoNotificaciones.PropuestaAceptada:
            case TipoNotificaciones.CambioAceptado:
                return "bi-check-lg";
            case TipoNotificaciones.PropuestaRechazada:
            case TipoNotificaciones.CambioRechazado:
                return "bi-x-lg";
            case TipoNotificaciones.MensajeNuevo:
                return "bi-chat-dots";
            case TipoNotificaciones.IntercambioCancelado:
                return "bi-x-circle";
            case TipoNotificaciones.ArticuloAgregado:
                return "bi-plus-circle";
            case TipoNotificaciones.PedidoArticulo:
                return "bi-question-circle";
            case TipoNotificaciones.PedidoSacar:
                return "bi-dash-circle";
            default:
                return "bi-bell";
        }
    }

    private static string Accion(string tipo)
    {
        switch (tipo)
        {
            case TipoNotificaciones.MensajeNuevo:
                return "Ver chat";
            case TipoNotificaciones.PedidoArticulo:
            case TipoNotificaciones.PedidoSacar:
                return "Responder";
            case TipoNotificaciones.PropuestaAceptada:
            case TipoNotificaciones.IntercambioCancelado:
            case TipoNotificaciones.ArticuloAgregado:
            case TipoNotificaciones.CambioAceptado:
            case TipoNotificaciones.CambioRechazado:
                return "Ver intercambio";
            default:
                return "Ver propuesta";
        }
    }
}
