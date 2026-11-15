namespace Swappit.Models.ViewModels;

public class CambioIntercambioViewModel
{
    public int Id { get; set; }
    public int IdArticulo { get; set; }
    public string ArticuloNombre { get; set; } = "";
    public string? ArticuloImagen { get; set; }
    public string ArticuloEstado { get; set; } = "";
    public int IdDuenoArticulo { get; set; }
    public int IdUsuario { get; set; }
    public string? UsuarioNombre { get; set; }
    public string Tipo { get; set; } = "";
    public string Estado { get; set; } = "";
    public DateTime Fecha { get; set; }
    public DateTime? FechaRespuesta { get; set; }
    public bool Vigente { get; set; }

    public bool EsPendiente => Estado == EstadosIntercambios.Pendiente && Vigente;
}
