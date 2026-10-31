---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD.cs"
graphify_ids:
  - "models_bd_swappit_models_bd_getnotificaciones"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# BD.GetNotificaciones()

Método de [[BD]] · `Models/BD.cs` línea 577. Parámetros: `int,int`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Articulos]] · `reads_from` EXTRACTED
- lee de [[Tabla Intercambios]] · `reads_from` EXTRACTED
- lee de [[Tabla Notificaciones]] · `reads_from` EXTRACTED
- lee de [[Tabla TipoNotificaciones]] · `reads_from` EXTRACTED
- lee de [[Tabla Usuarios]] · `reads_from` EXTRACTED
- usa el tipo [[List]] · `references` EXTRACTED
- usa el tipo [[NotificacionViewModel]] · `references` EXTRACTED

**Desde otras notas:**
- [[NotificacionesController.Lista()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
