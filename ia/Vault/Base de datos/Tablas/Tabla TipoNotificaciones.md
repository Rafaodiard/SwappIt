---
tipo: tabla
comunidad: "Tablas y acceso a datos"
archivos:
  - "BaseDatos/Estructura.sql"
  - "BaseDatos/Notificaciones.sql"
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
graphify_ids:
  - "basedatos_estructura_dbo_tiponotificaciones"
  - "basedatos_notificaciones_dbo_tiponotificaciones"
  - "sqlswappit_dbo_tiponotificaciones"
  - "sqlswappit_cualquiercompu_dbo_tiponotificaciones"
tags:
  - tipo/tabla
  - comunidad/Tablas_y_acceso_a_datos
---
# Tabla TipoNotificaciones

`Id` (PK), `Nombre` varchar(50). Diez tipos: Propuesta recibida, Propuesta aceptada, Propuesta rechazada, Mensaje nuevo, Intercambio cancelado y, desde el 14/11, Artículo agregado, Pedido de artículo, Pedido para sacar, Cambio aceptado y Cambio rechazado ([[Tabla CambiosIntercambios]]). Modelo: [[TipoNotificaciones]].

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)

**Desde otras notas:**
- [[Script Estructura.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[TipoNotificaciones]] es su clase en C# · `maps_to` INFERRED
- [[SP CrearNotificacion]] lee de acá · `reads_from` EXTRACTED
- [[SP GetNotificaciones]] lee de acá · `reads_from` EXTRACTED
- [[SP MarcarMensajesVistos]] lee de acá · `reads_from` EXTRACTED
- [[SP MarcarNotificacionLeida]] lee de acá · `reads_from` EXTRACTED
- [[Tabla Notificaciones]] la usa como tipo · `references` EXTRACTED
