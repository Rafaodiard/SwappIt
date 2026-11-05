using System.Globalization;
using System.Text;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Data.SqlClient;
using Swappit.Models;
using Swappit.Models.ViewModels;

namespace Swappit.Controllers;

// =====================================================================================================
// ALGORITMO DE RECOMENDACIONES
// Todo el algoritmo está en este archivo y en wwwroot/js/recomendaciones.js.
//
// PARTE 1 - Juntar datos. Acciones que llama recomendaciones.js (solo con sesión iniciada):
//   POST /Recomendaciones/Vista     el usuario abrió el detalle de un artículo (= hizo clic en él)
//   POST /Recomendaciones/Tiempo    cuántos segundos se quedó mirando ese detalle
//   POST /Recomendaciones/Busqueda  qué buscó y qué categorías marcó en los filtros de Explorar
//   Todo se guarda en la tabla Interacciones. El algoritmo además lee datos que se guardan en otros lados:
//   los favoritos (FavoritosController, también en Interacciones), las propuestas que mandó (Intercambios)
//   y la categoría que pide a cambio en lo que publicó (Articulos.IdCategoriaACambio).
//
// PARTE 2 - Recomendar. Métodos que usan otros controllers:
//   Ordenar(...)    ordena Explorar: Para vos, Más populares, Más recientes o A - Z (ArticulosController.Buscar).
//   Destacados(...) los artículos de la sección "Destacados" de la página principal (HomeController).
//
// Cómo se arma "Para vos" (los 3 pasos están más abajo, en ese orden):
//   Paso 1. Gustos: para el usuario y para cada dueño de un artículo se suman puntos por categoría
//           (favoritos, propuestas, lo que pide a cambio, filtros, clics y tiempo). Lo más nuevo pesa más.
//   Paso 2. Puntaje de cada artículo = cuánto te gusta su categoría + si coincide con lo que buscaste
//           + cuánto le interesa al dueño algo tuyo (para que el intercambio sea posible) + qué tan popular es.
//   Paso 3. Se ordena por puntaje y 1 de cada 5 lugares se usa para algo fuera de tus gustos (para descubrir).
// =====================================================================================================
public class RecomendacionesController : Controller
{
    // ---------- Valores del algoritmo (para ajustarlo alcanza con cambiar estos números) ----------

    // Paso 1: puntos que suma cada dato a la categoría del artículo.
    private const double PuntosFavorito = 5;
    private const double PuntosPropuesta = 4;        // propuso un intercambio por un artículo de esa categoría
    private const double PuntosPideACambio = 4;      // pide esa categoría a cambio en un artículo que publicó
    private const double PuntosFiltroCategoria = 2;  // marcó esa categoría en los filtros de Explorar
    private const double PuntosVista = 1;            // abrió el detalle de un artículo de esa categoría
    // Quedarse mirando suma 1 punto más cada 30 segundos, hasta 3 puntos (10 minutos no valen más que 90 segundos).
    private const int SegundosPorPuntoExtra = 30;
    private const double MaxPuntosPorTiempo = 3;

    // Los gustos cambian: solo se miran los últimos 90 días, y lo de esta semana vale el doble que lo del mes.
    private const int DiasDeHistorial = 90;

    // Paso 2: cuánto pesa cada parte en el puntaje final (suman 1).
    private const double PesoGusto = 0.50;
    private const double PesoBusqueda = 0.15;
    private const double PesoInteresDelOtro = 0.25;
    private const double PesoPopularidad = 0.10;
    // Si el dueño dejó "Abierto a propuestas", lo tuyo le puede servir aunque no sepamos sus gustos.
    private const double InteresSiEstaAbierto = 0.5;
    // Popularidad: vistas y favoritos de todos los usuarios en los últimos 30 días (1 favorito = 3 vistas).
    private const int DiasPopularidad = 30;
    private const int VistasPorFavorito = 3;

    // Paso 3: 1 de cada 5 lugares es para descubrir algo fuera de tus gustos.
    private const int CadaCuantosUnoParaDescubrir = 5;
    // Una categoría con menos del 20% del interés de tu favorita cuenta como "fuera de tus gustos".
    private const double UmbralGusto = 0.2;

    // Búsquedas: se usan las 10 últimas, y la misma búsqueda no se vuelve a guardar en 30 minutos.
    private const int MaxBusquedasRecientes = 10;
    private const int MinutosSinRepetirBusqueda = 30;
    private const int MaxLargoBusqueda = 100;
    private const int MaxCategoriasBusqueda = 20;
    // Tope para el tiempo de una vista (una pestaña olvidada abierta no tiene que contar horas).
    private const int MaxSegundosVista = 3600;

