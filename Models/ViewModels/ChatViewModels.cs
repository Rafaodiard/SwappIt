namespace Swappit.Models.ViewModels;

public class ContactoChatViewModel
{
    public IntercambioViewModel Intercambio { get; set; } = null!;
    public bool Activa { get; set; }
    public string? Cuando { get; set; }
    public string VistaPrevia { get; set; } = "";
    public int NoLeidos { get; set; }
    public string NoLeidosTexto { get; set; } = "";
    public string TextoBusqueda { get; set; } = "";
}

public class MensajeChatViewModel
{
    public string? Dia { get; set; }
    public bool EsMio { get; set; }
    public string? Texto { get; set; }
    public string Hora { get; set; } = "";
    public string FechaHtml { get; set; } = "";
    public bool Visto { get; set; }
}
