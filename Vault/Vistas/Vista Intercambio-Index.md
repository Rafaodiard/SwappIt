---
tipo: vista
comunidad: "Controllers, vistas y JS"
archivos:
  - "Views/Intercambio/Index.cshtml"
graphify_ids:
  - "views_intercambio_index"
tags:
  - tipo/vista
  - comunidad/Controllers_vistas_y_JS
---
# Vista: Intercambio / Index

`Views/Intercambio/Index.cshtml` · [[IntercambioController]].Index. Mis intercambios: propuestas enviadas y recibidas. Los filtros son links (`?estado=Pendiente`) con la cantidad de cada estado de [[Tabla EstadosIntercambios]]. Cada intercambio es una [[Vista _FilaIntercambio]].

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- incluye el partial [[Vista _FilaIntercambio]] · `includes` EXTRACTED
- tiene un link a [[ArticulosController.Buscar()]] · `links_to` EXTRACTED
- tiene un link a [[IntercambioController.Index()]] · `links_to` EXTRACTED

**Desde otras notas:**
- [[IntercambioController.Index()]] muestra esta vista · `renders` INFERRED
