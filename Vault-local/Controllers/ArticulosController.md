---
tipo: controller
comunidad: "Controllers, vistas y JS"
archivos:
  - "Controllers/ArticulosController.cs"
graphify_ids:
  - "controllers_articuloscontroller_swappit_controllers_articuloscontroller"
  - "controllers_articuloscontroller"
tags:
  - tipo/controller
  - comunidad/Controllers_vistas_y_JS
---
# ArticulosController

`Controllers/ArticulosController.cs` · Ver artículos: catálogo con buscador y filtros, y detalle. Publicar está en [[PublicarController]]. Recibe un `ILogger` para registrar errores de la base.

| Acción | URL | Qué hace |
|---|---|---|
| `Buscar(q, categoria[], estado[])` | `/Articulos/Buscar` | [[Flujo Buscar y filtrar]] → [[Vista Articulos-Buscar]] |
| `Detalle(id)` | `/Articulos/Detalle/{id}` | [[Flujo Ver detalle de artículo]] → [[Vista Articulos-Detalle]] |

- `MaxOpcionesFiltro = 20`: máximo de opciones por filtro que se aceptan en la URL.
- Atrapa `SqlException` y muestra un estado de error en lugar de romper la página.
- En Detalle asume que el dueño existe (`IdUsuarios` es NOT NULL con FK a [[Tabla Usuarios]]).

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Controllers]] · `contains` EXTRACTED
- importa [[Microsoft.AspNetCore.Mvc]] · `imports` EXTRACTED
- importa [[Microsoft.Data.SqlClient]] · `imports` EXTRACTED
- importa [[Namespace Swappit.Models]] · `imports` EXTRACTED
- importa [[Namespace Swappit.Models.ViewModels]] · `imports` EXTRACTED
- hereda de [[Controller (ASP.NET MVC)]] · `inherits` EXTRACTED
- tiene el método [[ArticulosController.Buscar()]] · `method` EXTRACTED
- tiene el método [[ArticulosController.Detalle()]] · `method` EXTRACTED
- usa el tipo [[ILogger]] · `references` EXTRACTED
