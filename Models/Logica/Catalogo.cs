using Swappit.Models.ViewModels;

namespace Swappit.Models;

public static class Catalogo
{
    public const int MaxOpcionesFiltro = 20;

    public static string? LimpiarBusqueda(string? q)
    {
        return string.IsNullOrWhiteSpace(q) ? null : q.Trim();
    }

    public static List<ArticuloCardViewModel> Buscar(string? busqueda, List<int> categorias, List<int> estados, int? idUsuario, string orden)
    {
        List<ArticuloCardViewModel> articulos = ArticulosBD.GetArticulosCatalogo(busqueda, categorias: categorias, estados: estados,
            excluirUsuario: idUsuario, orden: orden);
        return Recomendaciones.Ordenar(articulos, orden, idUsuario);
    }

    public static List<OpcionFiltroViewModel> FiltroCategorias(string? busqueda, int? idUsuario, List<int> seleccionadas)
    {
        return MarcarSeleccionadas(ArticulosBD.GetFiltroCategorias(busqueda, idUsuario), seleccionadas);
    }

    public static List<OpcionFiltroViewModel> FiltroEstados(string? busqueda, int? idUsuario, List<int> seleccionados)
    {
        return MarcarSeleccionadas(ArticulosBD.GetFiltroEstados(busqueda, idUsuario), seleccionados);
    }

    private static List<OpcionFiltroViewModel> MarcarSeleccionadas(List<OpcionFiltroViewModel> opciones, List<int> seleccionadas)
    {
        foreach (OpcionFiltroViewModel opcion in opciones)
        {
            opcion.Seleccionada = int.TryParse(opcion.Valor, out int valor) && seleccionadas.Contains(valor);
        }
        return opciones;
    }

    public static bool HayFiltros(List<int> categorias, List<int> estados)
    {
        return categorias.Count > 0 || estados.Count > 0;
    }

    public static bool HayQueRegistrarBusqueda(bool logueado, string? busqueda, List<int> categorias)
    {
        return logueado && (busqueda != null || categorias.Count > 0);
    }

    public static string TituloBusqueda(string? busqueda, string orden)
    {
        if (busqueda != null)
        {
            return $"Resultados para “{busqueda}”";
        }
        switch (orden)
        {
            case Recomendaciones.OrdenParaVos:
                return "Elegidos para vos";
            case Recomendaciones.OrdenRecientes:
                return "Recién publicados";
            case Recomendaciones.OrdenAZ:
                return "Todos los artículos";
            default:
                return "Los más buscados";
        }
    }

    public static string TextoSinResultados(string? busqueda, bool hayFiltros)
    {
        return busqueda == null && !hayFiltros ? "Todavía no hay objetos publicados." : "No encontramos objetos con esos filtros.";
    }

    public static string Ubicacion(Articulos articulo, Usuarios dueno)
    {
        if (!string.IsNullOrWhiteSpace(articulo.Ubicacion))
        {
            return articulo.Ubicacion;
        }
        return Listas.UnirConComas(dueno.Barrio, UsuariosBD.GetProvinciaById(dueno.IdProvincias)?.Nombre);
    }

    public static string TextoACambio(Articulos articulo)
    {
        if (articulo.IdCategoriaACambio == null)
        {
            return "Abierto a propuestas";
        }
        return ArticulosBD.GetCategoriaById(articulo.IdCategoriaACambio.Value)?.Nombre ?? "Abierto a propuestas";
    }

    public static List<FotoArticuloViewModel> Fotos(List<string> imagenes)
    {
        List<FotoArticuloViewModel> fotos = new List<FotoArticuloViewModel>();
        for (int i = 0; i < imagenes.Count; i++)
        {
            fotos.Add(new FotoArticuloViewModel
            {
                Ruta = imagenes[i],
                Etiqueta = $"Ver foto {i + 1} de {imagenes.Count}",
                EsPrimera = i == 0
            });
        }
        return fotos;
    }

    public static string? FotoPrincipal(List<string> imagenes)
    {
        return imagenes.Count > 0 ? imagenes[0] : null;
    }

    public static string AltFotoPrincipal(Articulos articulo, List<string> imagenes)
    {
        return imagenes.Count > 0 ? $"Foto de {articulo.Nombre}" : "";
    }

    public static List<ArticuloCardViewModel> ArticulosParaOfrecer(int? idUsuario, Articulos articulo)
    {
        if (idUsuario == null || idUsuario == articulo.IdUsuarios)
        {
            return new List<ArticuloCardViewModel>();
        }
        return ArticulosBD.GetArticulosCatalogo(idUsuario: idUsuario.Value);
    }

    public static int? PropuestaEnCurso(int? idUsuario, Articulos articulo)
    {
        if (idUsuario == null || idUsuario == articulo.IdUsuarios)
        {
            return null;
        }
        return IntercambiosBD.GetIdPropuestaEnCurso(idUsuario.Value, articulo.IdArticulos);
    }

    public static bool PuedeProponer(int? idUsuario, Articulos articulo, int? idPropuestaEnCurso, bool comprometido)
    {
        return idUsuario != null && idUsuario != articulo.IdUsuarios && idPropuestaEnCurso == null && !comprometido;
    }

    public static string LeyendaOfrecer(int cantidadPropios)
    {
        if (cantidadPropios == 1)
        {
            return "Tu artículo";
        }
        return $"Elegí hasta {Math.Min(Intercambios.MaxArticulosOfrecidos, cantidadPropios)} de tus artículos";
    }
}
