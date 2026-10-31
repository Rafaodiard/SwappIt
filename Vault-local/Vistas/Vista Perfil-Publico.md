---
tipo: vista
comunidad: "Controllers, vistas y JS"
archivos:
  - "Views/Perfil/Publico.cshtml"
graphify_ids:
  - "views_perfil_publico"
tags:
  - tipo/vista
  - comunidad/Controllers_vistas_y_JS
---
# Vista: Perfil / Publico

`Views/Perfil/Publico.cshtml` · [[PerfilController]].Publico ([[Flujo Perfil público]]). Solo datos públicos: foto, nombre, @usuario, descripción, ubicación, cantidad de artículos y sus cards ([[Vista _CardObjeto]]). Sin mail, teléfono ni edad. TODO en el código: reputación e intercambios realizados.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- incluye el partial [[Vista _CardObjeto]] · `includes` EXTRACTED
- tiene un link a [[ArticulosController.Buscar()]] · `links_to` EXTRACTED

**Desde otras notas:**
- [[PerfilController.Publico()]] muestra esta vista · `renders` INFERRED
