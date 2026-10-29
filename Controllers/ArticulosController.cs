using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Swappit.Models;
using Swappit.Models.ViewModels;

namespace Swappit.Controllers;

// Ver artículos: el catálogo con buscador y filtros (/Articulos/Buscar)
// y el detalle de cada uno (/Articulos/Detalle/5).
// Publicar un artículo nuevo está en PublicarController.
public class ArticulosController : Controller
{
    // Límite de opciones por filtro que se aceptan en la URL (hoy hay 6 categorías y pocos estados).
    private const int MaxOpcionesFiltro = 20;

    private readonly ILogger<ArticulosController> _logger;

    public ArticulosController(ILogger<ArticulosController> logger)
    {
        _logger = logger;
    }

    // q: texto del buscador del header. categoria / estado: checkboxes del panel de filtros (se pueden marcar varios).
    public IActionResult Buscar(string? q, int[]? categoria, int[]? estado)
    {
        string? busqueda = string.IsNullOrWhiteSpace(q) ? null : q.Trim();
        List<int> categoriasSeleccionadas = (categoria ?? []).Where(id => id > 0).Distinct().Take(MaxOpcionesFiltro).ToList();
        List<int> estadosSeleccionados = (estado ?? []).Where(id => id > 0).Distinct().Take(MaxOpcionesFiltro).ToList();

        List<ArticuloCardViewModel> articulos = new List<ArticuloCardViewModel>();
        List<OpcionFiltroViewModel> categorias = new List<OpcionFiltroViewModel>();
        List<OpcionFiltroViewModel> estados = new List<OpcionFiltroViewModel>();
        // true si no se pudo leer la BD (para distinguir "error" de "sin resultados").
        bool errorCarga = false;

        try
        {
            articulos = BD.GetArticulosCatalogo(busqueda, categorias: categoriasSeleccionadas, estados: estadosSeleccionados);
            categorias = BD.GetFiltroCategorias(busqueda);
            estados = BD.GetFiltroEstados(busqueda);
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron cargar los artículos del catálogo");
            errorCarga = true;
        }

        ViewBag.articulos = articulos;
        ViewBag.busqueda = busqueda;
        ViewBag.categorias = categorias;
        ViewBag.estados = estados;
        ViewBag.categoriasSeleccionadas = categoriasSeleccionadas;
        ViewBag.estadosSeleccionados = estadosSeleccionados;
        ViewBag.errorCarga = errorCarga;
        ViewBag.hayFiltros = categoriasSeleccionadas.Count > 0 || estadosSeleccionados.Count > 0;
        return View();
    }

    // Detalle de un artículo. Lo puede ver cualquiera (logueado o no).
    // Si el que mira es el dueño (Articulos.IdUsuarios = UsuarioId de la sesión) se muestran sus acciones
    // en lugar de "Proponer intercambio".
    public IActionResult Detalle(int id)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        ViewBag.errorCarga = false;

        try
        {
            Articulos? articulo = BD.GetArticuloById(id);
            if (articulo == null)
            {
                Response.StatusCode = StatusCodes.Status404NotFound;
                ViewBag.detalle = null;
                return View();
            }

            // Articulos.IdUsuarios es NOT NULL con clave foránea a Usuarios: el dueño siempre existe.
            Usuarios dueno = BD.GetUsuarioById(articulo.IdUsuarios)!;
            bool esPropio = usuarioId == articulo.IdUsuarios;

            ViewBag.detalle = articulo;
            ViewBag.imagenes = BD.GetImagenesArticulo(articulo.IdArticulos);
            ViewBag.categoria = BD.GetCategoriaById(articulo.IdCategorias);
            ViewBag.estado = BD.GetEstadoArticuloById(articulo.IdEstado);
            ViewBag.dueno = dueno;
            ViewBag.fotoDueno = BD.GetFotoUsuario(dueno.IdUsuarios);
            ViewBag.provinciaDueno = BD.GetProvinciaById(dueno.IdProvincias);
            ViewBag.otrosArticulos = BD.GetArticulosCatalogo(idUsuario: dueno.IdUsuarios)
                .Where(a => a.IdArticulos != articulo.IdArticulos).Take(4).ToList();
            ViewBag.esPropio = esPropio;
            ViewBag.logueado = usuarioId != null;
            // Pop up "Proponer intercambio": artículos del usuario logueado que puede ofrecer a cambio.
            ViewBag.misArticulos = usuarioId != null && !esPropio
                ? BD.GetArticulosCatalogo(idUsuario: usuarioId.Value)
                : new List<ArticuloCardViewModel>();
            // Si ya propuso un intercambio por este artículo (Pendiente o Aceptado), se muestra "Propuesta enviada".
            ViewBag.idPropuestaEnCurso = usuarioId != null && !esPropio
                ? BD.GetIdPropuestaEnCurso(usuarioId.Value, articulo.IdArticulos)
                : null;
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo cargar el artículo {IdArticulo}", id);
            ViewBag.errorCarga = true;
            ViewBag.detalle = null;
        }
        return View();
    }
}
