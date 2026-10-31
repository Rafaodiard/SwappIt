---
tipo: metodo
comunidad: "Controllers, vistas y JS"
archivos:
  - "Controllers/ChatController.cs"
graphify_ids:
  - "controllers_chatcontroller_swappit_controllers_chatcontroller_mensajes"
tags:
  - tipo/metodo
  - comunidad/Controllers_vistas_y_JS
---
# ChatController.Mensajes()

Método de [[ChatController]] · `Controllers/ChatController.cs` línea 84. Parámetros: `int`.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- llama a [[BD.GetMensajes()]] · `calls` EXTRACTED
- llama a [[BD.MarcarMensajesVistos()]] · `calls` EXTRACTED
- usa el tipo [[IActionResult]] · `references` EXTRACTED
- muestra la vista [[Vista Chat-_Mensajes]] · `renders` EXTRACTED

**Desde otras notas:**
- [[Vista Chat-Index]] tiene un link acá · `links_to` EXTRACTED
- [[ChatController]] la tiene como método · `method` EXTRACTED
