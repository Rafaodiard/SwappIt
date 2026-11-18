namespace Swappit.Models.ViewModels;

public class PlanViewModel
{
    public int Id { get; set; }
    public string Nombre { get; set; } = "";
    public string Etiqueta { get; set; } = "";
    public int PrecioMensual { get; set; }
    public int? MaxArticulos { get; set; }
    public int? MaxIntercambios { get; set; }
    public int Prioridad { get; set; }
    public List<string> Beneficios { get; } = new List<string>();

    public bool EsGratis => PrecioMensual == 0;
    public string Precio => Suscripciones.Precio(PrecioMensual);
    public string Clave => Nombre.ToLowerInvariant();
}
