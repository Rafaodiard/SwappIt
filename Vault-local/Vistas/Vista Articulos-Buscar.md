---
tipo: vista
comunidad: "Namespaces y formularios"
archivos:
  - "Views/Articulos/Buscar.cshtml"
graphify_ids:
  - "views_articulos_buscar"
tags:
  - tipo/vista
  - comunidad/Namespaces_y_formularios
---
# Vista: Articulos / Buscar (catálogo)

`Views/Articulos/Buscar.cshtml` · [[ArticulosController]].Buscar.

- **Filtros** (form GET `#filtros`, colapsable en celulares): checkboxes de categoría con su contador, rango de distancia (sin `name`: no se envía), chips de estado. `q` va oculto para combinar búsqueda + filtros. "Limpiar" si hay filtros.
- **Resultados:** título "Los más buscados" o "Resultados para …", select de orden (visual), botones grilla/lista, una [[Vista _CardObjeto]] por artículo.
- Estados: error de carga, "Todavía no hay objetos publicados" o "No encontramos objetos con esos filtros".
- Script: [[buscar.js]].

Comunidad del grafo: [[Comunidad - Namespaces y formularios]]

## Conexiones en el grafo (graphify)
- llama a [[ArticuloCardViewModel]] · `calls` EXTRACTED
- llama a [[OpcionFiltroViewModel]] · `calls` EXTRACTED
- importa [[Namespace Swappit.Models.ViewModels]] · `imports` EXTRACTED
- incluye el partial [[Vista _CardObjeto]] · `includes` EXTRACTED
- carga el script [[buscar.js]] · `loads_script` EXTRACTED

**Desde otras notas:**
- [[ArticulosController.Buscar()]] muestra esta vista · `renders` INFERRED
