using System.Globalization;
using System.Text;
using Microsoft.AspNetCore.Mvc.Rendering;
using Swappit.Models.ViewModels;

namespace Swappit.Models;

public static class Recomendaciones
{

    private const double PuntosFavorito = 5;
    private const double PuntosPropuesta = 4;
    private const double PuntosPideACambio = 4;
    private const double PuntosFiltroCategoria = 2;
    private const double PuntosVista = 1;
    private const int SegundosPorPuntoExtra = 30;
    private const double MaxPuntosPorTiempo = 3;

    private const int DiasDeHistorial = 90;

    private const double PesoGusto = 0.50;
    private const double PesoBusqueda = 0.15;
    private const double PesoInteresDelOtro = 0.25;
    private const double PesoPopularidad = 0.10;
    private const double InteresSiEstaAbierto = 0.5;
    private const double PuntosPorPrioridadPlan = 0.10;

    private const int CadaCuantosUnoParaDescubrir = 5;
    private const double UmbralGusto = 0.2;

    private const int MaxBusquedasRecientes = 10;
    private const int MinutosSinRepetirBusqueda = 30;
    private const int MaxLargoBusqueda = 100;
    private const int MaxCategoriasBusqueda = 20;
    private const int MaxSegundosVista = 3600;

    public const string OrdenParaVos = "paravos";
    public const string OrdenPopulares = "populares";
    public const string OrdenRecientes = "recientes";
    public const string OrdenAZ = "az";

    public const string MotivoInteresMutuo = "Le interesa algo tuyo";
    public const string MotivoDescubrir = "Para descubrir";

    // ---------- PARTE 1 - JUNTAR DATOS ----------

    public static int? RegistrarVista(int idUsuario, int idArticulo)
    {
        Articulos? articulo = ArticulosBD.GetArticuloById(idArticulo);
        if (articulo == null || articulo.IdUsuarios == idUsuario)
        {
            return null;
        }
        return RecomendacionesBD.RegistrarVista(idUsuario, idArticulo);
    }

    public static void GuardarTiempo(int idInteraccion, int idUsuario, int segundos)
    {
        RecomendacionesBD.GuardarSegundosVista(idInteraccion, idUsuario, Math.Clamp(segundos, 0, MaxSegundosVista));
    }

    public static void RegistrarBusqueda(int idUsuario, string? texto, int[]? categorias)
    {
        string? textoLimpio = string.IsNullOrWhiteSpace(texto) ? null : texto.Trim();
        if (textoLimpio != null && textoLimpio.Length > MaxLargoBusqueda)
        {
            textoLimpio = textoLimpio.Substring(0, MaxLargoBusqueda);
        }
        List<int> categoriasLimpias = Listas.IdsValidos(categorias, MaxCategoriasBusqueda);
        RecomendacionesBD.RegistrarBusqueda(idUsuario, textoLimpio, categoriasLimpias, MinutosSinRepetirBusqueda);
    }

    // ---------- PARTE 2 - RECOMENDAR ----------

    public static List<SelectListItem> OpcionesOrden(bool logueado)
    {
        List<SelectListItem> opciones = new List<SelectListItem>();
        if (logueado)
        {
            opciones.Add(new SelectListItem("Para vos", OrdenParaVos));
        }
        opciones.Add(new SelectListItem("Más populares", OrdenPopulares));
        opciones.Add(new SelectListItem("Más recientes", OrdenRecientes));
        opciones.Add(new SelectListItem("A - Z", OrdenAZ));
        return opciones;
    }

    public static string OrdenValido(string? orden, bool logueado)
    {
        foreach (SelectListItem opcion in OpcionesOrden(logueado))
        {
            if (opcion.Value == orden)
            {
                return orden!;
            }
        }
        return logueado ? OrdenParaVos : OrdenPopulares;
    }

    public static List<ArticuloCardViewModel> Ordenar(List<ArticuloCardViewModel> articulos, string orden, int? idUsuario)
    {
        if (orden == OrdenParaVos && idUsuario != null)
        {
            List<ArticuloPuntuado> puntuados = Puntuar(idUsuario.Value, articulos);
            return Mezclar(idUsuario.Value, puntuados);
        }
        return articulos;
    }

