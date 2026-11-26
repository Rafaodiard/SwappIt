namespace Swappit.Models.ViewModels;

public class DetalleIntercambioViewModel
{
    public IntercambioViewModel Intercambio { get; set; } = null!;
    public string? FotoOtro { get; set; }
    public string NombresMios { get; set; } = "";
    public string NombresSuyos { get; set; } = "";
    public string TuMios { get; set; } = "";

    public bool PorResponder { get; set; }
    public bool ArticuloComprometido { get; set; }
    public bool ConfirmarAceptar { get; set; }
    public bool AceptarDeshabilitado { get; set; }
    public string AvisoRechazos { get; set; } = "";
    public string AvisoNotificados { get; set; } = "";

    public bool PuedeCambiar { get; set; }
    public bool TengoPorResponder { get; set; }
    public bool HayPendientes { get; set; }
    public int UltimoCambio { get; set; }
    public bool ConCambios { get; set; }
    public PanelIntercambioViewModel PanelMio { get; set; } = null!;
    public PanelIntercambioViewModel PanelSuyo { get; set; } = null!;

    public string PropuestoPor { get; set; } = "";
    public string TextoRechazo { get; set; } = "";
    public bool EsPendiente { get; set; }
    public bool EsAceptado { get; set; }
    public bool Rechazado { get; set; }
    public bool Cancelado { get; set; }
    public bool Realizado { get; set; }
    public bool AceptadoOMas { get; set; }
    public bool PuedeCancelar { get; set; }

    public bool RealizadoPorMi { get; set; }
    public bool RealizadoPorOtro { get; set; }
    public string TextoConfirmacion { get; set; } = "";
    public CalificacionViewModel? MiCalificacion { get; set; }
    public CalificacionViewModel? SuCalificacion { get; set; }
    public bool PuedeCalificar { get; set; }
    public int MaxComentario { get; set; }

    public string TituloCaja { get; set; } = "";
    public List<CambioPorResponderViewModel> CambiosPorResponder { get; set; } = new List<CambioPorResponderViewModel>();
    public List<EventoCambioViewModel> Historial { get; set; } = new List<EventoCambioViewModel>();

    public bool MostrarAgregar { get; set; }
    public bool MostrarPedir { get; set; }
    public int LugarMio { get; set; }
    public string LeyendaAgregar { get; set; } = "";
    public List<ArticuloCardViewModel> ParaAgregar { get; set; } = new List<ArticuloCardViewModel>();
    public List<ArticuloCardViewModel> ParaPedir { get; set; } = new List<ArticuloCardViewModel>();
}

public class PanelIntercambioViewModel
{
    public string Etiqueta { get; set; } = "";
    public string DeQuien { get; set; } = "";
    public string CantidadTexto { get; set; } = "";
    public bool EsMio { get; set; }
    public bool Simple { get; set; }
    public ArticuloCardViewModel? Unico { get; set; }
    public List<FilaPanelViewModel> Filas { get; set; } = new List<FilaPanelViewModel>();
    public bool BotonAgregar { get; set; }
    public string ModalAgregar { get; set; } = "";
    public string TextoAgregar { get; set; } = "";
}

public class FilaPanelViewModel
{
    public int IdArticulo { get; set; }
    public string Nombre { get; set; } = "";
    public string? Imagen { get; set; }
    public string Estado { get; set; } = "";
    public bool Pendiente { get; set; }
    public string? Que { get; set; }
    public string? Etiqueta { get; set; }
    public string? EtiquetaCss { get; set; }
    public int? IdCambioCancelable { get; set; }
    public string? TextoCancelar { get; set; }
    public bool PuedeSacar { get; set; }

    public bool TieneImagen => !string.IsNullOrEmpty(Imagen);
}

public class CambioPorResponderViewModel
{
    public int Id { get; set; }
    public string? Imagen { get; set; }
    public string Articulo { get; set; } = "";
    public string TextoAntes { get; set; } = "";
    public string TextoDespues { get; set; } = "";
    public string Ayuda { get; set; } = "";
    public string BotonAceptar { get; set; } = "";

    public bool TieneImagen => !string.IsNullOrEmpty(Imagen);
}

public class EventoCambioViewModel
{
    public DateTime Fecha { get; set; }
    public int Orden { get; set; }
    public string Quien { get; set; } = "";
    public string Texto { get; set; } = "";

    public string Cuando => Fechas.DiaYHora(Fecha);
}

public class FiltroEstadoViewModel
{
    public string? Nombre { get; set; }
    public string Texto { get; set; } = "";
    public int Cantidad { get; set; }
    public bool Elegido { get; set; }
}
