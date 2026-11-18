using Microsoft.AspNetCore.Mvc.ModelBinding;
using Microsoft.AspNetCore.Mvc.Rendering;
using Swappit.Models.ViewModels;

namespace Swappit.Models;

public static class Publicaciones
{
    public static PublicarArticuloViewModel Nueva(int idUsuario)
    {
        return new PublicarArticuloViewModel
        {
            Ubicacion = UsuariosBD.GetUsuarioById(idUsuario)?.Barrio ?? string.Empty
        };
    }

    public static bool LimiteAlcanzado(int idUsuario, PlanViewModel? plan)
    {
        if (plan == null)
        {
            return true;
        }
        return plan.MaxArticulos != null && Suscripciones.AlcanzoLimite(ArticulosBD.ContarArticulosActivos(idUsuario), plan.MaxArticulos);
    }

    public static List<SelectListItem> OpcionesCategorias()
    {
        List<SelectListItem> opciones = new List<SelectListItem>();
        foreach (Categorias c in ArticulosBD.GetCategorias())
        {
            opciones.Add(new SelectListItem(c.Nombre, c.IdCategorias.ToString()));
        }
        return opciones;
    }

    public static Dictionary<string, string> MensajesRequeridos()
    {
        return Formularios.MensajesRequeridos(typeof(PublicarArticuloViewModel));
    }

    public static List<IFormFile> FotosConContenido(List<IFormFile>? fotos)
    {
        List<IFormFile> conContenido = new List<IFormFile>();
        foreach (IFormFile foto in fotos ?? [])
        {
            if (foto.Length > 0)
            {
                conContenido.Add(foto);
            }
        }
        return conContenido;
    }

    public static List<ErrorCampo> Validar(PublicarArticuloViewModel modelo, List<SelectListItem> categorias, List<EstadosArticulos> estados,
        List<IFormFile> fotos)
    {
        List<ErrorCampo> errores = new List<ErrorCampo>();
        if (modelo.IdCategorias.HasValue && !EstaEnLista(categorias, modelo.IdCategorias.Value))
        {
            errores.Add(new ErrorCampo(nameof(modelo.IdCategorias), "Elegí una categoría de la lista"));
        }
        if (modelo.IdCategoriaACambio.HasValue && !EstaEnLista(categorias, modelo.IdCategoriaACambio.Value))
        {
            errores.Add(new ErrorCampo(nameof(modelo.IdCategoriaACambio), "Elegí una categoría de la lista o dejalo abierto a propuestas"));
        }
        if (modelo.IdEstado.HasValue && !ExisteEstado(estados, modelo.IdEstado.Value))
        {
            errores.Add(new ErrorCampo(nameof(modelo.IdEstado), "Elegí uno de los estados de la lista"));
        }

        string? errorFotos = ValidarFotos(fotos);
        if (errorFotos != null)
        {
            errores.Add(new ErrorCampo("Fotos", errorFotos));
        }
        return errores;
    }

    private static string? ValidarFotos(List<IFormFile> fotos)
    {
        bool extensionInvalida = false;
        bool muyPesada = false;
        foreach (IFormFile foto in fotos)
        {
            if (Array.IndexOf(PublicarArticuloViewModel.ExtensionesFoto, Path.GetExtension(foto.FileName).ToLower()) < 0)
            {
                extensionInvalida = true;
            }
            if (foto.Length > PublicarArticuloViewModel.MaxFotoMB * 1024 * 1024)
            {
                muyPesada = true;
            }
        }

        if (fotos.Count > PublicarArticuloViewModel.MaxFotos)
        {
            return $"Podés subir hasta {PublicarArticuloViewModel.MaxFotos} fotos.";
        }
        if (extensionInvalida)
        {
            return "Las fotos tienen que ser JPG o PNG.";
        }
        if (muyPesada)
        {
            return $"Cada foto puede pesar hasta {PublicarArticuloViewModel.MaxFotoMB} MB.";
        }
        return null;
    }

