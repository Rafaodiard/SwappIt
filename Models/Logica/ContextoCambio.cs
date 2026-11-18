using Swappit.Models.ViewModels;

namespace Swappit.Models;

public record ContextoCambio(int IdUsuario, IntercambioViewModel Intercambio, List<ArticuloCardViewModel> Articulos,
    List<CambioIntercambioViewModel> Pendientes)
{
    public int Confirmados(int dueno)
    {
        int cantidad = 0;
        foreach (ArticuloCardViewModel a in Articulos)
        {
            if (a.IdUsuarios == dueno)
            {
                cantidad++;
            }
        }
        return cantidad;
    }

    public int PendientesDe(int dueno, string tipo)
    {
        int cantidad = 0;
        foreach (CambioIntercambioViewModel c in Pendientes)
        {
            if (c.IdDuenoArticulo == dueno && c.Tipo == tipo)
            {
                cantidad++;
            }
        }
        return cantidad;
    }

    public int Lugar(int dueno) =>
        Math.Max(0, Intercambios.MaxArticulosOfrecidos - Confirmados(dueno) - PendientesDe(dueno, TipoCambios.Pedir));

    public ArticuloCardViewModel? Articulo(int idArticulo)
    {
        foreach (ArticuloCardViewModel a in Articulos)
        {
            if (a.IdArticulos == idArticulo)
            {
                return a;
            }
        }
        return null;
    }

    public CambioIntercambioViewModel? PendienteDeArticulo(int idArticulo)
    {
        foreach (CambioIntercambioViewModel c in Pendientes)
        {
            if (c.IdArticulo == idArticulo)
            {
                return c;
            }
        }
        return null;
    }

    public CambioIntercambioViewModel? Pendiente(int idCambio)
    {
        foreach (CambioIntercambioViewModel c in Pendientes)
        {
            if (c.Id == idCambio)
            {
                return c;
            }
        }
        return null;
    }

    public bool EnJuego(int idArticulo) => Articulo(idArticulo) != null || PendienteDeArticulo(idArticulo) != null;
}
