using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Swappit.Models;
using Swappit.Models.ViewModels;

namespace Swappit.Controllers;

public class ArticulosController : BaseController
{
    private readonly ILogger<ArticulosController> _logger;

    public ArticulosController(ILogger<ArticulosController> logger)
    {
        _logger = logger;
    }

    public IActionResult Buscar(string? q, int[]? categoria, int[]? estado, string? orden)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        bool logueado = usuarioId != null;
        string ordenElegido = Recomendaciones.OrdenValido(orden, logueado);
        string? busqueda = Catalogo.LimpiarBusqueda(q);
        List<int> categoriasSeleccionadas = Listas.IdsValidos(categoria, Catalogo.MaxOpcionesFiltro);
        List<int> estadosSeleccionados = Listas.IdsValidos(estado, Catalogo.MaxOpcionesFiltro);
        bool hayFiltros = Catalogo.HayFiltros(categoriasSeleccionadas, estadosSeleccionados);

        ViewBag.articulos = new List<ArticuloCardViewModel>();
        ViewBag.categorias = new List<OpcionFiltroViewModel>();
        ViewBag.estados = new List<OpcionFiltroViewModel>();
        ViewBag.errorCarga = false;
        try
        {
            ViewBag.articulos = Catalogo.Buscar(busqueda, categoriasSeleccionadas, estadosSeleccionados, usuarioId, ordenElegido);
            ViewBag.categorias = Catalogo.FiltroCategorias(busqueda, usuarioId, categoriasSeleccionadas);
            ViewBag.estados = Catalogo.FiltroEstados(busqueda, usuarioId, estadosSeleccionados);
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron cargar los artículos del catálogo");
            ViewBag.errorCarga = true;
        }

        ViewBag.busqueda = busqueda;
        ViewBag.categoriasSeleccionadas = categoriasSeleccionadas;
        ViewBag.hayFiltros = hayFiltros;
        ViewBag.orden = ordenElegido;
        ViewBag.opcionesOrden = Recomendaciones.OpcionesOrden(logueado);
        ViewBag.titulo = Catalogo.TituloBusqueda(busqueda, ordenElegido);
        ViewBag.textoSinResultados = Catalogo.TextoSinResultados(busqueda, hayFiltros);
        ViewBag.registrarBusqueda = Catalogo.HayQueRegistrarBusqueda(logueado, busqueda, categoriasSeleccionadas);
        return View();
    }

    public IActionResult Detalle(int id)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        ViewBag.errorCarga = false;
        ViewBag.detalle = null;
        ViewBag.Title = "Artículo no encontrado";

        try
        {
            Articulos? articulo = ArticulosBD.GetArticuloById(id);
            if (articulo == null)
            {
                Response.StatusCode = StatusCodes.Status404NotFound;
                return View();
            }

            Usuarios dueno = UsuariosBD.GetUsuarioById(articulo.IdUsuarios)!;
            List<string> imagenes = ArticulosBD.GetImagenesArticulo(articulo.IdArticulos);
            List<ArticuloCardViewModel> misArticulos = Catalogo.ArticulosParaOfrecer(usuarioId, articulo);
            int? idPropuestaEnCurso = Catalogo.PropuestaEnCurso(usuarioId, articulo);
            bool comprometido = IntercambiosBD.ArticuloComprometido(articulo.IdArticulos);

            ViewBag.Title = articulo.Nombre;
            ViewBag.detalle = articulo;
            ViewBag.fotos = Catalogo.Fotos(imagenes);
            ViewBag.fotoPrincipal = Catalogo.FotoPrincipal(imagenes);
            ViewBag.altFotoPrincipal = Catalogo.AltFotoPrincipal(articulo, imagenes);
            ViewBag.categoria = ArticulosBD.GetCategoriaById(articulo.IdCategorias);
            ViewBag.textoACambio = Catalogo.TextoACambio(articulo);
            ViewBag.estado = ArticulosBD.GetEstadoArticuloById(articulo.IdEstado);
            ViewBag.dueno = dueno;
            ViewBag.inicialesDueno = SesionUsuario.Iniciales(dueno.Nombre, dueno.Apellido);
            ViewBag.fotoDueno = UsuariosBD.GetFotoUsuario(dueno.IdUsuarios);
            ViewBag.ubicacion = Catalogo.Ubicacion(articulo, dueno);
            ViewBag.otrosArticulos = ArticulosBD.GetArticulosCatalogo(cantidad: 4, idUsuario: dueno.IdUsuarios, excluirArticulo: articulo.IdArticulos);
            ViewBag.esPropio = usuarioId == articulo.IdUsuarios;
            ViewBag.comprometido = comprometido;
            ViewBag.logueado = usuarioId != null;
            ViewBag.misArticulos = misArticulos;
            ViewBag.idPropuestaEnCurso = idPropuestaEnCurso;
            ViewBag.puedeProponer = Catalogo.PuedeProponer(usuarioId, articulo, idPropuestaEnCurso, comprometido);
            ViewBag.maxOfrecidos = Intercambios.MaxArticulosOfrecidos;
            ViewBag.leyendaOfrecer = Catalogo.LeyendaOfrecer(misArticulos.Count);
            ViewBag.mensaje = TempData["MensajeArticulo"] as string;
            ViewBag.error = TempData["ErrorArticulo"] as string;
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo cargar el artículo {IdArticulo}", id);
            ViewBag.errorCarga = true;
            ViewBag.detalle = null;
            ViewBag.Title = "Artículo";
        }
        return View();
    }
}
