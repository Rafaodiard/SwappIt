namespace Swappit.Models;
// Un dato que dice qué le gusta a un usuario. Lo arma BD.GetSenalesGustos juntando tres fuentes:
// - Interacciones (vistas, búsquedas, filtros por categoría y favoritos),
// - Intercambios (las propuestas que el usuario mandó: el artículo que pidió),
// - Articulos (la categoría que el usuario pide a cambio en lo que publicó).
// Lo usa RecomendacionesController para armar los gustos de cada usuario.
public class SenalGusto
{
    // Tipos que no son filas de TipoInteracciones (salen de otras tablas).
    public const string Propuesta = "Propuesta";
    public const string PideACambio = "Pide a cambio";

    public int IdUsuario { get; set; }
    // Un nombre de TipoInteracciones, Propuesta o PideACambio.
    public string Tipo { get; set; } = "";
    // Categoría a la que suma interés (en vistas y favoritos, la del artículo). Null en las búsquedas.
    public int? IdCategoria { get; set; }
    // Solo en búsquedas: lo que escribió.
    public string? Texto { get; set; }
    // Solo en vistas: cuánto tiempo se quedó en el detalle (null si no se llegó a medir).
    public int? Segundos { get; set; }
    public DateTime Fecha { get; set; }
}
