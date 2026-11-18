using System.Net;
using System.Net.Mail;
using System.Text;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using Swappit.Models;

namespace Swappit.Services;

public class EmailService
{
    private const string FromPrueba = "notificaciones@swappit.local";

    private const string AzulPetroleo = "#0d596a";
    private const string Beige = "#ece6d8";
    private const string Bordo = "#6e2c3a";
    private const string FuenteTexto = "'Century Gothic', Questrial, Arial, sans-serif";
    private const string FuenteTitulo = "Forum, Georgia, 'Times New Roman', serif";

    private readonly SmtpSettings _smtp;
    private readonly ILogger<EmailService> _logger;
    private readonly string? _carpetaPrueba;
    private int _avisoSinConfiguracion;

    public EmailService(IOptions<SmtpSettings> smtp, ILogger<EmailService> logger, IWebHostEnvironment env)
    {
        _smtp = smtp.Value;
        _logger = logger;
        if (_smtp.GuardaEnCarpeta)
        {
            _carpetaPrueba = Path.GetFullPath(Path.Combine(env.ContentRootPath, _smtp.CarpetaPrueba!));
        }
    }

    public void EnviarNotificaciones(IReadOnlyCollection<NotificacionCreada> creadas, IUrlHelper url)
    {
        if (creadas.Count == 0)
        {
            return;
        }
        if (!_smtp.EstaConfigurado && _carpetaPrueba == null)
        {
            if (Interlocked.Exchange(ref _avisoSinConfiguracion, 1) == 0)
            {
                _logger.LogWarning("No se mandan mails de notificaciones: falta configurar Smtp:Host y Smtp:From (ver appsettings.Development.json).");
            }
            return;
        }
        if (!_smtp.EstaConfigurado && Interlocked.Exchange(ref _avisoSinConfiguracion, 1) == 0)
        {
            _logger.LogWarning("Sin SMTP configurado: los mails NO salen, solo se guardan como .eml en {Carpeta}", _carpetaPrueba);
        }

        string scheme = url.ActionContext.HttpContext.Request.Scheme;
        var conLink = new List<(NotificacionCreada Notificacion, string? Link)>();
        foreach (NotificacionCreada n in creadas)
        {
            string? link = n.Tipo == TipoNotificaciones.MensajeNuevo
                ? url.Action("Index", "Chat", new { id = n.IdIntercambio }, scheme)
                : url.Action("Detalle", "Intercambio", new { id = n.IdIntercambio }, scheme);
            conLink.Add((n, link));
        }

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
            DatosMailNotificacion? datos = NotificacionesBD.GetDatosMailNotificacion(notificacion.IdUsuario, notificacion.IdIntercambio, notificacion.IdCambio);
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
            _logger.LogError(ex, "No se pudo mandar el mail de \"{Tipo}\" al usuario {IdUsuario} (intercambio {IdIntercambio})",
                notificacion.Tipo, notificacion.IdUsuario, notificacion.IdIntercambio);
        }
    }

    private async Task EnviarAsync(NotificacionCreada notificacion, DatosMailNotificacion datos, string? link)
    {
        if (_carpetaPrueba != null)
        {
            try
            {
                Directory.CreateDirectory(_carpetaPrueba);
                using MailMessage copia = CrearMail(notificacion, datos, link);
                using SmtpClient aCarpeta = new SmtpClient
                {
                    DeliveryMethod = SmtpDeliveryMethod.SpecifiedPickupDirectory,
                    PickupDirectoryLocation = _carpetaPrueba
                };
                await aCarpeta.SendMailAsync(copia);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "No se pudo guardar la copia del mail en {Carpeta}", _carpetaPrueba);
            }
        }

        if (!_smtp.EstaConfigurado)
        {
            return;
        }

        using MailMessage mail = CrearMail(notificacion, datos, link);
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

    private MailMessage CrearMail(NotificacionCreada notificacion, DatosMailNotificacion datos, string? link)
    {
        (string asunto, string titulo, string texto, string boton) = Textos(notificacion.Tipo, datos);
        string saludo = string.IsNullOrWhiteSpace(datos.Nombre) ? "Hola," : $"Hola {datos.Nombre},";

        MailMessage mail = new MailMessage
        {
            From = new MailAddress(string.IsNullOrWhiteSpace(_smtp.From) ? FromPrueba : _smtp.From, _smtp.FromName),
            Subject = asunto,
            SubjectEncoding = Encoding.UTF8,
            BodyEncoding = Encoding.UTF8
        };
        mail.To.Add(datos.Mail!);
        mail.AlternateViews.Add(AlternateView.CreateAlternateViewFromString(
            TextoPlano(saludo, texto, boton, link), Encoding.UTF8, "text/plain"));
        mail.AlternateViews.Add(AlternateView.CreateAlternateViewFromString(
            Html(saludo, titulo, texto, boton, link), Encoding.UTF8, "text/html"));
        return mail;
    }

    private static (string Asunto, string Titulo, string Texto, string Boton) Textos(string tipo, DatosMailNotificacion d)
    {
        string otro = string.IsNullOrWhiteSpace(d.OtroNombre) ? "Alguien" : d.OtroNombre;
        string mio = Lista(d.MisArticulos);
        string suyo = Lista(d.SusArticulos);
        string tu = d.MisArticulos.Count > 1 ? "tus" : "tu";
        string cambio = string.IsNullOrWhiteSpace(d.CambioArticulos) ? "un artículo" : d.CambioArticulos;
        bool esSacar = d.CambioTipo == TipoCambios.Sacar;

        return tipo switch
        {
            TipoNotificaciones.PropuestaRecibida => (
                $"{otro} te propuso un intercambio",
                "Tenés una propuesta nueva",
                $"{otro} quiere {tu} {mio} y te ofrece {suyo} a cambio. Mirá la propuesta y decidí si la aceptás.",
                "Ver propuesta"),
            TipoNotificaciones.PropuestaAceptada => (
                $"{otro} aceptó tu propuesta",
                "¡Aceptaron tu propuesta!",
                $"{otro} aceptó cambiar {suyo} por {tu} {mio}. Ahora coordinen por el chat dónde y cuándo hacer el intercambio.",
                "Ver intercambio"),
            TipoNotificaciones.PropuestaRechazada => (
                "Tu propuesta no fue aceptada",
                "Tu propuesta no fue aceptada",
                $"La propuesta de cambiar {tu} {mio} por {suyo} de {otro} fue rechazada. Podés seguir buscando otros artículos en Swappit.",
                "Ver intercambio"),
            TipoNotificaciones.MensajeNuevo => (
                $"{otro} te escribió en Swappit",
                "Tenés mensajes nuevos",
                $"{otro} te escribió sobre el intercambio de {tu} {mio} por {suyo}.",
                "Abrir chat"),
            TipoNotificaciones.IntercambioCancelado => (
                $"{otro} canceló el intercambio",
                "Se canceló un intercambio",
                $"{otro} canceló el intercambio de {tu} {mio} por {suyo}.",
                "Ver intercambio"),
            TipoNotificaciones.ArticuloAgregado => (
                $"{otro} agregó artículos a tu intercambio",
                "Cambió un intercambio",
                $"{otro} sumó {cambio} al intercambio. Ahora recibís {suyo} por {tu} {mio}.",
                "Ver intercambio"),
            TipoNotificaciones.PedidoArticulo => (
                $"{otro} te pidió un artículo",
                "Te pidieron un artículo",
                $"{otro} te pidió tu {cambio} para sumarlo al intercambio. Entrá para aceptarlo o rechazarlo.",
                "Responder"),
            TipoNotificaciones.PedidoSacar => (
                $"{otro} quiere sacar un artículo",
                "Te piden sacar un artículo",
                $"{otro} quiere sacar su {cambio} del intercambio. Entrá para aceptarlo o rechazarlo.",
                "Responder"),
            TipoNotificaciones.CambioAceptado => (
                $"{otro} aceptó tu pedido",
                "Aceptaron tu pedido",
                esSacar ? $"{otro} aceptó que saques {cambio} del intercambio." : $"{otro} aceptó sumar {cambio} al intercambio.",
                "Ver intercambio"),
            TipoNotificaciones.CambioRechazado => (
                $"{otro} no aceptó tu pedido",
                "No aceptaron tu pedido",
                esSacar ? $"{otro} no aceptó que saques {cambio} del intercambio." : $"{otro} no aceptó sumar {cambio} al intercambio.",
                "Ver intercambio"),
            _ => (
                "Tenés una notificación nueva en Swappit",
                "Tenés una notificación nueva",
                "Hay novedades en uno de tus intercambios.",
                "Ver intercambio")
        };
    }

    private static string Lista(List<string> nombres)
    {
        List<string> citados = new List<string>();
        foreach (string nombre in nombres.Count > 0 ? nombres : new List<string> { "artículo" })
        {
            citados.Add($"«{nombre}»");
        }
        return Listas.UnirNombres(citados);
    }

    private static string TextoPlano(string saludo, string texto, string boton, string? link)
    {
        string enlace = string.IsNullOrEmpty(link) ? "" : $"\r\n\r\n{boton}: {link}";
        return $"{saludo}\r\n\r\n{texto}{enlace}\r\n\r\n—\r\nSwappit · Intercambiá. Conectá. Reutilizá.";
    }

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