    public static List<ArticuloCardViewModel> Destacados(int? idUsuario, int cantidad)
    {
        if (idUsuario == null)
        {
            return ArticulosBD.GetArticulosCatalogo(cantidad: cantidad, orden: OrdenPopulares);
        }

        List<ArticuloCardViewModel> candidatos = ArticulosBD.GetArticulosCatalogo(excluirUsuario: idUsuario);
        List<ArticuloPuntuado> puntuados = Puntuar(idUsuario.Value, candidatos);

        List<ArticuloPuntuado> conInteresMutuo = new List<ArticuloPuntuado>();
        foreach (ArticuloPuntuado p in puntuados)
        {
            if (p.InteresDelOtro > 0)
            {
                conInteresMutuo.Add(p);
            }
        }
        if (conInteresMutuo.Count >= cantidad)
        {
            puntuados = conInteresMutuo;
        }

        List<ArticuloCardViewModel> mezclados = Mezclar(idUsuario.Value, puntuados);
        return mezclados.Count > cantidad ? mezclados.GetRange(0, cantidad) : mezclados;
    }

    // ---------- PASO 1: GUSTOS ----------

    private static Dictionary<int, double> ArmarGustos(List<SenalGusto> senales)
    {
        Dictionary<int, double> puntos = new Dictionary<int, double>();
        foreach (SenalGusto senal in senales)
        {
            if (senal.IdCategoria == null)
            {
                continue;
            }

            int categoria = senal.IdCategoria.Value;
            double valor = PuntosSegunTipo(senal) * PesoSegunAntiguedad(senal.Fecha);
            puntos[categoria] = puntos.GetValueOrDefault(categoria) + valor;
        }

        if (puntos.Count == 0)
        {
            return puntos;
        }
        double maximo = double.MinValue;
        foreach (double valor in puntos.Values)
        {
            maximo = Math.Max(maximo, valor);
        }

        Dictionary<int, double> normalizados = new Dictionary<int, double>();
        foreach (KeyValuePair<int, double> p in puntos)
        {
            normalizados[p.Key] = p.Value / maximo;
        }
        return normalizados;
    }

    private static double PuntosSegunTipo(SenalGusto senal)
    {
        switch (senal.Tipo)
        {
            case TipoInteracciones.Favorito:
                return PuntosFavorito;
            case SenalGusto.Propuesta:
                return PuntosPropuesta;
            case SenalGusto.PideACambio:
                return PuntosPideACambio;
            case TipoInteracciones.FiltroCategoria:
                return PuntosFiltroCategoria;
            case TipoInteracciones.Vista:
                double puntosPorTiempo = Math.Min((senal.Segundos ?? 0) / SegundosPorPuntoExtra, MaxPuntosPorTiempo);
                return PuntosVista + puntosPorTiempo;
            default:
                return 0;
        }
    }

    private static double PesoSegunAntiguedad(DateTime fecha)
    {
        double dias = (DateTime.Now - fecha).TotalDays;
        if (dias <= 7)
        {
            return 1;
        }
        if (dias <= 30)
        {
            return 0.5;
        }
        return 0.25;
    }

    private static List<string> PalabrasBuscadas(List<SenalGusto> senales)
    {
        List<SenalGusto> busquedas = new List<SenalGusto>();
        foreach (SenalGusto s in senales)
        {
            if (s.Tipo == TipoInteracciones.Busqueda && !string.IsNullOrWhiteSpace(s.Texto))
            {
                busquedas.Add(s);
            }
        }
        busquedas.Sort((a, b) => b.Fecha.CompareTo(a.Fecha));
        if (busquedas.Count > MaxBusquedasRecientes)
        {
            busquedas = busquedas.GetRange(0, MaxBusquedasRecientes);
        }

        List<string> palabras = new List<string>();
        foreach (SenalGusto s in busquedas)
        {
            foreach (string palabra in s.Texto!.Split(' ', StringSplitOptions.RemoveEmptyEntries))
            {
                string normalizada = Normalizar(palabra);
                if (normalizada.Length >= 3 && !palabras.Contains(normalizada))
                {
                    palabras.Add(normalizada);
                }
            }
        }
        return palabras;
    }

    // ---------- PASO 2: PUNTAJE DE CADA ARTÍCULO ----------

    private class ArticuloPuntuado
    {
        public ArticuloCardViewModel Articulo { get; set; } = null!;
        public double Gusto { get; set; }
        public bool CoincideBusqueda { get; set; }
        public double InteresDelOtro { get; set; }
        public bool PideLoQueTenes { get; set; }
        public double Popularidad { get; set; }
        public double Puntaje { get; set; }
    }

