namespace Swappit.Services;

// Sección "Smtp" de la configuración.
// - En desarrollo, la cuenta compartida de Swappit está en appsettings.Development.json (el repo es privado).
//   Si alguien quiere usar otra cuenta, la pisa con dotnet user-secrets, que tiene prioridad.
// - En producción va por variables de entorno (Smtp__Host, Smtp__Password, etc.).
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

    // Carpeta (relativa a la del proyecto) donde se guarda una copia .eml de cada mail, se mande o no por SMTP.
    // Sirve para ver los mails sin contraseña: se abren con doble clic en Outlook. Vacía = no se guardan.
    public string? CarpetaPrueba { get; set; }

    // Sin Host o sin From no se puede mandar por SMTP.
    public bool EstaConfigurado => !string.IsNullOrWhiteSpace(Host) && !string.IsNullOrWhiteSpace(From);

    public bool GuardaEnCarpeta => !string.IsNullOrWhiteSpace(CarpetaPrueba);
}