    // Formas de ordenar Explorar (valor del parámetro "orden" de la URL).
    public const string OrdenParaVos = "paravos";
    public const string OrdenPopulares = "populares";
    public const string OrdenRecientes = "recientes";
    public const string OrdenAZ = "az";

    // Motivos que muestra la card (_CardObjeto) debajo del nombre.
    public const string MotivoInteresMutuo = "Le interesa algo tuyo";
    public const string MotivoDescubrir = "Para descubrir";

    private readonly ILogger<RecomendacionesController> _logger;

    public RecomendacionesController(ILogger<RecomendacionesController> logger)
    {
        _logger = logger;
    }

    // =====================================================================================================
    // PARTE 1 - JUNTAR DATOS (lo llama recomendaciones.js)
    // =====================================================================================================

    // El usuario abrió el detalle de un artículo. Devuelve { idInteraccion } para que el JS
    // después mande cuánto tiempo se quedó (acción Tiempo).
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
            // Mirar un artículo propio no dice nada de lo que te gusta.
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

    // Cuántos segundos estuvo el detalle a la vista (el JS no cuenta el tiempo con la pestaña escondida).
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

    // Lo que buscó en Explorar: el texto del buscador y las categorías que marcó en los filtros.
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

    // =====================================================================================================
    // PARTE 2 - RECOMENDAR (lo usan ArticulosController y HomeController)
    // Son static porque no responden a una URL: otros controllers los llaman como funciones.
    // Pueden tirar SqlException: la maneja el controller que los llama.
    // =====================================================================================================

    // Opciones del select "Ordenar por" de Explorar. "Para vos" solo aparece con sesión (sin sesión no hay gustos).
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

    // El orden pedido en la URL, si es una opción válida. Si no viene (o no vale), el orden por defecto:
    // "Para vos" con sesión y "Más populares" sin sesión.
    [NonAction]
    public static string OrdenValido(string? orden, bool logueado)
    {
        if (OpcionesOrden(logueado).Any(o => o.Value == orden))
        {
            return orden!;
        }
        return logueado ? OrdenParaVos : OrdenPopulares;
    }

    // Ordena los artículos de Explorar (ya filtrados por búsqueda, categoría y estado) según el orden elegido.
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

    // Sección "Destacados" de la página principal.
    // Sin sesión: los más populares. Con sesión: "Para vos", pero pidiendo interés de los dos lados:
    // solo artículos cuyo dueño puede querer algo tuyo (si esos no alcanzan para llenar la sección, se usan todos).
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

    // Gustos de un usuario: puntos por categoría pasados a una escala de 0 a 1 (1 = su categoría favorita).
    // Ej: 10 puntos en Hogar y 5 en Libros -> Hogar 1, Libros 0,5. Una categoría sin datos no aparece (vale 0).
    private static Dictionary<int, double> ArmarGustos(IEnumerable<SenalGusto> senales)
    {
        Dictionary<int, double> puntos = new Dictionary<int, double>();
        foreach (SenalGusto senal in senales)
        {
            // Las búsquedas de texto no tienen categoría: se usan aparte (PalabrasBuscadas).
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
                // División entera: 0-29 s -> 0, 30-59 s -> 1, 60-89 s -> 2, 90 s o más -> 3.
                double puntosPorTiempo = Math.Min((senal.Segundos ?? 0) / SegundosPorPuntoExtra, MaxPuntosPorTiempo);
                return PuntosVista + puntosPorTiempo;
            default:
                return 0;
        }
    }

    // Lo más nuevo pesa más: hasta 7 días vale entero, hasta 30 días la mitad y más viejo un cuarto.
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

