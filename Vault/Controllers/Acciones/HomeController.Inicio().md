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
- llama a [[ArticulosBD.ContarArticulosActivos()]] · `calls` EXTRACTED
- llama a [[ChatBD.ContarMensajesNoLeidos()]] · `calls` EXTRACTED
- llama a [[IntercambiosBD.ContarIntercambiosPorEstado()]] · `calls` EXTRACTED
- llama a [[IntercambiosBD.GetIntercambios()]] · `calls` EXTRACTED
- llama a [[RecomendacionesController]] · `calls` EXTRACTED
- llama a [[UsuariosBD.GetUsuarioById()]] · `calls` EXTRACTED
- usa el tipo [[IActionResult]] · `references` EXTRACTED

**Desde otras notas:**
- [[HomeController.Index()]] la llama · `calls` EXTRACTED
- [[HomeController]] la tiene como método · `method` EXTRACTED
