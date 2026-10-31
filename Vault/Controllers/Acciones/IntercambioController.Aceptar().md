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
- llama a [[BD.ContarPendientesDeArticulos()]] · `calls` EXTRACTED
- llama a [[IntercambioController.CambiarEstado()]] · `calls` EXTRACTED
- usa el tipo [[HttpPost]] · `references` EXTRACTED
- usa el tipo [[IActionResult]] · `references` EXTRACTED
- usa el tipo [[ValidateAntiForgeryToken]] · `references` EXTRACTED

**Desde otras notas:**
- [[IntercambioController]] la tiene como método · `method` EXTRACTED
- [[Vista Intercambio-Detalle]] envía su formulario acá · `posts_to` EXTRACTED
