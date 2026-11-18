---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD/NotificacionesBD.cs"
graphify_ids:
  - "models_bd_notificacionesbd_swappit_models_notificacionesbd_getnotificaciones"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# NotificacionesBD.GetNotificaciones()

Método de `NotificacionesBD` ([[BD]]) · `Models/BD/NotificacionesBD.cs` línea 38. Parámetros: `int,int`.

Llama al SP [[SP GetNotificaciones]] con `CommandType.StoredProcedure`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- llama al SP [[SP GetNotificaciones]] · `calls_sp` EXTRACTED
- usa el tipo [[List]] · `references` EXTRACTED
- usa el tipo [[NotificacionViewModel]] · `references` EXTRACTED

**Desde otras notas:**
- [[NotificacionesController.Lista()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
