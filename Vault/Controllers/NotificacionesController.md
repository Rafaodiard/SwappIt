---
tipo: controller
comunidad: "Controllers, vistas y JS"
archivos:
  - "Controllers/NotificacionesController.cs"
graphify_ids:
  - "controllers_notificacionescontroller_swappit_controllers_notificacionescontroller"
  - "controllers_notificacionescontroller"
tags:
  - tipo/controller
  - comunidad/Controllers_vistas_y_JS
---
# NotificacionesController

`Controllers/NotificacionesController.cs` · Notificaciones del pop up de la campana ([[Vista _PopupNotificaciones]]). Lo usa [[notificaciones.js]]:
- `Lista()` → partial [[Vista Notificaciones-_Lista]] con las 20 más nuevas (se pide cada vez que se abre el pop up).
- `NoLeidas()` → JSON `{ cantidad }` para el contador de la campana.
- `Ver(id)` (POST): la marca como leída y redirige al intercambio, o al chat si es "Mensaje nuevo".
- `MarcarTodasLeidas()` (POST, por fetch).

Las notificaciones se crean en [[BD.ProponerIntercambio()]], [[BD.CambiarEstadoIntercambio()]], [[BD.CancelarIntercambio()]] y [[BD.EnviarMensaje()]]. Ver [[Flujo Notificaciones y favoritos]].

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Controllers]] · `contains` EXTRACTED
- importa [[Microsoft.AspNetCore.Mvc]] · `imports` EXTRACTED
- importa [[Microsoft.Data.SqlClient]] · `imports` EXTRACTED
- importa [[Namespace Swappit.Models]] · `imports` EXTRACTED
- importa [[Namespace Swappit.Models.ViewModels]] · `imports` EXTRACTED
- hereda de [[Controller (ASP.NET MVC)]] · `inherits` EXTRACTED
- tiene el método [[NotificacionesController.Lista()]] · `method` EXTRACTED
- tiene el método [[NotificacionesController.MarcarTodasLeidas()]] · `method` EXTRACTED
- tiene el método [[NotificacionesController.NoLeidas()]] · `method` EXTRACTED
- tiene el método [[NotificacionesController.Ver()]] · `method` EXTRACTED
- usa el tipo [[ILogger]] · `references` EXTRACTED
