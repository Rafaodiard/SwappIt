namespace Swappit.Models;
public class ResumenReputacion
{
    public decimal? Promedio { get; set; }
    public int Cantidad { get; set; }

    public bool TieneCalificaciones => Cantidad > 0 && Promedio != null;
    public double Estrellas => (double)(Promedio ?? 0);
    public string PromedioTexto => (Promedio ?? 0).ToString("0.0", new System.Globalization.CultureInfo("es-AR"));
    public string CantidadTexto => Listas.Contar(Cantidad, "calificación", "calificaciones");
}
