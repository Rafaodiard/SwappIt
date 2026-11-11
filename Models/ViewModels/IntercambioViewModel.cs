namespace Swappit.Models.ViewModels;

public class IntercambioViewModel
{
    public int IdIntercambios { get; set; }
    public DateTime Fecha { get; set; }
    public string Estado { get; set; } = "";
    public bool EsRecibido { get; set; }

    public int MiArticuloId { get; set; }
    public string MiArticuloNombre { get; set; } = "";
    public string MiArticuloEstado { get; set; } = "";
    public string? MiArticuloImagen { get; set; }
    public int CantidadMios { get; set; }
    public string MiArticuloResumen => Resumen(MiArticuloNombre, CantidadMios);

    public int SuArticuloId { get; set; }
    public string SuArticuloNombre { get; set; } = "";
    public string SuArticuloEstado { get; set; } = "";
    public string? SuArticuloImagen { get; set; }
    public int CantidadSuyos { get; set; }
    public string SuArticuloResumen => Resumen(SuArticuloNombre, CantidadSuyos);

    public int OtroIdUsuario { get; set; }
    public string? OtroNombre { get; set; }
    public string? OtroApellido { get; set; }
    public string? OtroUsuario { get; set; }
    public string? OtroBarrio { get; set; }
    public string? OtroProvincia { get; set; }

    private static string Resumen(string nombre, int cantidad) =>
        cantidad > 1 ? $"{nombre} y {cantidad - 1} más" : nombre;
}
