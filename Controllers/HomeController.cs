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
    private readonly IWebHostEnvironment _env;

    public HomeController(ILogger<HomeController> logger, IWebHostEnvironment env)
    {
        _logger = logger;
        _env = env;
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

    // Límite de opciones por filtro que se aceptan en la URL (hoy hay 6 categorías y pocos estados).
    private const int MaxOpcionesFiltro = 20;

    // Detalle de un artículo. Lo puede ver cualquiera (logueado o no).
    // Si el que mira es el dueño (Articulos.IdUsuarios = UsuarioId de la sesión) se muestran sus acciones
    // en lugar de "Proponer intercambio".
    public IActionResult Articulo(int id)
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
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo cargar el artículo {IdArticulo}", id);
            ViewBag.errorCarga = true;
            ViewBag.detalle = null;
        }
        return View();
    }

    public IActionResult Chat()
    {
        return View();
    }

    // ===== Publicar objeto =====
    // Hay que estar logueado: el artículo se guarda con IdUsuarios = UsuarioId de la sesión.
    [HttpGet]
    public IActionResult Publicar()
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return RedirectToAction("Index", "Account");
        }

        // La ubicación arranca con el barrio del perfil; el usuario la puede cambiar.
        PublicarArticuloViewModel publicar = new PublicarArticuloViewModel();
        try
        {
            publicar.Ubicacion = BD.GetUsuarioById(usuarioId.Value)?.Barrio ?? string.Empty;
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo leer el barrio del usuario {IdUsuario}", usuarioId);
        }

        ViewBag.publicar = publicar;
        ViewBag.categorias = ObtenerCategorias();
        ViewBag.estados = ObtenerEstados();
        return View();
    }

    // 6 fotos de 10 MB superan el límite por defecto de Kestrel por pedido (~28 MB): se amplía solo acá.
    private const long LimitePedidoPublicar = (PublicarArticuloViewModel.MaxFotos * PublicarArticuloViewModel.MaxFotoMB + 1) * 1024L * 1024L;

    [HttpPost]
    [ValidateAntiForgeryToken]
    [RequestSizeLimit(LimitePedidoPublicar)]
    [RequestFormLimits(MultipartBodyLengthLimit = LimitePedidoPublicar)]
    public IActionResult Publicar(PublicarArticuloViewModel modelo)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return RedirectToAction("Index", "Account");
        }

        List<SelectListItem> categorias = ObtenerCategorias();
        if (modelo.IdCategorias.HasValue && !categorias.Any(c => c.Value == modelo.IdCategorias.Value.ToString()))
        {
            ModelState.AddModelError(nameof(modelo.IdCategorias), "Elegí una categoría de la lista");
        }
        List<EstadosArticulos> estados = ObtenerEstados();
        if (modelo.IdEstado.HasValue && !estados.Any(e => e.IdEstadosArticulos == modelo.IdEstado.Value))
        {
            ModelState.AddModelError(nameof(modelo.IdEstado), "Elegí uno de los estados de la lista");
        }

        List<IFormFile> fotos = (modelo.Fotos ?? []).Where(f => f.Length > 0).ToList();
        ValidarFotos(fotos);

        // Si hay errores, la vista vuelve a mostrar lo que el usuario cargó.
        ViewBag.publicar = modelo;
        ViewBag.categorias = categorias;
        ViewBag.estados = estados;
        if (!ModelState.IsValid)
        {
            AvisarFotosDeNuevo(fotos);
            return View();
        }

        List<string> rutasFotos = new List<string>();
        try
        {
            GuardarFotosArticulo(fotos, usuarioId.Value, rutasFotos);

            Articulos articulo = new Articulos
            {
                Nombre = modelo.Titulo.Trim(),
                Descripcion = modelo.Descripcion.Trim(),
                IdEstado = modelo.IdEstado!.Value,
                IdUsuarios = usuarioId.Value,
                IdCategorias = modelo.IdCategorias!.Value,
                Ubicacion = modelo.Ubicacion.Trim(),
                ACambio = string.IsNullOrWhiteSpace(modelo.ACambio) ? null : modelo.ACambio.Trim()
            };
            int idArticulo = BD.PublicarArticulo(articulo, rutasFotos);

            TempData["MensajeArticulo"] = "¡Listo! Tu artículo ya está publicado.";
            return RedirectToAction("Articulo", new { id = idArticulo });
        }
        catch (Exception ex) when (ex is SqlException or IOException or UnauthorizedAccessException)
        {
            // No quedan fotos sueltas en wwwroot de un artículo que no se guardó.
            _logger.LogError(ex, "No se pudo publicar el artículo del usuario {IdUsuario}", usuarioId);
            BorrarFotosArticulo(rutasFotos);
            ModelState.AddModelError(string.Empty, "No pudimos publicar tu artículo. Probá de nuevo en un rato.");
            AvisarFotosDeNuevo(fotos);
            return View();
        }
    }

    // Mismas reglas que las fotos de perfil (AccountController.EditarPerfil): extensión JPG/PNG y tamaño máximo.
    private void ValidarFotos(List<IFormFile> fotos)
    {
        if (fotos.Count > PublicarArticuloViewModel.MaxFotos)
        {
            ModelState.AddModelError("Fotos", $"Podés subir hasta {PublicarArticuloViewModel.MaxFotos} fotos.");
        }
        else if (fotos.Any(f => !PublicarArticuloViewModel.ExtensionesFoto.Contains(Path.GetExtension(f.FileName).ToLower())))
        {
            ModelState.AddModelError("Fotos", "Las fotos tienen que ser JPG o PNG.");
        }
        else if (fotos.Any(f => f.Length > PublicarArticuloViewModel.MaxFotoMB * 1024 * 1024))
        {
            ModelState.AddModelError("Fotos", $"Cada foto puede pesar hasta {PublicarArticuloViewModel.MaxFotoMB} MB.");
        }
    }

    // El navegador no vuelve a cargar un <input type="file"> cuando la página vuelve con errores.
    private void AvisarFotosDeNuevo(List<IFormFile> fotos)
    {
        if (fotos.Count > 0 && ModelState["Fotos"]?.Errors.Count is null or 0)
        {
            ModelState.AddModelError("Fotos", "Volvé a elegir las fotos antes de publicar.");
        }
    }

    // Las fotos van a wwwroot/img/articulos y la ruta a Imagenes.Ruta, que es varchar(50):
    // nombre corto con id del usuario + ticks en hexa + número de foto (~48 caracteres como máximo).
    // Agrega cada ruta a rutasFotos antes de escribirla, para poder borrarlas si algo falla después.
    private void GuardarFotosArticulo(List<IFormFile> fotos, int idUsuario, List<string> rutasFotos)
    {
        string carpeta = Path.Combine(_env.WebRootPath, "img", "articulos");
        Directory.CreateDirectory(carpeta);

        long ticks = DateTime.Now.Ticks;
        for (int i = 0; i < fotos.Count; i++)
        {
            string extension = Path.GetExtension(fotos[i].FileName).ToLower();
            string nombreArchivo = $"{idUsuario}_{ticks:x}_{i + 1}{extension}";
            rutasFotos.Add($"/img/articulos/{nombreArchivo}");

            using (FileStream stream = new FileStream(Path.Combine(carpeta, nombreArchivo), FileMode.Create))
            {
                fotos[i].CopyTo(stream);
            }
        }
    }

    private void BorrarFotosArticulo(List<string> rutasFotos)
    {
        foreach (string ruta in rutasFotos)
        {
            string archivo = Path.Combine(_env.WebRootPath, "img", "articulos", Path.GetFileName(ruta));
            if (System.IO.File.Exists(archivo))
            {
                System.IO.File.Delete(archivo);
            }
        }
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

    // Opciones de "Estado del objeto", desde la tabla EstadosArticulos.
    // Si la BD falla, no hay opciones y el POST no valida (no se puede publicar sin estado).
    private List<EstadosArticulos> ObtenerEstados()
    {
        try
        {
            return BD.GetEstadosArticulos();
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron cargar los estados");
            return new List<EstadosArticulos>();
        }
    }

    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
        ViewBag.requestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier;
        return View();
    }
}
