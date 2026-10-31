---
tipo: vista
comunidad: "Controllers, vistas y JS"
archivos:
  - "Views/Shared/_FilaIntercambio.cshtml"
graphify_ids:
  - "views_shared_filaintercambio"
tags:
  - tipo/vista
  - comunidad/Controllers_vistas_y_JS
---
# Vista: _FilaIntercambio (partial)

`Views/Shared/_FilaIntercambio.cshtml` · Fila de un intercambio: recibe un [[IntercambioViewModel]] en `ViewBag.fila`. Arriba lo que recibe el usuario y abajo (con las flechas) lo que da, la otra persona, la fecha, el estado y un botón "Responder" (si le llegó y está Pendiente) o "Ver intercambio". La usan [[Vista Intercambio-Index]] y el historial de [[Vista Perfil-Index]].

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- tiene un link a [[IntercambioController.Detalle()]] · `links_to` EXTRACTED

**Desde otras notas:**
- [[Vista Intercambio-Index]] incluye este partial · `includes` EXTRACTED
- [[Vista Perfil-Index]] incluye este partial · `includes` EXTRACTED
