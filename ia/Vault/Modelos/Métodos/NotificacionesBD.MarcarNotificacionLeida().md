---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD/NotificacionesBD.cs"
graphify_ids:
  - "models_bd_notificacionesbd_swappit_models_notificacionesbd_marcarnotificacionleida"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# NotificacionesBD.MarcarNotificacionLeida()

Método de `NotificacionesBD` ([[BD]]) · `Models/BD/NotificacionesBD.cs` línea 58. Parámetros: `int,int`.

Llama al SP [[SP MarcarNotificacionLeida]] con `CommandType.StoredProcedure`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- llama al SP [[SP MarcarNotificacionLeida]] · `calls_sp` EXTRACTED
- usa el tipo [[NotificacionViewModel]] · `references` EXTRACTED

**Desde otras notas:**
- [[NotificacionesController.Ver()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
