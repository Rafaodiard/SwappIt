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

Método de [[ArticulosController]] · `Controllers/ArticulosController.cs` línea 64. Parámetros: `int`.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- llama a [[ArticulosBD.GetArticuloById()]] · `calls` EXTRACTED
- llama a [[ArticulosBD.GetArticulosCatalogo()]] · `calls` EXTRACTED
- llama a [[ArticulosBD.GetCategoriaById()]] · `calls` EXTRACTED
- llama a [[ArticulosBD.GetEstadoArticuloById()]] · `calls` EXTRACTED
- llama a [[ArticulosBD.GetImagenesArticulo()]] · `calls` EXTRACTED
- llama a [[IntercambiosBD.ArticuloComprometido()]] · `calls` EXTRACTED
- llama a [[IntercambiosBD.GetIdPropuestaEnCurso()]] · `calls` EXTRACTED
- llama a [[UsuariosBD.GetFotoUsuario()]] · `calls` EXTRACTED
- llama a [[UsuariosBD.GetProvinciaById()]] · `calls` EXTRACTED
- llama a [[UsuariosBD.GetUsuarioById()]] · `calls` EXTRACTED
- usa el tipo [[IActionResult]] · `references` EXTRACTED
- muestra la vista [[Vista Articulos-Detalle]] · `renders` INFERRED

**Desde otras notas:**
- [[Vista Intercambio-Detalle]] tiene un link acá · `links_to` EXTRACTED
- [[Vista _CardObjeto]] tiene un link acá · `links_to` EXTRACTED
- [[ArticulosController]] la tiene como método · `method` EXTRACTED
- [[IntercambioController.Proponer()]] redirige acá · `redirects_to` EXTRACTED
- [[PublicarController.Index() POST]] redirige acá · `redirects_to` EXTRACTED
