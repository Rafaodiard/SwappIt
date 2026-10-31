---
tipo: controller
comunidad: "Publicar artículo"
archivos:
  - "Controllers/PublicarController.cs"
graphify_ids:
  - "controllers_publicarcontroller_swappit_controllers_publicarcontroller"
  - "controllers_publicarcontroller"
tags:
  - tipo/controller
  - comunidad/Publicar_artículo
---
# PublicarController

`Controllers/PublicarController.cs` · [[Flujo Publicar artículo]]. Hay que estar logueado (`UsuarioId` en sesión).

| Método | Qué hace |
|---|---|
| `Index()` GET | Form vacío con la ubicación = barrio del perfil |
| `Index(PublicarArticuloViewModel)` POST | `[ValidateAntiForgeryToken]`, `[RequestSizeLimit]` de 61 MB. Valida, guarda fotos y llama a [[BD]].PublicarArticulo |
| `ValidarFotos` | Máx. 6, JPG/PNG, 10 MB cada una (mismas reglas que [[PerfilController]]) |
| `AvisarFotosDeNuevo` | El navegador no recuerda las fotos si la página vuelve con errores |
| `GuardarFotosArticulo` | `wwwroot/img/articulos/{idUsuario}_{ticks:x}_{n}.ext` |
| `BorrarFotosArticulo` | Limpia las fotos si falló el guardado |
| `ObtenerCategorias` | `SelectListItem` desde [[BD]].GetCategorias |
| `ObtenerEstados` | [[BD]].GetEstadosArticulos |

Vista: [[Vista Publicar-Index]]. Modelo del form: [[PublicarArticuloViewModel]]. Arma un [[Articulos]] para guardar.

Comunidad del grafo: [[Comunidad - Publicar artículo]]

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Controllers]] · `contains` EXTRACTED
- importa [[Microsoft.AspNetCore.Mvc]] · `imports` EXTRACTED
- importa [[Microsoft.AspNetCore.Mvc.Rendering]] · `imports` EXTRACTED
- importa [[Microsoft.Data.SqlClient]] · `imports` EXTRACTED
- importa [[Namespace Swappit.Models]] · `imports` EXTRACTED
- importa [[Namespace Swappit.Models.ViewModels]] · `imports` EXTRACTED
- hereda de [[Controller (ASP.NET MVC)]] · `inherits` EXTRACTED
- tiene el método [[PublicarController.AvisarFotosDeNuevo()]] · `method` EXTRACTED
- tiene el método [[PublicarController.BorrarFotosArticulo()]] · `method` EXTRACTED
- tiene el método [[PublicarController.GuardarFotosArticulo()]] · `method` EXTRACTED
- tiene el método [[PublicarController.Index() GET]] · `method` EXTRACTED
- tiene el método [[PublicarController.Index() POST]] · `method` EXTRACTED
- tiene el método [[PublicarController.ObtenerCategorias()]] · `method` EXTRACTED
- tiene el método [[PublicarController.ObtenerEstados()]] · `method` EXTRACTED
- tiene el método [[PublicarController.ValidarFotos()]] · `method` EXTRACTED
- usa el tipo [[ILogger]] · `references` EXTRACTED
- usa el tipo [[IWebHostEnvironment]] · `references` EXTRACTED
