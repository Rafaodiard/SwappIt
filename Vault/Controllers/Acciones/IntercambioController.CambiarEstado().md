---
tipo: metodo
comunidad: "Controllers, vistas y JS"
archivos:
  - "Controllers/IntercambioController.cs"
graphify_ids:
  - "controllers_intercambiocontroller_swappit_controllers_intercambiocontroller_cambiarestado"
tags:
  - tipo/metodo
  - comunidad/Controllers_vistas_y_JS
---
# IntercambioController.CambiarEstado()

Método de [[IntercambioController]] · `Controllers/IntercambioController.cs` línea 237. Parámetros: `int,string,string,bool,string?,string`.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- llama a [[BD.CambiarEstadoIntercambio()]] · `calls` EXTRACTED
- redirige a [[AccountController.Index()]] · `redirects_to` EXTRACTED
- redirige a [[IntercambioController.Detalle()]] · `redirects_to` EXTRACTED
- usa el tipo [[IActionResult]] · `references` EXTRACTED

**Desde otras notas:**
- [[IntercambioController.Aceptar()]] la llama · `calls` EXTRACTED
- [[IntercambioController.MarcarRealizado()]] la llama · `calls` EXTRACTED
- [[IntercambioController.Rechazar()]] la llama · `calls` EXTRACTED
- [[IntercambioController]] la tiene como método · `method` EXTRACTED
