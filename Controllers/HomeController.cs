using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Data.SqlClient;
using Swappit.Models;
using Swappit.Models.ViewModels;

namespace Swappit.Controllers;

public class HomeController : Controller
{
    private readonly ILogger<HomeController> _logger;

    public HomeController(ILogger<HomeController> logger)
    {
        _logger = logger;
    }

    public IActionResult Index()
    {
        // Objetos destacados: los 4 más recientes. Si la BD falla, la home se muestra igual sin destacados.
        try
        {
            ViewBag.destacados = BD.GetArticulosCatalogo(cantidad: 4);
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron cargar los artículos destacados");
            ViewBag.destacados = new List<ArticuloCardViewModel>();
        }
        return View();
    }

    public IActionResult Privacy()
    {
        return View();
    }

    // q: texto del buscador del header. categoria / estado: checkboxes del panel de filtros (se pueden marcar varios).
    public IActionResult Buscar(string? q, int[]? categoria, string[]? estado)
    {
        string? busqueda = string.IsNullOrWhiteSpace(q) ? null : q.Trim();
        List<int> categoriasSeleccionadas = (categoria ?? []).Where(id => id > 0).Distinct().Take(MaxOpcionesFiltro).ToList();
        // Articulos.Estado es varchar(50): un valor más largo no puede coincidir con nada.
        List<string> estadosSeleccionados = (estado ?? []).Where(e => !string.IsNullOrWhiteSpace(e) && e.Length <= 50)
            .Select(e => e.Trim()).Distinct().Take(MaxOpcionesFiltro).ToList();

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

        // Un estado marcado que no tiene artículos con la búsqueda actual no vuelve de la BD:
        // se agrega con 0 para que siga visible y se pueda desmarcar.
        foreach (var e in estadosSeleccionados.Where(e => !estados.Any(o => o.Valor == e)))
        {
            estados.Add(new OpcionFiltroViewModel { Valor = e, Texto = e, Cantidad = 0 });
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

    // Límite de opciones por filtro que se aceptan en la URL (hoy hay 6 categorías y pocos estados).
    private const int MaxOpcionesFiltro = 20;

    public IActionResult Chat()
    {
        return View();
    }

    // ===== Publicar objeto =====
    [HttpGet]
    public IActionResult Publicar()
    {
        // TODO: requerir usuario logueado.
        ViewBag.publicar = new PublicarArticuloViewModel();
        ViewBag.categorias = ObtenerCategorias();
        return View();
    }

    [HttpPost]
    public IActionResult Publicar(PublicarArticuloViewModel modelo)
    {
        // TODO: requerir usuario logueado.
        List<SelectListItem> categorias = ObtenerCategorias();
        if (modelo.IdCategorias.HasValue && !categorias.Any(c => c.Value == modelo.IdCategorias.Value.ToString()))
        {
            ModelState.AddModelError(nameof(modelo.IdCategorias), "Elegí una categoría de la lista");
        }

        // Si hay errores, la vista vuelve a mostrar lo que el usuario cargó.
        ViewBag.publicar = modelo;
        ViewBag.categorias = categorias;
        if (!ModelState.IsValid) return View();

        // TODO: guardar el artículo (y sus fotos) con IdUsuarios del usuario logueado.
        return View();
    }

    // Opciones del <select> de categorías, desde la tabla Categorias.
    // Si la BD falla, el select queda vacío y el POST no valida (no se puede publicar sin categoría).
    private List<SelectListItem> ObtenerCategorias()
    {
        try
        {
            return BD.GetCategorias().Select(c => new SelectListItem(c.Nombre, c.IdCategorias.ToString())).ToList();
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron cargar las categorías");
            return new List<SelectListItem>();
        }
    }

    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
        ViewBag.requestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier;
        return View();
    }
}
