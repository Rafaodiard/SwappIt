---
tipo: vista
comunidad: "Namespaces y formularios"
archivos:
  - "Views/Notificaciones/_Lista.cshtml"
graphify_ids:
  - "views_notificaciones_lista"
  - "views_notificaciones_lista_cshtml_notificacionviewmodel"
  - "views_notificaciones_lista_hace"
tags:
  - tipo/vista
  - comunidad/Namespaces_y_formularios
---
# Vista: Notificaciones / _Lista (partial)

`Views/Notificaciones/_Lista.cshtml` · Contenido del pop up de notificaciones: lo devuelve [[NotificacionesController]].Lista y [[notificaciones.js]] lo pone dentro de [[Vista _PopupNotificaciones]] cada vez que se abre. "Nuevas" (sin leer) y "Anteriores"; cada una tiene un form a `Ver` que la marca como leída y lleva al intercambio (o al chat). Recibe una lista de [[NotificacionViewModel]].

Comunidad del grafo: [[Comunidad - Namespaces y formularios]]

## Conexiones en el grafo (graphify)
- importa [[Namespace Swappit.Models.ViewModels]] · `imports` EXTRACTED
- tiene un link a [[NotificacionesController.Ver()]] · `links_to` EXTRACTED

**Desde otras notas:**
- [[NotificacionesController.Lista()]] muestra esta vista · `renders` EXTRACTED
