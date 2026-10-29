namespace Swappit.Models.ViewModels;

// Un intercambio visto desde el usuario logueado (Mis intercambios, Ver intercambio y el historial de Mi perfil).
// Sale de Intercambios + EstadosIntercambios + los dos Articulos (con su estado y primera foto) + el otro usuario.
// En Intercambios, IdUsuarios1/IdArticulos1 son de quien propone y IdUsuarios2/IdArticulos2 del dueño del artículo pedido:
// BD.GetIntercambios los da vuelta para que "Mi" sea siempre lo del usuario logueado y "Su" lo del otro.
public class IntercambioViewModel
{
    public int IdIntercambios { get; set; }
    public DateTime Fecha { get; set; }
    public string Estado { get; set; } = "";
    // true si la propuesta la recibió el usuario logueado (es el dueño del artículo pedido).
    public bool EsRecibido { get; set; }

    // Artículo que da el usuario logueado.
    public int MiArticuloId { get; set; }
    public string MiArticuloNombre { get; set; } = "";
    public string MiArticuloEstado { get; set; } = "";
    public string? MiArticuloImagen { get; set; }

    // Artículo que recibe el usuario logueado.
    public int SuArticuloId { get; set; }
    public string SuArticuloNombre { get; set; } = "";
    public string SuArticuloEstado { get; set; } = "";
    public string? SuArticuloImagen { get; set; }

    // La otra persona del intercambio.
    public int OtroIdUsuario { get; set; }
    public string? OtroNombre { get; set; }
    public string? OtroApellido { get; set; }
    public string? OtroUsuario { get; set; }
    public string? OtroBarrio { get; set; }
    public string? OtroProvincia { get; set; }
}
