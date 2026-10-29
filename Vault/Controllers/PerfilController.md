---
tipo: controller
comunidad: "Controllers, vistas y JS"
archivos:
  - "Controllers/PerfilController.cs"
graphify_ids:
  - "controllers_perfilcontroller_swappit_controllers_perfilcontroller"
  - "controllers_perfilcontroller"
tags:
  - tipo/controller
  - comunidad/Controllers_vistas_y_JS
---
# PerfilController

`Controllers/PerfilController.cs` · Perfiles: el propio, editarlo y el público de otro usuario. Recibe `IWebHostEnvironment` para saber dónde está `wwwroot`.

| Acción | URL | Qué hace |
|---|---|---|
| `Index()` | `/Perfil` | Mi perfil → [[Vista Perfil-Index]] ([[Flujo Editar perfil]]) |
| `Publico(id)` | `/Perfil/Publico/{id}` | [[Flujo Perfil público]] → [[Vista Perfil-Publico]] |
| `Editar(EditarPerfilViewModel)` | POST `/Perfil/Editar` | Guarda el pop up "Editar perfil" |
| `GuardarFoto` | privado | `wwwroot/img/perfiles/{id}_{ticks:x}.ext` |
| `BorrarFoto` | privado | Borra el archivo solo si la ruta empieza con `/img/perfiles/` |

Mensajes con `TempData["ErrorPerfil"]` / `TempData["MensajePerfil"]` porque Editar redirige a Index.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Controllers]] · `contains` EXTRACTED
- importa [[Microsoft.AspNetCore.Mvc]] · `imports` EXTRACTED
- importa [[Namespace Swappit.Models]] · `imports` EXTRACTED
- importa [[Namespace Swappit.Models.ViewModels]] · `imports` EXTRACTED
- hereda de [[Controller (ASP.NET MVC)]] · `inherits` EXTRACTED
- tiene el método [[PerfilController.BorrarFoto()]] · `method` EXTRACTED
- tiene el método [[PerfilController.Editar()]] · `method` EXTRACTED
- tiene el método [[PerfilController.GuardarFoto()]] · `method` EXTRACTED
- tiene el método [[PerfilController.Index()]] · `method` EXTRACTED
- tiene el método [[PerfilController.Publico()]] · `method` EXTRACTED
- usa el tipo [[IWebHostEnvironment]] · `references` EXTRACTED
