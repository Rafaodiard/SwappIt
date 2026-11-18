---
tipo: metodo
comunidad: "Controllers, vistas y JS"
archivos:
  - "Controllers/ArticulosController.cs"
graphify_ids:
  - "controllers_articuloscontroller_swappit_controllers_articuloscontroller_buscar"
tags:
  - tipo/metodo
  - comunidad/Controllers_vistas_y_JS
---
# ArticulosController.Buscar()

Método de [[ArticulosController]] · `Controllers/ArticulosController.cs` línea 24. Parámetros: `string?,int[]?,int[]?`.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- llama a [[BD.GetArticulosCatalogo()]] · `calls` EXTRACTED
- llama a [[BD.GetFiltroCategorias()]] · `calls` EXTRACTED
- llama a [[BD.GetFiltroEstados()]] · `calls` EXTRACTED
- usa el tipo [[IActionResult]] · `references` EXTRACTED
- muestra la vista [[Vista Articulos-Buscar]] · `renders` INFERRED

**Desde otras notas:**
- [[Vista Articulos-Detalle]] tiene un link acá · `links_to` EXTRACTED
- [[Vista Home-Index]] tiene un link acá · `links_to` EXTRACTED
- [[Vista Perfil-Publico]] tiene un link acá · `links_to` EXTRACTED
- [[Vista _Layout]] tiene un link acá · `links_to` EXTRACTED
- [[ArticulosController]] la tiene como método · `method` EXTRACTED
