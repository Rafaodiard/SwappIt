namespace Swappit.Models;
// Cuántas veces se vio y cuántos favoritos tiene un artículo en los últimos días (BD.GetPopularidad).
// RecomendacionesController lo usa para "Más populares" y como una parte chica del puntaje "Para vos".
public class PopularidadArticulo
{
    public int IdArticulo { get; set; }
    public int Vistas { get; set; }
    public int Favoritos { get; set; }
}
