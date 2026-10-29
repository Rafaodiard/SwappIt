---
tipo: metodo
comunidad: "Publicar artículo"
archivos:
  - "Controllers/PublicarController.cs"
graphify_ids:
  - "controllers_publicarcontroller_swappit_controllers_publicarcontroller_index_38b2b6"
tags:
  - tipo/metodo
  - comunidad/Publicar_artículo
---
# PublicarController.Index() POST

Método de [[PublicarController]] · `Controllers/PublicarController.cs` línea 51. Parámetros: `PublicarArticuloViewModel`.

Comunidad del grafo: [[Comunidad - Publicar artículo]]

## Conexiones en el grafo (graphify)
- llama a [[Articulos]] · `calls` INFERRED
- llama a [[BD.PublicarArticulo()]] · `calls` EXTRACTED
- llama a [[PublicarController.AvisarFotosDeNuevo()]] · `calls` EXTRACTED
- llama a [[PublicarController.BorrarFotosArticulo()]] · `calls` EXTRACTED
- llama a [[PublicarController.GuardarFotosArticulo()]] · `calls` EXTRACTED
- llama a [[PublicarController.ObtenerCategorias()]] · `calls` EXTRACTED
- llama a [[PublicarController.ObtenerEstados()]] · `calls` EXTRACTED
- llama a [[PublicarController.ValidarFotos()]] · `calls` EXTRACTED
- redirige a [[AccountController.Index()]] · `redirects_to` EXTRACTED
- redirige a [[ArticulosController.Detalle()]] · `redirects_to` EXTRACTED
- usa el tipo [[HttpPost]] · `references` EXTRACTED
- usa el tipo [[IActionResult]] · `references` EXTRACTED
- usa el tipo [[PublicarArticuloViewModel]] · `references` EXTRACTED
- usa el tipo [[RequestFormLimits]] · `references` EXTRACTED
- usa el tipo [[RequestSizeLimit]] · `references` EXTRACTED
- usa el tipo [[ValidateAntiForgeryToken]] · `references` EXTRACTED

**Desde otras notas:**
- [[PublicarController]] la tiene como método · `method` EXTRACTED
- [[Vista Publicar-Index]] envía su formulario acá · `posts_to` EXTRACTED
