---
tipo: metodo
comunidad: "Controllers, vistas y JS"
archivos:
  - "Controllers/ChatController.cs"
graphify_ids:
  - "controllers_chatcontroller_swappit_controllers_chatcontroller_enviar"
tags:
  - tipo/metodo
  - comunidad/Controllers_vistas_y_JS
---
# ChatController.Enviar()

Método de [[ChatController]] · `Controllers/ChatController.cs` línea 106. Parámetros: `int,string?`.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- llama a [[BD.EnviarMensaje()]] · `calls` EXTRACTED
- redirige a [[AccountController.Index()]] · `redirects_to` EXTRACTED
- redirige a [[ChatController.Index()]] · `redirects_to` EXTRACTED
- usa el tipo [[HttpPost]] · `references` EXTRACTED
- usa el tipo [[IActionResult]] · `references` EXTRACTED
- usa el tipo [[ValidateAntiForgeryToken]] · `references` EXTRACTED

**Desde otras notas:**
- [[ChatController]] la tiene como método · `method` EXTRACTED
- [[Vista Chat-Index]] envía su formulario acá · `posts_to` EXTRACTED
