namespace Swappit.Models.ViewModels;

// Resumen del chat de un intercambio para la lista de conversaciones (Views/Chat/Index.cshtml):
// el último mensaje y cuántos mensajes de la otra persona no vio el usuario logueado.
// Sale de Mensajes (BD.GetResumenesChat). Los datos del intercambio y de la otra persona están en IntercambioViewModel.
public class ConversacionViewModel
{
    public int IdIntercambio { get; set; }
    public string? UltimoTexto { get; set; }
    public DateTime UltimaFecha { get; set; }
    // true si el último mensaje lo mandó el usuario logueado (se muestra "Vos: ...").
    public bool UltimoEsMio { get; set; }
    public int NoLeidos { get; set; }
}
