namespace Swappit.Models;
public class Calificaciones
{
    public const int MinPuntaje = 1;
    public const int MaxPuntaje = 5;
    public const int MaxComentario = 300;

    public int Id { get; set; }
    public int IdIntercambio { get; set; }
    public int IdUsuarioCalifica { get; set; }
    public int IdUsuarioCalificado { get; set; }
    public int Puntaje { get; set; }
    public string? Comentario { get; set; }
    public DateTime Fecha { get; set; }
}
