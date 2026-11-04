using System.Net;
using System.Net.Mail;
using System.Text;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using Swappit.Models;

namespace Swappit.Services;

// Manda por mail las notificaciones nuevas (Propuesta recibida/aceptada/rechazada, Mensaje nuevo, Intercambio cancelado).
// Los controllers lo llaman DESPUÉS de que BD confirmó la transacción, con las NotificacionCreada que devolvió BD.
// El envío corre en segundo plano: no demora la respuesta y, si falla, solo se loguea (la notificación ya está guardada).
// Sin configuración SMTP (sección "Smtp") no manda nada y avisa una vez en el log.
public class EmailService
{
    // Colores de la identidad de Swappit.
    private const string AzulPetroleo = "#0d596a";
    private const string Beige = "#ece6d8";
    private const string Bordo = "#6e2c3a";
    private const string FuenteTexto = "'Century Gothic', Questrial, Arial, sans-serif";
    private const string FuenteTitulo = "Forum, Georgia, 'Times New Roman', serif";

    private readonly SmtpSettings _smtp;
    private readonly ILogger<EmailService> _logger;
    private int _avisoSinConfiguracion;

    public EmailService(IOptions<SmtpSettings> smtp, ILogger<EmailService> logger)
    {
        _smtp = smtp.Value;
        _logger = logger;
    }

    // url: el Url del controller; los links se arman acá, durante el request, con el esquema y host del pedido.
    public void EnviarNotificaciones(IReadOnlyCollection<NotificacionCreada> creadas, IUrlHelper url)
    {
        if (creadas.Count == 0)
        {
            return;
        }
        if (!_smtp.EstaConfigurado)
        {
            if (Interlocked.Exchange(ref _avisoSinConfiguracion, 1) == 0)
            {
                _logger.LogWarning("No se mandan mails de notificaciones: falta configurar Smtp:Host y Smtp:From (ver user-secrets).");
            }
            return;
        }

        string scheme = url.ActionContext.HttpContext.Request.Scheme;
        // "Mensaje nuevo" lleva al chat; las demás, al intercambio (igual que NotificacionesController.Ver).
        var conLink = creadas.Select(n => (Notificacion: n, Link: n.Tipo == TipoNotificaciones.MensajeNuevo
            ? url.Action("Index", "Chat", new { id = n.IdIntercambio }, scheme)
            : url.Action("Detalle", "Intercambio", new { id = n.IdIntercambio }, scheme))).ToList();

        // En segundo plano: el request no espera al servidor SMTP. Cada error se loguea adentro.
        _ = Task.Run(async () =>
        {
            foreach (var (notificacion, link) in conLink)
            {
                await EnviarAsync(notificacion, link);
            }
        });
    }

    private async Task EnviarAsync(NotificacionCreada notificacion, string? link)
    {
        try
        {
            DatosMailNotificacion? datos = BD.GetDatosMailNotificacion(notificacion.IdUsuario, notificacion.IdIntercambio);
            if (datos == null || string.IsNullOrWhiteSpace(datos.Mail))
            {
                _logger.LogWarning("El usuario {IdUsuario} no tiene mail: no se avisa la notificación del intercambio {IdIntercambio}",
                    notificacion.IdUsuario, notificacion.IdIntercambio);
                return;
            }

            await EnviarAsync(notificacion, datos, link);
        }
        catch (Exception ex)
        {
            // Un mail caído no rompe nada: la notificación ya se ve en la campana.
            _logger.LogError(ex, "No se pudo mandar el mail de \"{Tipo}\" al usuario {IdUsuario} (intercambio {IdIntercambio})",
                notificacion.Tipo, notificacion.IdUsuario, notificacion.IdIntercambio);
        }
    }

    // Arma el mail y lo manda por SMTP. Separado de la lectura de la base para que quede más claro.
    private async Task EnviarAsync(NotificacionCreada notificacion, DatosMailNotificacion datos, string? link)
    {
        (string asunto, string titulo, string texto, string boton) = Textos(notificacion.Tipo, datos);
        string saludo = string.IsNullOrWhiteSpace(datos.Nombre) ? "Hola," : $"Hola {datos.Nombre},";

        using MailMessage mail = new MailMessage
        {
            From = new MailAddress(_smtp.From!, _smtp.FromName),
            Subject = asunto,
            SubjectEncoding = Encoding.UTF8,
            BodyEncoding = Encoding.UTF8
        };
        mail.To.Add(datos.Mail!);
        // Texto plano para los clientes que no muestran HTML, y la versión HTML.
        mail.AlternateViews.Add(AlternateView.CreateAlternateViewFromString(
            TextoPlano(saludo, texto, boton, link), Encoding.UTF8, "text/plain"));
        mail.AlternateViews.Add(AlternateView.CreateAlternateViewFromString(
            Html(saludo, titulo, texto, boton, link), Encoding.UTF8, "text/html"));

        using SmtpClient cliente = new SmtpClient(_smtp.Host, _smtp.Port)
        {
            EnableSsl = _smtp.EnableSsl,
            DeliveryMethod = SmtpDeliveryMethod.Network,
            Timeout = 15000
        };
        if (!string.IsNullOrWhiteSpace(_smtp.User))
        {
            cliente.Credentials = new NetworkCredential(_smtp.User, _smtp.Password);
        }

        await cliente.SendMailAsync(mail);
    }

