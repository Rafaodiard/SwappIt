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

    public bool PorResponder => EsRecibido && Estado == EstadosIntercambios.Pendiente;
    public string EstadoCss => Estado.ToLowerInvariant();
    public string FechaTexto => Fecha.ToString("dd/MM/yyyy");
    public string FechaCorta => Fecha.ToString("dd/MM");
    public string OtroIniciales => SesionUsuario.Iniciales(OtroNombre, OtroApellido);
    public string OtroUbicacion => Listas.UnirConComas(OtroBarrio, OtroProvincia);
    public string OtroNombreVisible => OtroNombre ?? OtroUsuario ?? "";
    public string OtroUsuarioYUbicacion => OtroUbicacion != "" ? $"@{OtroUsuario} · {OtroUbicacion}" : $"@{OtroUsuario}";

    private static string Resumen(string nombre, int cantidad) =>
        cantidad > 1 ? $"{nombre} y {cantidad - 1} más" : nombre;
}
