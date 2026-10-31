---
tipo: controller
comunidad: "Controllers, vistas y JS"
archivos:
  - "Controllers/HomeController.cs"
graphify_ids:
  - "controllers_homecontroller_swappit_controllers_homecontroller"
  - "controllers_homecontroller"
tags:
  - tipo/controller
  - comunidad/Controllers_vistas_y_JS
---
# HomeController

`Controllers/HomeController.cs` · Páginas generales.

| Acción | Qué hace |
|---|---|
| `Index()` | Landing con los 4 artículos más recientes ([[BD]].GetArticulosCatalogo(cantidad: 4)); si la base falla se muestra igual sin destacados → [[Vista Home-Index]] |
| `Privacy()` | [[Vista Home-Privacy]] (texto de plantilla en inglés) |
| `Error()` | Sin caché; pasa el `requestId` → [[Vista Error]]. [[Program.cs]] lo usa como manejador de errores fuera de Development |

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Controllers]] · `contains` EXTRACTED
- importa [[Microsoft.AspNetCore.Mvc]] · `imports` EXTRACTED
- importa [[Microsoft.Data.SqlClient]] · `imports` EXTRACTED
- importa [[Namespace Swappit.Models]] · `imports` EXTRACTED
- importa [[Namespace Swappit.Models.ViewModels]] · `imports` EXTRACTED
- importa [[System.Diagnostics]] · `imports` EXTRACTED
- hereda de [[Controller (ASP.NET MVC)]] · `inherits` EXTRACTED
- tiene el método [[HomeController.Error()]] · `method` EXTRACTED
- tiene el método [[HomeController.Index()]] · `method` EXTRACTED
- tiene el método [[HomeController.Privacy()]] · `method` EXTRACTED
- usa el tipo [[ILogger]] · `references` EXTRACTED
