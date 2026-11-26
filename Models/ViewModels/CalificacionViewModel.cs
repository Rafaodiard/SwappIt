namespace Swappit.Models.ViewModels;

public class CalificacionViewModel
{
    public int Puntaje { get; set; }
    public string? Comentario { get; set; }
    public DateTime Fecha { get; set; }
    public bool EsMia { get; set; }

    public int AutorId { get; set; }
    public string? AutorNombre { get; set; }
    public string? AutorApellido { get; set; }
    public string? AutorUsuario { get; set; }
    public string? AutorFoto { get; set; }

    public bool TieneComentario => !string.IsNullOrWhiteSpace(Comentario);
    public string FechaTexto => Fechas.Dia(Fecha);
    public string FechaHtml => Fechas.ParaHtml(Fecha);
    public string AutorIniciales => SesionUsuario.Iniciales(AutorNombre, AutorApellido);
    public string AutorNombreCompleto => $"{AutorNombre} {AutorApellido}".Trim();
}