    private static List<ArticuloPuntuado> Puntuar(int idUsuario, List<ArticuloCardViewModel> articulos)
    {
        HashSet<int> usuarios = new HashSet<int>();
        foreach (ArticuloCardViewModel a in articulos)
        {
            usuarios.Add(a.IdUsuarios);
        }
        usuarios.Add(idUsuario);

        Dictionary<int, List<SenalGusto>> senalesPorUsuario = new Dictionary<int, List<SenalGusto>>();
        foreach (int u in usuarios)
        {
            senalesPorUsuario[u] = new List<SenalGusto>();
        }
        foreach (SenalGusto s in RecomendacionesBD.GetSenalesGustos(usuarios, DateTime.Now.AddDays(-DiasDeHistorial)))
        {
            if (senalesPorUsuario.TryGetValue(s.IdUsuario, out List<SenalGusto>? delUsuario))
            {
                delUsuario.Add(s);
            }
        }

        Dictionary<int, Dictionary<int, double>> gustos = new Dictionary<int, Dictionary<int, double>>();
        foreach (int u in usuarios)
        {
            gustos[u] = ArmarGustos(senalesPorUsuario[u]);
        }

        Dictionary<int, double> misGustos = gustos[idUsuario];
        List<string> palabrasBuscadas = PalabrasBuscadas(senalesPorUsuario[idUsuario]);
        HashSet<int> misCategorias = new HashSet<int>(ArticulosBD.GetCategoriasDeUsuario(idUsuario));
        Dictionary<int, double> popularidad = CalcularPopularidad();

        List<ArticuloPuntuado> puntuados = new List<ArticuloPuntuado>();
        foreach (ArticuloCardViewModel articulo in articulos)
        {
            ArticuloPuntuado p = new ArticuloPuntuado { Articulo = articulo };
            p.Gusto = misGustos.GetValueOrDefault(articulo.IdCategorias);
            p.CoincideBusqueda = CoincideConBusqueda(articulo.Nombre, palabrasBuscadas);
            p.InteresDelOtro = InteresDelDueno(articulo, gustos[articulo.IdUsuarios], misCategorias);
            p.PideLoQueTenes = articulo.IdCategoriaACambio != null && misCategorias.Contains(articulo.IdCategoriaACambio.Value);
            p.Popularidad = popularidad.GetValueOrDefault(articulo.IdArticulos);
            p.Puntaje = PesoGusto * p.Gusto
                + PesoBusqueda * (p.CoincideBusqueda ? 1 : 0)
                + PesoInteresDelOtro * p.InteresDelOtro
                + PesoPopularidad * p.Popularidad
                + PuntosPorPrioridadPlan * articulo.PrioridadPlan;
            puntuados.Add(p);
        }
        return puntuados;
    }

    private static double InteresDelDueno(ArticuloCardViewModel articulo, Dictionary<int, double> gustosDelDueno, HashSet<int> misCategorias)
    {
        if (misCategorias.Count == 0)
        {
            return 0;
        }

        if (articulo.IdCategoriaACambio != null && misCategorias.Contains(articulo.IdCategoriaACambio.Value))
        {
            return 1;
        }

        double interes = double.MinValue;
        foreach (int categoria in misCategorias)
        {
            interes = Math.Max(interes, gustosDelDueno.GetValueOrDefault(categoria));
        }

        if (articulo.IdCategoriaACambio == null)
        {
            interes = Math.Max(interes, InteresSiEstaAbierto);
        }
        return interes;
    }

    private static bool CoincideConBusqueda(string nombre, List<string> palabrasBuscadas)
    {
        if (palabrasBuscadas.Count == 0)
        {
            return false;
        }
        string nombreNormalizado = Normalizar(nombre);
        foreach (string palabra in palabrasBuscadas)
        {
            if (nombreNormalizado.Contains(palabra))
            {
                return true;
            }
        }
        return false;
    }

    private static string Normalizar(string texto)
    {
        string descompuesto = texto.Trim().ToLowerInvariant().Normalize(NormalizationForm.FormD);
        StringBuilder sinTildes = new StringBuilder();
        foreach (char letra in descompuesto)
        {
            if (CharUnicodeInfo.GetUnicodeCategory(letra) != UnicodeCategory.NonSpacingMark)
            {
                sinTildes.Append(letra);
            }
        }
        string resultado = sinTildes.ToString();
        if (resultado.Length > 4 && resultado.EndsWith('s'))
        {
            resultado = resultado.Substring(0, resultado.Length - 1);
        }
        return resultado;
    }

