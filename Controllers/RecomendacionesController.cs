using System.Globalization;
using System.Text;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Data.SqlClient;
using Swappit.Models;
using Swappit.Models.ViewModels;

namespace Swappit.Controllers;

public class RecomendacionesController : Controller
{
    // ---------- Valores del algoritmo ----------

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
    private const int DiasPopularidad = 30;
    private const int VistasPorFavorito = 3;

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

    private readonly ILogger<RecomendacionesController> _logger;

    public RecomendacionesController(ILogger<RecomendacionesController> logger)
    {
        _logger = logger;
    }

    // ---------- PARTE 1 - JUNTAR DATOS ----------

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Vista(int idArticulo)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return Unauthorized();
        }

        try
        {
            Articulos? articulo = BD.GetArticuloById(idArticulo);
            if (articulo == null || articulo.IdUsuarios == usuarioId)
            {
                return NoContent();
            }

            int idInteraccion = BD.RegistrarVista(usuarioId.Value, idArticulo);
            return Json(new { idInteraccion });
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo registrar la vista del artículo {IdArticulo}", idArticulo);
            return StatusCode(StatusCodes.Status503ServiceUnavailable);
        }
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Tiempo(int idInteraccion, int segundos)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return Unauthorized();
        }

        try
        {
            BD.GuardarSegundosVista(idInteraccion, usuarioId.Value, Math.Clamp(segundos, 0, MaxSegundosVista));
            return NoContent();
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo guardar el tiempo de la vista {IdInteraccion}", idInteraccion);
            return StatusCode(StatusCodes.Status503ServiceUnavailable);
        }
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Busqueda(string? texto, int[]? categorias)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return Unauthorized();
        }

        string? textoLimpio = string.IsNullOrWhiteSpace(texto) ? null : texto.Trim();
        if (textoLimpio != null && textoLimpio.Length > MaxLargoBusqueda)
        {
            textoLimpio = textoLimpio.Substring(0, MaxLargoBusqueda);
        }
        List<int> categoriasLimpias = (categorias ?? []).Where(id => id > 0).Distinct().Take(MaxCategoriasBusqueda).ToList();

        try
        {
            BD.RegistrarBusqueda(usuarioId.Value, textoLimpio, categoriasLimpias, MinutosSinRepetirBusqueda);
            return NoContent();
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo registrar la búsqueda del usuario {IdUsuario}", usuarioId);
            return StatusCode(StatusCodes.Status503ServiceUnavailable);
        }
    }

    // ---------- PARTE 2 - RECOMENDAR ----------

    [NonAction]
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

    [NonAction]
    public static string OrdenValido(string? orden, bool logueado)
    {
        if (OpcionesOrden(logueado).Any(o => o.Value == orden))
        {
            return orden!;
        }
        return logueado ? OrdenParaVos : OrdenPopulares;
    }

    [NonAction]
    public static List<ArticuloCardViewModel> Ordenar(List<ArticuloCardViewModel> articulos, string orden, int? idUsuario)
    {
        if (orden == OrdenAZ)
        {
            StringComparer alfabetico = StringComparer.Create(new CultureInfo("es-AR"), ignoreCase: true);
            return articulos.OrderBy(a => a.Nombre, alfabetico).ToList();
        }
        if (orden == OrdenRecientes)
        {
            return articulos.OrderByDescending(a => a.IdArticulos).ToList();
        }
        if (orden == OrdenParaVos && idUsuario != null)
        {
            List<ArticuloPuntuado> puntuados = Puntuar(idUsuario.Value, articulos);
            return Mezclar(idUsuario.Value, puntuados);
        }
        return Populares(articulos);
    }

    [NonAction]
    public static List<ArticuloCardViewModel> Destacados(int? idUsuario, int cantidad)
    {
        if (idUsuario == null)
        {
            return Populares(BD.GetArticulosCatalogo()).Take(cantidad).ToList();
        }

        List<ArticuloCardViewModel> candidatos = BD.GetArticulosCatalogo(excluirUsuario: idUsuario);
        List<ArticuloPuntuado> puntuados = Puntuar(idUsuario.Value, candidatos);

        List<ArticuloPuntuado> conInteresMutuo = puntuados.Where(p => p.InteresDelOtro > 0).ToList();
        if (conInteresMutuo.Count >= cantidad)
        {
            puntuados = conInteresMutuo;
        }
        return Mezclar(idUsuario.Value, puntuados).Take(cantidad).ToList();
    }

    // ---------- PASO 1: GUSTOS ----------

    private static Dictionary<int, double> ArmarGustos(IEnumerable<SenalGusto> senales)
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
        double maximo = puntos.Values.Max();
        return puntos.ToDictionary(p => p.Key, p => p.Value / maximo);
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

    private static List<string> PalabrasBuscadas(IEnumerable<SenalGusto> senales)
    {
        return senales
            .Where(s => s.Tipo == TipoInteracciones.Busqueda && !string.IsNullOrWhiteSpace(s.Texto))
            .OrderByDescending(s => s.Fecha)
            .Take(MaxBusquedasRecientes)
            .SelectMany(s => s.Texto!.Split(' ', StringSplitOptions.RemoveEmptyEntries))
            .Select(Normalizar)
            .Where(p => p.Length >= 3)
            .Distinct()
            .ToList();
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
        List<int> usuarios = articulos.Select(a => a.IdUsuarios).Append(idUsuario).Distinct().ToList();
        List<SenalGusto> senales = BD.GetSenalesGustos(usuarios, DateTime.Now.AddDays(-DiasDeHistorial));
        Dictionary<int, Dictionary<int, double>> gustos = usuarios.ToDictionary(
            u => u,
            u => ArmarGustos(senales.Where(s => s.IdUsuario == u)));

        Dictionary<int, double> misGustos = gustos[idUsuario];
        List<string> palabrasBuscadas = PalabrasBuscadas(senales.Where(s => s.IdUsuario == idUsuario));
        HashSet<int> misCategorias = BD.GetArticulosCatalogo(idUsuario: idUsuario).Select(a => a.IdCategorias).ToHashSet();
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
                + PesoPopularidad * p.Popularidad;
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

        double interes = misCategorias.Max(c => gustosDelDueno.GetValueOrDefault(c));

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
        return palabrasBuscadas.Any(p => nombreNormalizado.Contains(p));
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
        Dictionary<int, double> puntos = BD.GetPopularidad(DateTime.Now.AddDays(-DiasPopularidad))
            .ToDictionary(d => d.IdArticulo, d => (double)(d.Vistas + VistasPorFavorito * d.Favoritos));

        double maximo = puntos.Count > 0 ? puntos.Values.Max() : 0;
        if (maximo == 0)
        {
            return new Dictionary<int, double>();
        }
        return puntos.ToDictionary(p => p.Key, p => p.Value / maximo);
    }

    private static List<ArticuloCardViewModel> Populares(List<ArticuloCardViewModel> articulos)
    {
        Dictionary<int, double> popularidad = CalcularPopularidad();
        return articulos
            .OrderByDescending(a => popularidad.GetValueOrDefault(a.IdArticulos))
            .ThenByDescending(a => a.IdArticulos)
            .ToList();
    }

    // ---------- PASO 3: ORDENAR Y MEZCLAR ALGO PARA DESCUBRIR ----------

    private static List<ArticuloCardViewModel> Mezclar(int idUsuario, List<ArticuloPuntuado> puntuados)
    {
        List<ArticuloPuntuado> porPuntaje = puntuados
            .OrderByDescending(p => p.Puntaje)
            .ThenByDescending(p => p.Articulo.IdArticulos)
            .ToList();

        List<ArticuloPuntuado> deTusGustos = porPuntaje.Where(EsDeTusGustos).ToList();
        List<ArticuloPuntuado> paraDescubrir = porPuntaje.Where(p => !EsDeTusGustos(p)).ToList();

        if (deTusGustos.Count == 0 || paraDescubrir.Count == 0)
        {
            return porPuntaje.Select(ConMotivo).ToList();
        }

        List<ArticuloPuntuado> sorteados = Sortear(paraDescubrir, new Random(SemillaDelDia(idUsuario)))
            .OrderByDescending(p => p.InteresDelOtro > 0)
            .ToList();

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

        resultado.AddRange(paraDescubrir.Where(p => !yaDescubiertos.Contains(p.Articulo.IdArticulos)).Select(ConMotivo));
        return resultado;
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
