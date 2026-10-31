---
tipo: metodo
comunidad: "Controllers, vistas y JS"
archivos:
  - "Controllers/IntercambioController.cs"
graphify_ids:
  - "controllers_intercambiocontroller_swappit_controllers_intercambiocontroller_index"
tags:
  - tipo/metodo
  - comunidad/Controllers_vistas_y_JS
---
# IntercambioController.Index()

Método de [[IntercambioController]] · `Controllers/IntercambioController.cs` línea 25. Parámetros: `string?`.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- llama a [[BD.GetEstadosIntercambios()]] · `calls` EXTRACTED
- llama a [[BD.GetIntercambios()]] · `calls` EXTRACTED
- redirige a [[AccountController.Index()]] · `redirects_to` EXTRACTED
- usa el tipo [[IActionResult]] · `references` EXTRACTED
- muestra la vista [[Vista Intercambio-Index]] · `renders` INFERRED

**Desde otras notas:**
- [[Vista Home-Inicio]] tiene un link acá · `links_to` EXTRACTED
- [[Vista Intercambio-Detalle]] tiene un link acá · `links_to` EXTRACTED
- [[Vista Intercambio-Index]] tiene un link acá · `links_to` EXTRACTED
- [[Vista Perfil-Index]] tiene un link acá · `links_to` EXTRACTED
- [[IntercambioController]] la tiene como método · `method` EXTRACTED
- [[NotificacionesController.Ver()]] redirige acá · `redirects_to` EXTRACTED
