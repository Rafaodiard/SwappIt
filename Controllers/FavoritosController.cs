using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Swappit.Models;
using Swappit.Models.ViewModels;

namespace Swappit.Controllers;

public class FavoritosController : BaseController
{
    private const int MaxImportar = 100;

    private readonly ILogger<FavoritosController> _logger;

    public FavoritosController(ILogger<FavoritosController> logger)
    {
        _logger = logger;
    }

    public IActionResult Index(int[]? categoria, int[]? estado, string? orden)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return RedirectToAction("Index", "Account");
        }

        List<int> categoriasSeleccionadas = Listas.IdsValidos(categoria, Catalogo.MaxOpcionesFiltro);
        List<int> estadosSeleccionados = Listas.IdsValidos(estado, Catalogo.MaxOpcionesFiltro);
        string ordenElegido = Catalogo.OrdenFavoritosValido(orden);

        ViewBag.articulos = new List<ArticuloCardViewModel>();
        ViewBag.categorias = new List<OpcionFiltroViewModel>();
        ViewBag.estados = new List<OpcionFiltroViewModel>();
        ViewBag.totalFavoritos = 0;
        ViewBag.textoCantidad = "";
        ViewBag.errorCarga = false;
        try
        {
            List<ArticuloCardViewModel> articulos = Catalogo.Favoritos(usuarioId.Value, categoriasSeleccionadas, estadosSeleccionados, ordenElegido);
            List<OpcionFiltroViewModel> categorias = Catalogo.FiltroCategorias(null, null, categoriasSeleccionadas, usuarioId.Value);
            ViewBag.articulos = articulos;
            ViewBag.categorias = categorias;
            ViewBag.estados = Catalogo.FiltroEstados(null, null, estadosSeleccionados, usuarioId.Value);
            ViewBag.totalFavoritos = Catalogo.Total(categorias);
            ViewBag.textoCantidad = Listas.Contar(articulos.Count, "favorito", "favoritos");
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron cargar los favoritos del usuario {IdUsuario}", usuarioId);
            ViewBag.errorCarga = true;
        }

        ViewBag.busqueda = null;
        ViewBag.hayFiltros = Catalogo.HayFiltros(categoriasSeleccionadas, estadosSeleccionados);
        ViewBag.orden = ordenElegido;
        ViewBag.opcionesOrden = Catalogo.OpcionesOrdenFavoritos();
        ViewBag.ocultarOpcionesVacias = true;
        return View();
    }

    [HttpGet]
    public IActionResult Ids()
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return Unauthorized();
        }

        try
        {
            return Json(FavoritosBD.GetIdsFavoritos(usuarioId.Value));
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron leer los favoritos del usuario {IdUsuario}", usuarioId);
            return StatusCode(StatusCodes.Status503ServiceUnavailable);
        }
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Alternar(int idArticulo)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return Unauthorized();
        }

        try
        {
            bool? esFavorito = FavoritosBD.AlternarFavorito(usuarioId.Value, idArticulo);
            if (esFavorito == null)
            {
                return NotFound();
            }
            return Json(new { esFavorito });
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo cambiar el favorito {IdArticulo} del usuario {IdUsuario}", idArticulo, usuarioId);
            return StatusCode(StatusCodes.Status503ServiceUnavailable);
        }
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Importar(int[]? ids)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return Unauthorized();
        }

        List<int> pedidos = Listas.IdsValidos(ids, MaxImportar);
        try
        {
            FavoritosBD.ImportarFavoritos(usuarioId.Value, pedidos);
            return Json(FavoritosBD.GetIdsFavoritos(usuarioId.Value));
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron importar los favoritos del usuario {IdUsuario}", usuarioId);
            return StatusCode(StatusCodes.Status503ServiceUnavailable);
        }
    }
}
