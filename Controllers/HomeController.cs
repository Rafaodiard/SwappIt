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
            return View(BD.GetArticulosCatalogo(cantidad: 4));
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron cargar los artículos destacados");
            return View(new List<ArticuloCardViewModel>());
        }
    }

    public IActionResult Privacy()
    {
        return View();
    }

    // q: texto del buscador del header. categoria / estado: checkboxes del panel de filtros (se pueden marcar varios).
    public IActionResult Buscar(string? q, int[]? categoria, string[]? estado)
    {
        var modelo = new BuscarViewModel
        {
            Busqueda = string.IsNullOrWhiteSpace(q) ? null : q.Trim(),
            CategoriasSeleccionadas = (categoria ?? []).Where(id => id > 0).Distinct().Take(MaxOpcionesFiltro).ToList(),
            // Articulos.Estado es varchar(50): un valor más largo no puede coincidir con nada.
            EstadosSeleccionados = (estado ?? []).Where(e => !string.IsNullOrWhiteSpace(e) && e.Length <= 50)
                .Select(e => e.Trim()).Distinct().Take(MaxOpcionesFiltro).ToList()
        };

        try
        {
            modelo.Articulos = BD.GetArticulosCatalogo(modelo.Busqueda, categorias: modelo.CategoriasSeleccionadas,
                estados: modelo.EstadosSeleccionados);
            modelo.Categorias = BD.GetFiltroCategorias(modelo.Busqueda);
            modelo.Estados = BD.GetFiltroEstados(modelo.Busqueda);
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron cargar los artículos del catálogo");
            modelo.ErrorCarga = true;
        }

        // Un estado marcado que no tiene artículos con la búsqueda actual no vuelve de la BD:
        // se agrega con 0 para que siga visible y se pueda desmarcar.
        foreach (var e in modelo.EstadosSeleccionados.Where(e => !modelo.Estados.Any(o => o.Valor == e)))
        {
            modelo.Estados.Add(new OpcionFiltroViewModel { Valor = e, Texto = e, Cantidad = 0 });
        }

        return View(modelo);
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
        return View(new PublicarArticuloViewModel { Categorias = ObtenerCategorias() });
    }

    [HttpPost]
    public IActionResult Publicar(PublicarArticuloViewModel modelo)
    {
        // TODO: requerir usuario logueado.
        modelo.Categorias = ObtenerCategorias();
        if (modelo.IdCategorias.HasValue && !modelo.Categorias.Any(c => c.Value == modelo.IdCategorias.Value.ToString()))
        {
            ModelState.AddModelError(nameof(modelo.IdCategorias), "Elegí una categoría de la lista");
        }
        if (!ModelState.IsValid) return View(modelo);

        // TODO: guardar el artículo (y sus fotos) con IdUsuarios del usuario logueado.
        return View(modelo);
    }

    // Opciones del <select> de categorías, desde la tabla Categorias.
    // Si la BD falla, el select queda vacío y el POST no valida (no se puede publicar sin categoría).
    private IEnumerable<SelectListItem> ObtenerCategorias()
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
        return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
    }
}
