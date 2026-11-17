---
tipo: metodo
comunidad: "Controllers, vistas y JS"
archivos:
  - "Controllers/IntercambioController.cs"
graphify_ids:
  - "controllers_intercambiocontroller_swappit_controllers_intercambiocontroller_aceptar"
tags:
  - tipo/metodo
  - comunidad/Controllers_vistas_y_JS
---
# IntercambioController.Aceptar()

Método de [[IntercambioController]] · `Controllers/IntercambioController.cs` línea 163. Parámetros: `int`.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- llama a [[IntercambioController.CambiarEstado()]] · `calls` EXTRACTED
- llama a [[IntercambiosBD.ContarCambiosPendientes()]] · `calls` EXTRACTED
- llama a [[IntercambiosBD.ContarPendientesDeArticulos()]] · `calls` EXTRACTED
- llama a [[IntercambiosBD.GetIntercambio()]] · `calls` EXTRACTED
- llama a [[IntercambiosBD.GetUltimoCambio()]] · `calls` EXTRACTED
- redirige a [[AccountController.Index()]] · `redirects_to` EXTRACTED
- redirige a [[IntercambioController.Detalle()]] · `redirects_to` EXTRACTED
- usa el tipo [[HttpPost]] · `references` EXTRACTED
- usa el tipo [[IActionResult]] · `references` EXTRACTED
- usa el tipo [[ValidateAntiForgeryToken]] · `references` EXTRACTED

**Desde otras notas:**
- [[Vista Intercambio-Detalle]] tiene un link acá · `links_to` EXTRACTED
- [[IntercambioController]] la tiene como método · `method` EXTRACTED