    public static void AvisarFotosDeNuevo(ModelStateDictionary modelState, List<IFormFile> fotos)
    {
        if (fotos.Count > 0 && !Formularios.TieneError(modelState, "Fotos"))
        {
            modelState.AddModelError("Fotos", "Volvé a elegir las fotos antes de publicar.");
        }
    }

    public static int Publicar(PublicarArticuloViewModel modelo, int idUsuario, List<IFormFile> fotos, string carpetaWeb)
    {
        List<string> rutasFotos = new List<string>();
        try
        {
            GuardarFotos(fotos, idUsuario, rutasFotos, carpetaWeb);

            Articulos articulo = new Articulos
            {
                Nombre = modelo.Titulo.Trim(),
                Descripcion = modelo.Descripcion.Trim(),
                IdEstado = modelo.IdEstado!.Value,
                IdUsuarios = idUsuario,
                IdCategorias = modelo.IdCategorias!.Value,
                Ubicacion = modelo.Ubicacion.Trim(),
                IdCategoriaACambio = modelo.IdCategoriaACambio,
                FechaPublicacion = DateTime.Today
            };
            return ArticulosBD.PublicarArticulo(articulo, rutasFotos);
        }
        catch
        {
            BorrarFotos(rutasFotos, carpetaWeb);
            throw;
        }
    }

    public static bool Editar(PublicarArticuloViewModel modelo, int idUsuario, int idArticulo,
        List<IFormFile> fotos, string carpetaWeb)
    {
        List<string> rutasFotos = new List<string>();
        List<string> rutasEliminar = modelo.FotosEliminar ?? new List<string>();
        try
        {
            GuardarFotos(fotos, idUsuario, rutasFotos, carpetaWeb);

            Articulos articulo = new Articulos
            {
                IdArticulos = idArticulo,
                Nombre = modelo.Titulo.Trim(),
                Descripcion = modelo.Descripcion.Trim(),
                IdEstado = modelo.IdEstado!.Value,
                IdUsuarios = idUsuario,
                IdCategorias = modelo.IdCategorias!.Value,
                Ubicacion = modelo.Ubicacion.Trim(),
                IdCategoriaACambio = modelo.IdCategoriaACambio
            };

            bool actualizado = ArticulosBD.ActualizarArticulo(articulo, idUsuario, rutasEliminar, rutasFotos);
            if (!actualizado)
            {
                BorrarFotos(rutasFotos, carpetaWeb);
                return false;
            }

            foreach (string ruta in rutasEliminar)
            {
                if (!rutasFotos.Contains(ruta))
                {
                    BorrarRuta(ruta, carpetaWeb);
                }
            }
            return true;
        }
        catch
        {
            BorrarFotos(rutasFotos, carpetaWeb);
            throw;
        }
    }

    private static void BorrarRuta(string ruta, string carpetaWeb)
    {
        if (ruta.StartsWith("/img/articulos/"))
        {
            string archivo = Path.Combine(carpetaWeb, "img", "articulos", Path.GetFileName(ruta));
            if (File.Exists(archivo)) File.Delete(archivo);
        }
    }

    private static bool EstaEnLista(List<SelectListItem> opciones, int valor)
    {
        foreach (SelectListItem opcion in opciones)
        {
            if (opcion.Value == valor.ToString())
            {
                return true;
            }
        }
        return false;
    }

    private static bool ExisteEstado(List<EstadosArticulos> estados, int idEstado)
    {
        foreach (EstadosArticulos estado in estados)
        {
            if (estado.IdEstadosArticulos == idEstado)
            {
                return true;
            }
        }
        return false;
    }

    private static void GuardarFotos(List<IFormFile> fotos, int idUsuario, List<string> rutasFotos, string carpetaWeb)
    {
        string carpeta = Path.Combine(carpetaWeb, "img", "articulos");
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

    private static void BorrarFotos(List<string> rutasFotos, string carpetaWeb)
    {
        foreach (string ruta in rutasFotos)
        {
            string archivo = Path.Combine(carpetaWeb, "img", "articulos", Path.GetFileName(ruta));
            if (File.Exists(archivo))
            {
                File.Delete(archivo);
            }
        }
    }
}