    private static Dictionary<int, double> CalcularPopularidad()
    {
        List<PopularidadArticulo> filas = RecomendacionesBD.GetPopularidad();
        double maximo = 0;
        foreach (PopularidadArticulo fila in filas)
        {
            maximo = Math.Max(maximo, fila.Puntos);
        }

        Dictionary<int, double> popularidad = new Dictionary<int, double>();
        if (maximo == 0)
        {
            return popularidad;
        }
        foreach (PopularidadArticulo fila in filas)
        {
            popularidad[fila.IdArticulo] = fila.Puntos / maximo;
        }
        return popularidad;
    }

    // ---------- PASO 3: ORDENAR Y MEZCLAR ALGO PARA DESCUBRIR ----------

    private static List<ArticuloCardViewModel> Mezclar(int idUsuario, List<ArticuloPuntuado> puntuados)
    {
        List<ArticuloPuntuado> porPuntaje = new List<ArticuloPuntuado>(puntuados);
        porPuntaje.Sort(CompararPorPuntaje);

        List<ArticuloPuntuado> deTusGustos = new List<ArticuloPuntuado>();
        List<ArticuloPuntuado> paraDescubrir = new List<ArticuloPuntuado>();
        foreach (ArticuloPuntuado p in porPuntaje)
        {
            if (EsDeTusGustos(p))
            {
                deTusGustos.Add(p);
            }
            else
            {
                paraDescubrir.Add(p);
            }
        }

        if (deTusGustos.Count == 0 || paraDescubrir.Count == 0)
        {
            List<ArticuloCardViewModel> todos = new List<ArticuloCardViewModel>();
            foreach (ArticuloPuntuado p in porPuntaje)
            {
                todos.Add(ConMotivo(p));
            }
            return todos;
        }

        List<ArticuloPuntuado> sorteados = new List<ArticuloPuntuado>();
        List<ArticuloPuntuado> sinInteresDelOtro = new List<ArticuloPuntuado>();
        foreach (ArticuloPuntuado p in Sortear(paraDescubrir, new Random(SemillaDelDia(idUsuario))))
        {
            if (p.InteresDelOtro > 0)
            {
                sorteados.Add(p);
            }
            else
            {
                sinInteresDelOtro.Add(p);
            }
        }
        sorteados.AddRange(sinInteresDelOtro);

        List<ArticuloCardViewModel> resultado = new List<ArticuloCardViewModel>();
        HashSet<int> yaDescubiertos = new HashSet<int>();
        int siguienteGusto = 0;
        int siguienteSorteado = 0;
        while (siguienteGusto < deTusGustos.Count)
        {
            bool tocaDescubrir = (resultado.Count + 1) % CadaCuantosUnoParaDescubrir == 0;
            if (tocaDescubrir && siguienteSorteado < sorteados.Count)
            {
                ArticuloCardViewModel descubierto = sorteados[siguienteSorteado++].Articulo;
                descubierto.Motivo = MotivoDescubrir;
                resultado.Add(descubierto);
                yaDescubiertos.Add(descubierto.IdArticulos);
            }
            else
            {
                resultado.Add(ConMotivo(deTusGustos[siguienteGusto++]));
            }
        }

        foreach (ArticuloPuntuado p in paraDescubrir)
        {
            if (!yaDescubiertos.Contains(p.Articulo.IdArticulos))
            {
                resultado.Add(ConMotivo(p));
            }
        }
        return resultado;
    }

    private static int CompararPorPuntaje(ArticuloPuntuado a, ArticuloPuntuado b)
    {
        int porPuntaje = b.Puntaje.CompareTo(a.Puntaje);
        if (porPuntaje != 0)
        {
            return porPuntaje;
        }
        return b.Articulo.IdArticulos.CompareTo(a.Articulo.IdArticulos);
    }

    private static bool EsDeTusGustos(ArticuloPuntuado p)
    {
        return p.Gusto >= UmbralGusto || p.CoincideBusqueda;
    }

    private static ArticuloCardViewModel ConMotivo(ArticuloPuntuado p)
    {
        p.Articulo.Motivo = p.PideLoQueTenes ? MotivoInteresMutuo : null;
        return p.Articulo;
    }

    private static List<ArticuloPuntuado> Sortear(List<ArticuloPuntuado> lista, Random azar)
    {
        List<ArticuloPuntuado> copia = new List<ArticuloPuntuado>(lista);
        for (int i = copia.Count - 1; i > 0; i--)
        {
            int j = azar.Next(i + 1);
            (copia[i], copia[j]) = (copia[j], copia[i]);
        }
        return copia;
    }

    private static int SemillaDelDia(int idUsuario)
    {
        return idUsuario * 1000 + DateTime.Today.DayOfYear;
    }
}
