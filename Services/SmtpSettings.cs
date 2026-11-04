namespace Swappit.Services;

// Sección "Smtp" de la configuración. La contraseña NO va en appsettings.json:
// se carga con dotnet user-secrets (desarrollo) o con variables de entorno (Smtp__Password).
public class SmtpSettings
{
    public string? Host { get; set; }
    public int Port { get; set; } = 587;
    public bool EnableSsl { get; set; } = true;
    public string? User { get; set; }
    public string? Password { get; set; }
    // Dirección que aparece como remitente (con Gmail tiene que ser la misma cuenta que User).
    public string? From { get; set; }
    public string FromName { get; set; } = "Swappit";

    // Sin Host o sin From no se puede mandar nada.
    public bool EstaConfigurado => !string.IsNullOrWhiteSpace(Host) && !string.IsNullOrWhiteSpace(From);
}
