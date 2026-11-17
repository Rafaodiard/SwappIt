---
tipo: metodo
comunidad: "Controllers, vistas y JS"
archivos:
  - "Controllers/IntercambioController.cs"
graphify_ids:
  - "controllers_intercambiocontroller_swappit_controllers_intercambiocontroller_detalle"
tags:
  - tipo/metodo
  - comunidad/Controllers_vistas_y_JS
---
# IntercambioController.Detalle()

Método de [[IntercambioController]] · `Controllers/IntercambioController.cs` línea 59. Parámetros: `int`.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- llama a [[ArticulosBD.GetArticulosCatalogo()]] · `calls` EXTRACTED
- llama a [[IntercambiosBD.ContarPendientesDeArticulos()]] · `calls` EXTRACTED
- llama a [[IntercambiosBD.GetArticulosDeIntercambio()]] · `calls` EXTRACTED
- llama a [[IntercambiosBD.GetCambiosIntercambio()]] · `calls` EXTRACTED
- llama a [[IntercambiosBD.GetIntercambio()]] · `calls` EXTRACTED
- llama a [[IntercambiosBD.IntercambioConArticuloComprometido()]] · `calls` EXTRACTED
- llama a [[UsuariosBD.GetFotoUsuario()]] · `calls` EXTRACTED
- redirige a [[AccountController.Index()]] · `redirects_to` EXTRACTED
- usa el tipo [[IActionResult]] · `references` EXTRACTED
- muestra la vista [[Vista Intercambio-Detalle]] · `renders` INFERRED

**Desde otras notas:**
- [[Vista Articulos-Detalle]] tiene un link acá · `links_to` EXTRACTED
- [[Vista Chat-Index]] tiene un link acá · `links_to` EXTRACTED
- [[Vista Home-Inicio]] tiene un link acá · `links_to` EXTRACTED
- [[Vista _FilaIntercambio]] tiene un link acá · `links_to` EXTRACTED
- [[IntercambioController]] la tiene como método · `method` EXTRACTED
- [[IntercambioController.Aceptar()]] redirige acá · `redirects_to` EXTRACTED
- [[IntercambioController.Cancelar()]] redirige acá · `redirects_to` EXTRACTED
- [[IntercambioController.MarcarRealizado()]] redirige acá · `redirects_to` EXTRACTED
- [[IntercambioController.Proponer()]] redirige acá · `redirects_to` EXTRACTED
- [[NotificacionesController.Ver()]] redirige acá · `redirects_to` EXTRACTED
