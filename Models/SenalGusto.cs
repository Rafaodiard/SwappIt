namespace Swappit.Models;
public class SenalGusto
{
    public const string Propuesta = "Propuesta";
    public const string PideACambio = "Pide a cambio";

    public int IdUsuario { get; set; }
    public string Tipo { get; set; } = "";
    public int? IdCategoria { get; set; }
    public string? Texto { get; set; }
    public int? Segundos { get; set; }
    public DateTime Fecha { get; set; }
}
