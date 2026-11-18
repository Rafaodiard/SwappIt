---
tipo: metodo
comunidad: "Controllers, vistas y JS"
archivos:
  - "Controllers/ChatController.cs"
graphify_ids:
  - "controllers_chatcontroller_swappit_controllers_chatcontroller_index"
tags:
  - tipo/metodo
  - comunidad/Controllers_vistas_y_JS
---
# ChatController.Index()

Método de [[ChatController]] · `Controllers/ChatController.cs` línea 24. Parámetros: `int?`.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- llama a [[ChatBD.GetMensajes()]] · `calls` EXTRACTED
- llama a [[ChatBD.GetResumenesChat()]] · `calls` EXTRACTED
- llama a [[ChatBD.MarcarMensajesVistos()]] · `calls` EXTRACTED
- llama a [[ChatController.PuedeEscribir()]] · `calls` EXTRACTED
- llama a [[IntercambiosBD.GetIntercambio()]] · `calls` EXTRACTED
- llama a [[IntercambiosBD.GetIntercambios()]] · `calls` EXTRACTED
- llama a [[UsuariosBD.GetFotoUsuario()]] · `calls` EXTRACTED
- redirige a [[AccountController.Index()]] · `redirects_to` EXTRACTED
- usa el tipo [[IActionResult]] · `references` EXTRACTED

**Desde otras notas:**
- [[Vista Chat-Index]] tiene un link acá · `links_to` EXTRACTED
- [[Vista Home-Inicio]] tiene un link acá · `links_to` EXTRACTED
- [[Vista Intercambio-Detalle]] tiene un link acá · `links_to` EXTRACTED
- [[Vista _Layout]] tiene un link acá · `links_to` EXTRACTED
- [[ChatController]] la tiene como método · `method` EXTRACTED
- [[ChatController.Enviar()]] redirige acá · `redirects_to` EXTRACTED
- [[NotificacionesController.Ver()]] redirige acá · `redirects_to` EXTRACTED