    // Textos sin escapar; Html() los escapa.
    private static (string Asunto, string Titulo, string Texto, string Boton) Textos(string tipo, DatosMailNotificacion d)
    {
        string otro = string.IsNullOrWhiteSpace(d.OtroNombre) ? "Alguien" : d.OtroNombre;
        string mio = d.MiArticulo ?? "tu artículo";
        string suyo = d.SuArticulo ?? "su artículo";

        return tipo switch
        {
            TipoNotificaciones.PropuestaRecibida => (
                $"{otro} te propuso un intercambio",
                "Tenés una propuesta nueva",
                $"{otro} quiere tu «{mio}» y te ofrece «{suyo}» a cambio. Mirá la propuesta y decidí si la aceptás.",
                "Ver propuesta"),
            TipoNotificaciones.PropuestaAceptada => (
                $"{otro} aceptó tu propuesta",
                "¡Aceptaron tu propuesta!",
                $"{otro} aceptó cambiar «{suyo}» por tu «{mio}». Ahora coordinen por el chat dónde y cuándo hacer el intercambio.",
                "Ver intercambio"),
            TipoNotificaciones.PropuestaRechazada => (
                "Tu propuesta no fue aceptada",
                "Tu propuesta no fue aceptada",
                $"La propuesta de cambiar tu «{mio}» por «{suyo}» de {otro} fue rechazada. Podés seguir buscando otros artículos en Swappit.",
                "Ver intercambio"),
            TipoNotificaciones.MensajeNuevo => (
                $"{otro} te escribió en Swappit",
                "Tenés mensajes nuevos",
                $"{otro} te escribió sobre el intercambio de tu «{mio}» por «{suyo}».",
                "Abrir chat"),
            TipoNotificaciones.IntercambioCancelado => (
                $"{otro} canceló el intercambio",
                "Se canceló un intercambio",
                $"{otro} canceló el intercambio de tu «{mio}» por «{suyo}».",
                "Ver intercambio"),
            _ => (
                "Tenés una notificación nueva en Swappit",
                "Tenés una notificación nueva",
                "Hay novedades en uno de tus intercambios.",
                "Ver intercambio")
        };
    }

    private static string TextoPlano(string saludo, string texto, string boton, string? link)
    {
        string enlace = string.IsNullOrEmpty(link) ? "" : $"\r\n\r\n{boton}: {link}";
        return $"{saludo}\r\n\r\n{texto}{enlace}\r\n\r\n—\r\nSwappit · Intercambiá. Conectá. Reutilizá.";
    }

    // HTML simple con tablas y estilos en línea (lo que mejor soportan los clientes de mail).
    private static string Html(string saludo, string titulo, string texto, string boton, string? link)
    {
        string e(string s) => WebUtility.HtmlEncode(s);

        string botonHtml = string.IsNullOrEmpty(link) ? "" : $@"
            <tr><td style=""padding:8px 32px 32px;"">
              <a href=""{e(link)}"" style=""display:inline-block;background:{AzulPetroleo};color:#ffffff;text-decoration:none;
                 font-family:{FuenteTexto};font-size:15px;font-weight:bold;padding:12px 28px;border-radius:999px;"">{e(boton)}</a>
            </td></tr>";

        return $@"<!DOCTYPE html>
<html lang=""es"">
<head><meta charset=""utf-8""><meta name=""viewport"" content=""width=device-width, initial-scale=1""><title>{e(titulo)}</title></head>
<body style=""margin:0;padding:0;background:{Beige};"">
  <table role=""presentation"" width=""100%"" cellpadding=""0"" cellspacing=""0"" style=""background:{Beige};padding:32px 16px;"">
    <tr><td align=""center"">
      <table role=""presentation"" width=""100%"" cellpadding=""0"" cellspacing=""0"" style=""max-width:560px;background:#ffffff;border-radius:16px;overflow:hidden;"">
        <tr><td style=""background:{AzulPetroleo};padding:20px 32px;"">
          <span style=""font-family:{FuenteTitulo};font-size:26px;color:{Beige};letter-spacing:1px;"">Swappit</span>
        </td></tr>
        <tr><td style=""padding:32px 32px 8px;"">
          <h1 style=""margin:0 0 16px;font-family:{FuenteTitulo};font-weight:normal;font-size:26px;color:{Bordo};"">{e(titulo)}</h1>
          <p style=""margin:0 0 12px;font-family:{FuenteTexto};font-size:15px;line-height:1.6;color:#2b2b2b;"">{e(saludo)}</p>
          <p style=""margin:0 0 16px;font-family:{FuenteTexto};font-size:15px;line-height:1.6;color:#2b2b2b;"">{e(texto)}</p>
        </td></tr>{botonHtml}
      </table>
      <p style=""margin:16px 0 0;font-family:{FuenteTexto};font-size:12px;color:{AzulPetroleo};"">
        Intercambiá. Conectá. Reutilizá.<br>Recibís este mail porque tenés una cuenta en Swappit.
      </p>
    </td></tr>
  </table>
</body>
</html>";
    }
}
