---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD.cs"
graphify_ids:
  - "models_bd_swappit_models_bd_marcarnotificacionleida"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# BD.MarcarNotificacionLeida()

Método de [[BD]] · `Models/BD.cs` línea 605. Parámetros: `int,int`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla TipoNotificaciones]] · `reads_from` EXTRACTED
- usa el tipo [[NotificacionViewModel]] · `references` EXTRACTED
- escribe en [[Tabla Notificaciones]] · `writes_to` EXTRACTED

**Desde otras notas:**
- [[NotificacionesController.Ver()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
