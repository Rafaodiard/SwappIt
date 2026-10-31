---
tipo: vista
comunidad: "Controllers, vistas y JS"
archivos:
  - "Views/Articulos/Detalle.cshtml"
graphify_ids:
  - "views_articulos_detalle"
tags:
  - tipo/vista
  - comunidad/Controllers_vistas_y_JS
---
# Vista: Articulos / Detalle

`Views/Articulos/Detalle.cshtml` · [[ArticulosController]].Detalle ([[Flujo Ver detalle de artículo]]).

- Artículo inexistente o error de base: tarjeta con aviso y "Ver otros artículos".
- Mensaje de éxito al venir de Publicar (`TempData["MensajeArticulo"]`).
- Migas de pan (Artículos › Categoría › Nombre), galería con miniaturas ([[articulo.js]]), estado, categoría, título, ubicación, descripción, "Busca a cambio", "Publicado por" (link al perfil), acciones según quién mira, "Más artículos de …" ([[Vista _CardObjeto]]).
- Pop up **Proponer intercambio**: radios con los artículos del usuario logueado; POST a [[IntercambioController]].Proponer ([[Flujo Proponer intercambio]]). Si ya hay una propuesta en curso por este artículo, el botón pasa a "Propuesta enviada" (lleva al intercambio). Los errores de Proponer llegan en `TempData["ErrorArticulo"]`.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- incluye el partial [[Vista _CardObjeto]] · `includes` EXTRACTED
- tiene un link a [[AccountController.Index()]] · `links_to` EXTRACTED
- tiene un link a [[ArticulosController.Buscar()]] · `links_to` EXTRACTED
- tiene un link a [[IntercambioController.Detalle()]] · `links_to` EXTRACTED
- tiene un link a [[PerfilController.Index()]] · `links_to` EXTRACTED
- tiene un link a [[PerfilController.Publico()]] · `links_to` EXTRACTED
- tiene un link a [[PublicarController.Index() GET]] · `links_to` EXTRACTED
- carga el script [[articulo.js]] · `loads_script` EXTRACTED
- envía el formulario a [[IntercambioController.Proponer()]] · `posts_to` EXTRACTED

**Desde otras notas:**
- [[ArticulosController.Detalle()]] muestra esta vista · `renders` INFERRED
