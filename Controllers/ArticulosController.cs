using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Swappit.Models;
using Swappit.Models.ViewModels;

namespace Swappit.Controllers;

public class ArticulosController : Controller
{
    private const int MaxOpcionesFiltro = 20;

    private readonly ILogger<ArticulosController> _logger;

    public ArticulosController(ILogger<ArticulosController> logger)
    {
        _logger = logger;
    }

    public IActionResult Buscar(string? q, int[]? categoria, int[]? estado, string? orden)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        string ordenElegido = RecomendacionesController.OrdenValido(orden, usuarioId != null);
        string? busqueda = string.IsNullOrWhiteSpace(q) ? null : q.Trim();
        List<int> categoriasSeleccionadas = (categoria ?? []).Where(id => id > 0).Distinct().Take(MaxOpcionesFiltro).ToList();
        List<int> estadosSeleccionados = (estado ?? []).Where(id => id > 0).Distinct().Take(MaxOpcionesFiltro).ToList();

        List<ArticuloCardViewModel> articulos = new List<ArticuloCardViewModel>();
        List<OpcionFiltroViewModel> categorias = new List<OpcionFiltroViewModel>();
        List<OpcionFiltroViewModel> estados = new List<OpcionFiltroViewModel>();
        bool errorCarga = false;

        try
        {
            articulos = BD.GetArticulosCatalogo(busqueda, categorias: categoriasSeleccionadas, estados: estadosSeleccionados, excluirUsuario: usuarioId);
            articulos = RecomendacionesController.Ordenar(articulos, ordenElegido, usuarioId);
            categorias = BD.GetFiltroCategorias(busqueda, usuarioId);
            estados = BD.GetFiltroEstados(busqueda, usuarioId);
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
        ViewBag.orden = ordenElegido;
        ViewBag.opcionesOrden = RecomendacionesController.OpcionesOrden(usuarioId != null);
        ViewBag.logueado = usuarioId != null;
        return View();
    }

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

            Usuarios dueno = BD.GetUsuarioById(articulo.IdUsuarios)!;
            bool esPropio = usuarioId == articulo.IdUsuarios;

            ViewBag.detalle = articulo;
            ViewBag.imagenes = BD.GetImagenesArticulo(articulo.IdArticulos);
            ViewBag.categoria = BD.GetCategoriaById(articulo.IdCategorias);
            ViewBag.categoriaACambio = articulo.IdCategoriaACambio.HasValue ? BD.GetCategoriaById(articulo.IdCategoriaACambio.Value) : null;
            ViewBag.estado = BD.GetEstadoArticuloById(articulo.IdEstado);
            ViewBag.dueno = dueno;
            ViewBag.fotoDueno = BD.GetFotoUsuario(dueno.IdUsuarios);
            ViewBag.provinciaDueno = BD.GetProvinciaById(dueno.IdProvincias);
            ViewBag.otrosArticulos = BD.GetArticulosCatalogo(idUsuario: dueno.IdUsuarios)
                .Where(a => a.IdArticulos != articulo.IdArticulos).Take(4).ToList();
            ViewBag.esPropio = esPropio;
            ViewBag.comprometido = BD.ArticuloComprometido(articulo.IdArticulos);
            ViewBag.logueado = usuarioId != null;
            ViewBag.misArticulos = usuarioId != null && !esPropio
                ? BD.GetArticulosCatalogo(idUsuario: usuarioId.Value)
                : new List<ArticuloCardViewModel>();
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
