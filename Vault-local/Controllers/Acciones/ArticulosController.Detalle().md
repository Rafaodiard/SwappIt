---
tipo: metodo
comunidad: "Controllers, vistas y JS"
archivos:
  - "Controllers/ArticulosController.cs"
graphify_ids:
  - "controllers_articuloscontroller_swappit_controllers_articuloscontroller_detalle"
tags:
  - tipo/metodo
  - comunidad/Controllers_vistas_y_JS
---
# ArticulosController.Detalle()

Método de [[ArticulosController]] · `Controllers/ArticulosController.cs` línea 62. Parámetros: `int`.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- llama a [[BD.GetArticuloById()]] · `calls` EXTRACTED
- llama a [[BD.GetArticulosCatalogo()]] · `calls` EXTRACTED
- llama a [[BD.GetCategoriaById()]] · `calls` EXTRACTED
- llama a [[BD.GetEstadoArticuloById()]] · `calls` EXTRACTED
- llama a [[BD.GetFotoUsuario()]] · `calls` EXTRACTED
- llama a [[BD.GetImagenesArticulo()]] · `calls` EXTRACTED
- llama a [[BD.GetProvinciaById()]] · `calls` EXTRACTED
- llama a [[BD.GetUsuarioById()]] · `calls` EXTRACTED
- usa el tipo [[IActionResult]] · `references` EXTRACTED
- muestra la vista [[Vista Articulos-Detalle]] · `renders` INFERRED

**Desde otras notas:**
- [[Vista _CardObjeto]] tiene un link acá · `links_to` EXTRACTED
- [[ArticulosController]] la tiene como método · `method` EXTRACTED
- [[PublicarController.Index() POST]] redirige acá · `redirects_to` EXTRACTED
