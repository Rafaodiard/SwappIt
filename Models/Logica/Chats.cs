using Swappit.Models.ViewModels;

namespace Swappit.Models;

public static class Chats
{
    private const int MaxNoLeidosVisibles = 9;

    public static IntercambioViewModel? Abierta(List<IntercambioViewModel> conversaciones, int? idPedido, int idUsuario)
    {
        if (idPedido == null)
        {
            return conversaciones.Count > 0 ? conversaciones[0] : null;
        }
        return IntercambiosBD.GetIntercambio(idPedido.Value, idUsuario);
    }

    public static List<Mensajes> Abrir(int idIntercambio, int idUsuario)
    {
        ChatBD.MarcarMensajesVistos(idIntercambio, idUsuario);
        return ChatBD.GetMensajes(idIntercambio, idUsuario);
    }

    public static List<ContactoChatViewModel> Contactos(List<IntercambioViewModel> conversaciones, int idUsuario, int? idAbierta)
    {
        Dictionary<int, ConversacionViewModel> resumenes = new Dictionary<int, ConversacionViewModel>();
        foreach (ConversacionViewModel r in ChatBD.GetResumenesChat(idUsuario))
        {
            resumenes[r.IdIntercambio] = r;
        }

        List<ContactoChatViewModel> contactos = new List<ContactoChatViewModel>();
        foreach (IntercambioViewModel c in conversaciones)
        {
            resumenes.TryGetValue(c.IdIntercambios, out ConversacionViewModel? resumen);
            bool activa = c.IdIntercambios == idAbierta;
            int noLeidos = resumen == null || activa ? 0 : resumen.NoLeidos;
            contactos.Add(new ContactoChatViewModel
            {
                Intercambio = c,
                Activa = activa,
                Cuando = resumen == null ? null : Fechas.HoraODia(resumen.UltimaFecha),
                VistaPrevia = resumen == null
                    ? $"{c.MiArticuloResumen} ⇄ {c.SuArticuloResumen}"
                    : $"{(resumen.UltimoEsMio ? "Vos: " : "")}{resumen.UltimoTexto}",
                NoLeidos = noLeidos,
                NoLeidosTexto = noLeidos > MaxNoLeidosVisibles ? $"{MaxNoLeidosVisibles}+" : noLeidos.ToString(),
                TextoBusqueda = $"{c.OtroNombre} {c.OtroApellido} {c.OtroUsuario} {c.MiArticuloResumen} {c.SuArticuloResumen}"
            });
        }
        return contactos;
    }

    public static List<MensajeChatViewModel> ParaMostrar(List<Mensajes> mensajes, int idUsuario)
    {
        List<MensajeChatViewModel> lista = new List<MensajeChatViewModel>();
        DateTime? diaAnterior = null;
        foreach (Mensajes m in mensajes)
        {
            string? dia = null;
            if (diaAnterior != m.FechaEnviado.Date)
            {
                diaAnterior = m.FechaEnviado.Date;
                dia = Fechas.Dia(m.FechaEnviado);
            }
            lista.Add(new MensajeChatViewModel
            {
                Dia = dia,
                EsMio = m.IdUsuariosManda == idUsuario,
                Texto = m.Texto,
                Hora = m.FechaEnviado.ToString("HH:mm"),
                FechaHtml = Fechas.ParaHtml(m.FechaEnviado),
                Visto = m.fueVisto
            });
        }
        return lista;
    }

    public static bool PuedeEscribir(IntercambioViewModel? intercambio, List<Mensajes> mensajes)
    {
        if (intercambio == null)
        {
            return false;
        }
        return intercambio.Estado == EstadosIntercambios.Aceptado
            || (intercambio.Estado == EstadosIntercambios.Pendiente && (intercambio.EsRecibido || ElOtroEscribio(mensajes, intercambio.OtroIdUsuario)));
    }

    private static bool ElOtroEscribio(List<Mensajes> mensajes, int idOtro)
    {
        foreach (Mensajes m in mensajes)
        {
            if (m.IdUsuariosManda == idOtro)
            {
                return true;
            }
        }
        return false;
    }

    public static string TextoNoPuedeEscribir(IntercambioViewModel intercambio)
    {
        if (intercambio.Estado == EstadosIntercambios.Pendiente)
        {
            return $"Cuando {intercambio.OtroNombre} te escriba, vas a poder responderle. Si acepta tu propuesta, también vas a poder escribirle vos.";
        }
        return $"Este intercambio está {intercambio.Estado.ToLowerInvariant()}: ya no se pueden mandar mensajes.";
    }

    public static Resultado Enviar(int idIntercambio, int idUsuario, string? texto)
    {
        texto = texto?.Trim();
        if (string.IsNullOrEmpty(texto))
        {
            return new Resultado();
        }
        if (texto.Length > Mensajes.LargoMaximoTexto)
        {
            return Resultado.ConError($"El mensaje puede tener hasta {Mensajes.LargoMaximoTexto} caracteres.");
        }

        Resultado resultado = new Resultado();
        if (!ChatBD.EnviarMensaje(idIntercambio, idUsuario, texto, resultado.Notificaciones))
        {
            resultado.Error = "No se pudo mandar el mensaje: este intercambio ya no está en curso.";
        }
        return resultado;
    }
}
