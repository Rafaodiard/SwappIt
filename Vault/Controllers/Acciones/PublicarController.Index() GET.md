---
tipo: metodo
comunidad: "Controllers, vistas y JS"
archivos:
  - "Controllers/PublicarController.cs"
graphify_ids:
  - "controllers_publicarcontroller_swappit_controllers_publicarcontroller_index"
tags:
  - tipo/metodo
  - comunidad/Controllers_vistas_y_JS
---
# PublicarController.Index() GET

Método de [[PublicarController]] · `Controllers/PublicarController.cs` línea 25.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- llama a [[BD.GetUsuarioById()]] · `calls` EXTRACTED
- llama a [[PublicarArticuloViewModel]] · `calls` INFERRED
- llama a [[PublicarController.ObtenerCategorias()]] · `calls` EXTRACTED
- llama a [[PublicarController.ObtenerEstados()]] · `calls` EXTRACTED
- redirige a [[AccountController.Index()]] · `redirects_to` EXTRACTED
- usa el tipo [[HttpGet]] · `references` EXTRACTED
- usa el tipo [[IActionResult]] · `references` EXTRACTED
- muestra la vista [[Vista Publicar-Index]] · `renders` INFERRED

**Desde otras notas:**
- [[Vista _Layout]] tiene un link acá · `links_to` EXTRACTED
- [[Vista Articulos-Detalle]] tiene un link acá · `links_to` EXTRACTED
- [[Vista Home-Inicio]] tiene un link acá · `links_to` EXTRACTED
- [[Vista Perfil-Index]] tiene un link acá · `links_to` EXTRACTED
- [[PublicarController]] la tiene como método · `method` EXTRACTED
