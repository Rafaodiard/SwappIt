---
tipo: vista
comunidad: "Controllers, vistas y JS"
archivos:
  - "Views/Shared/_CardObjeto.cshtml"
graphify_ids:
  - "views_shared_cardobjeto"
tags:
  - tipo/vista
  - comunidad/Controllers_vistas_y_JS
---
# Vista: _CardObjeto (partial)

`Views/Shared/_CardObjeto.cshtml` · Card de un artículo (componente "10. Card" del UI Kit). Recibe un [[ArticuloCardViewModel]] en `ViewBag.articulo` (antes de cada `<partial name="_CardObjeto" />`). Muestra foto (o el fondo de `.sw-img`), estado, botón de favorito ([[favoritos.js]]), nombre con link a Detalle (`stretched-link`: toda la card es clickeable) y barrio. Mantiene `data-template="card-objeto"` para `swappit.renderObjetos` de [[plantillas.js]]. Pendiente en el comentario: distancia y "Busca a cambio".

La usan [[Vista Home-Index]], [[Vista Articulos-Buscar]], [[Vista Articulos-Detalle]], [[Vista Perfil-Index]] y [[Vista Perfil-Publico]].

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- tiene un link a [[ArticulosController.Detalle()]] · `links_to` EXTRACTED

**Desde otras notas:**
- [[Vista Articulos-Buscar]] incluye este partial · `includes` EXTRACTED
- [[Vista Articulos-Detalle]] incluye este partial · `includes` EXTRACTED
- [[Vista Home-Index]] incluye este partial · `includes` EXTRACTED
- [[Vista Perfil-Index]] incluye este partial · `includes` EXTRACTED
- [[Vista Perfil-Publico]] incluye este partial · `includes` EXTRACTED
