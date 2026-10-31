---
tipo: vista
comunidad: "Controllers, vistas y JS"
archivos:
  - "Views/Shared/_PopupNotificaciones.cshtml"
graphify_ids:
  - "views_shared_popupnotificaciones"
tags:
  - tipo/vista
  - comunidad/Controllers_vistas_y_JS
---
# Vista: _PopupNotificaciones (partial)

`Views/Shared/_PopupNotificaciones.cshtml` · Pop up de la campana del header ([[Vista _Layout]]). Es el marco: [[notificaciones.js]] lo abre y lo cierra y, cada vez que se abre, pide la lista a [[NotificacionesController]].Lista ([[Vista Notificaciones-_Lista]]) y la pone en `[data-notif-contenido]`. Tiene el form oculto "Marcar todas como leídas" (POST a `MarcarTodasLeidas`, lo manda notificaciones.js por fetch).

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- envía el formulario a [[NotificacionesController.MarcarTodasLeidas()]] · `posts_to` EXTRACTED

**Desde otras notas:**
- [[Vista _Layout]] incluye este partial · `includes` EXTRACTED