    // Palabras de las últimas búsquedas del usuario (3 letras o más, sin tildes ni mayúsculas).
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
        public double Gusto { get; set; }            // 0 a 1: cuánto te gusta su categoría
        public bool CoincideBusqueda { get; set; }   // su nombre tiene una palabra que buscaste
        public double InteresDelOtro { get; set; }   // 0 a 1: cuánto le puede interesar al dueño algo tuyo
        public bool PideLoQueTenes { get; set; }     // el dueño pide a cambio una categoría de tus artículos
        public double Popularidad { get; set; }      // 0 a 1: vistas y favoritos de todos
        public double Puntaje { get; set; }
    }

    private static List<ArticuloPuntuado> Puntuar(int idUsuario, List<ArticuloCardViewModel> articulos)
    {
        // Paso 1 para todos de una vez: el usuario y los dueños de los artículos (una sola consulta).
        List<int> usuarios = articulos.Select(a => a.IdUsuarios).Append(idUsuario).Distinct().ToList();
        List<SenalGusto> senales = BD.GetSenalesGustos(usuarios, DateTime.Now.AddDays(-DiasDeHistorial));
        Dictionary<int, Dictionary<int, double>> gustos = usuarios.ToDictionary(
            u => u,
            u => ArmarGustos(senales.Where(s => s.IdUsuario == u)));

        Dictionary<int, double> misGustos = gustos[idUsuario];
        List<string> palabrasBuscadas = PalabrasBuscadas(senales.Where(s => s.IdUsuario == idUsuario));
        // Lo que el usuario puede ofrecer: las categorías de sus artículos disponibles.
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

    // Reciprocidad: cuánto le puede interesar al dueño del artículo algo de lo que vos publicaste (0 a 1).
    // Un intercambio necesita que los dos quieran algo del otro.
    private static double InteresDelDueno(ArticuloCardViewModel articulo, Dictionary<int, double> gustosDelDueno, HashSet<int> misCategorias)
    {
        // Sin artículos publicados no tenés nada para ofrecer.
        if (misCategorias.Count == 0)
        {
            return 0;
        }

        // Pide a cambio justo una categoría que vos tenés: interés máximo.
        if (articulo.IdCategoriaACambio != null && misCategorias.Contains(articulo.IdCategoriaACambio.Value))
        {
            return 1;
        }

        // Si no, lo que dicen sus gustos (Paso 1) sobre tus categorías: se toma la que más le gusta.
        double interes = misCategorias.Max(c => gustosDelDueno.GetValueOrDefault(c));

        // "Abierto a propuestas": cualquier cosa le puede servir.
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

    // Minúsculas, sin tildes y sin la "s" del plural ("Sillas" -> "silla"), para que "silla" encuentre "Sillas de comedor".
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

    // Popularidad de cada artículo en escala 0 a 1 (1 = el más popular): vistas + 3 por cada favorito, últimos 30 días.
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

    // "Más populares" (y lo que ve quien no inició sesión). A igual popularidad, primero los más nuevos.
    private static List<ArticuloCardViewModel> Populares(List<ArticuloCardViewModel> articulos)
    {
        Dictionary<int, double> popularidad = CalcularPopularidad();
        return articulos
            .OrderByDescending(a => popularidad.GetValueOrDefault(a.IdArticulos))
            .ThenByDescending(a => a.IdArticulos)
            .ToList();
    }

    // ---------- PASO 3: ORDENAR Y MEZCLAR ALGO PARA DESCUBRIR ----------

    // Ordena por puntaje (a igual puntaje, primero los más nuevos) y cada 5 lugares pone uno "para descubrir":
    // un artículo de una categoría que casi no miraste. Así el feed no es todo de tus gustos y, si algo nuevo
    // te interesa, al mirarlo empieza a sumar a tus gustos (Paso 1).
    // Los que van a descubrir se sortean, pero primero los que tienen interés del otro lado (el intercambio es posible).
    // El sorteo cambia una vez por día, no en cada recarga, para que la lista no salte cada vez que volvés.
    private static List<ArticuloCardViewModel> Mezclar(int idUsuario, List<ArticuloPuntuado> puntuados)
    {
        List<ArticuloPuntuado> porPuntaje = puntuados
            .OrderByDescending(p => p.Puntaje)
            .ThenByDescending(p => p.Articulo.IdArticulos)
            .ToList();

        List<ArticuloPuntuado> deTusGustos = porPuntaje.Where(EsDeTusGustos).ToList();
        List<ArticuloPuntuado> paraDescubrir = porPuntaje.Where(p => !EsDeTusGustos(p)).ToList();

        // Si todo es de tus gustos, o todavía no hay gustos (usuario nuevo), no hay nada que mezclar.
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

        // Lo que quedó fuera de tus gustos va al final, por puntaje.
        resultado.AddRange(paraDescubrir.Where(p => !yaDescubiertos.Contains(p.Articulo.IdArticulos)).Select(ConMotivo));
        return resultado;
    }

    private static bool EsDeTusGustos(ArticuloPuntuado p)
    {
        return p.Gusto >= UmbralGusto || p.CoincideBusqueda;
    }

    // La card dice "Le interesa algo tuyo" solo cuando es seguro: el dueño pide a cambio una categoría que vos tenés.
    private static ArticuloCardViewModel ConMotivo(ArticuloPuntuado p)
    {
        p.Articulo.Motivo = p.PideLoQueTenes ? MotivoInteresMutuo : null;
        return p.Articulo;
    }

    // Mezcla una lista al azar (algoritmo de Fisher-Yates) sin cambiar la original.
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

    // Misma semilla todo el día para el mismo usuario: mismo sorteo hasta mañana.
    private static int SemillaDelDia(int idUsuario)
    {
        return idUsuario * 1000 + DateTime.Today.DayOfYear;
    }
}
