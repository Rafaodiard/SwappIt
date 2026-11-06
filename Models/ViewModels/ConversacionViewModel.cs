namespace Swappit.Models.ViewModels;

public class ConversacionViewModel
{
    public int IdIntercambio { get; set; }
    public string? UltimoTexto { get; set; }
    public DateTime UltimaFecha { get; set; }
    public bool UltimoEsMio { get; set; }
    public int NoLeidos { get; set; }
}
