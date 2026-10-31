---
tipo: metodo
comunidad: "Controllers, vistas y JS"
archivos:
  - "Controllers/HomeController.cs"
graphify_ids:
  - "controllers_homecontroller_swappit_controllers_homecontroller_index"
tags:
  - tipo/metodo
  - comunidad/Controllers_vistas_y_JS
---
# HomeController.Index()

Método de [[HomeController]] · `Controllers/HomeController.cs` línea 19.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- llama a [[BD.GetArticulosCatalogo()]] · `calls` EXTRACTED
- llama a [[HomeController.Inicio()]] · `calls` EXTRACTED
- usa el tipo [[IActionResult]] · `references` EXTRACTED
- muestra la vista [[Vista Home-Index]] · `renders` INFERRED

**Desde otras notas:**
- [[Vista _Layout]] tiene un link acá · `links_to` EXTRACTED
- [[Vista Error]] tiene un link acá · `links_to` EXTRACTED
- [[Vista Publicar-Index]] tiene un link acá · `links_to` EXTRACTED
- [[HomeController]] la tiene como método · `method` EXTRACTED
- [[AccountController.Login()]] redirige acá · `redirects_to` EXTRACTED
- [[AccountController.Registro() POST]] redirige acá · `redirects_to` EXTRACTED
