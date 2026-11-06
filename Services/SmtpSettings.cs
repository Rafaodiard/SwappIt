namespace Swappit.Services;

public class SmtpSettings
{
    public string? Host { get; set; }
    public int Port { get; set; } = 587;
    public bool EnableSsl { get; set; } = true;
    public string? User { get; set; }
    public string? Password { get; set; }
    public string? From { get; set; }
    public string FromName { get; set; } = "Swappit";

    public string? CarpetaPrueba { get; set; }

    public bool EstaConfigurado => !string.IsNullOrWhiteSpace(Host) && !string.IsNullOrWhiteSpace(From);

    public bool GuardaEnCarpeta => !string.IsNullOrWhiteSpace(CarpetaPrueba);
}
