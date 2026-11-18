---
tipo: metodo
comunidad: "Controllers, vistas y JS"
archivos:
  - "Controllers/IntercambioController.cs"
graphify_ids:
  - "controllers_intercambiocontroller_swappit_controllers_intercambiocontroller_proponer"
tags:
  - tipo/metodo
  - comunidad/Controllers_vistas_y_JS
---
# IntercambioController.Proponer()

Método de [[IntercambioController]] · `Controllers/IntercambioController.cs` línea 100. Parámetros: `int,int`.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- llama a [[ArticulosBD.GetArticuloById()]] · `calls` EXTRACTED
- llama a [[IntercambiosBD.ArticuloComprometido()]] · `calls` EXTRACTED
- llama a [[IntercambiosBD.ContarIntercambiosActivos()]] · `calls` EXTRACTED
- llama a [[IntercambiosBD.ProponerIntercambio()]] · `calls` EXTRACTED
- llama a [[Listas]] · `calls` EXTRACTED
- redirige a [[AccountController.Index()]] · `redirects_to` EXTRACTED
- redirige a [[ArticulosController.Detalle()]] · `redirects_to` EXTRACTED
- redirige a [[IntercambioController.Detalle()]] · `redirects_to` EXTRACTED
- usa el tipo [[HttpPost]] · `references` EXTRACTED
- usa el tipo [[IActionResult]] · `references` EXTRACTED
- usa el tipo [[ValidateAntiForgeryToken]] · `references` EXTRACTED

**Desde otras notas:**
- [[Vista Articulos-Detalle]] tiene un link acá · `links_to` EXTRACTED
- [[IntercambioController]] la tiene como método · `method` EXTRACTED
