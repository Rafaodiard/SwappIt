namespace Swappit.Models;
// Tabla TipoInteracciones (se carga con BaseDatos/Recomendaciones.sql). Interacciones.IdTipoInteraccion apunta acá.
// Cada fila de Interacciones es algo que hizo un usuario en la página y que usa el algoritmo de recomendaciones
// (ver Controllers/RecomendacionesController.cs).
public class TipoInteracciones
{
    // Nombres de la tabla (BD.cs busca el Id por nombre para no depender de los ids).
    // Vista: abrió el detalle de un artículo (IdArticulo) y se quedó Segundos.
    // Búsqueda: escribió Texto en el buscador.
    // Filtro por categoría: marcó la categoría IdCategoria en los filtros de Explorar.
    // Favorito: guardó el artículo IdArticulo en favoritos (la fila existe mientras siga siendo favorito).
    public const string Vista = "Vista";
    public const string Busqueda = "Búsqueda";
    public const string FiltroCategoria = "Filtro por categoría";
    public const string Favorito = "Favorito";

    public int Id { get; set; }
    public string? Nombre { get; set; }
}
