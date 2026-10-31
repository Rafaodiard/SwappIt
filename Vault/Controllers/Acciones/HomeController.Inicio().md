---
tipo: metodo
comunidad: "Controllers, vistas y JS"
archivos:
  - "Controllers/HomeController.cs"
graphify_ids:
  - "controllers_homecontroller_swappit_controllers_homecontroller_inicio"
tags:
  - tipo/metodo
  - comunidad/Controllers_vistas_y_JS
---
# HomeController.Inicio()

Método de [[HomeController]] · `Controllers/HomeController.cs` línea 41. Parámetros: `int`.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- llama a [[BD.GetArticulosCatalogo()]] · `calls` EXTRACTED
- llama a [[BD.GetIntercambios()]] · `calls` EXTRACTED
- llama a [[BD.GetResumenesChat()]] · `calls` EXTRACTED
- llama a [[BD.GetUsuarioById()]] · `calls` EXTRACTED
- usa el tipo [[IActionResult]] · `references` EXTRACTED
- muestra la vista [[Vista Home-Inicio]] · `renders` EXTRACTED

**Desde otras notas:**
- [[HomeController.Index()]] la llama · `calls` EXTRACTED
- [[HomeController]] la tiene como método · `method` EXTRACTED
