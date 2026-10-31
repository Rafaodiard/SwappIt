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

`Id` (PK), `Nombre` varchar(50). Cinco tipos: Propuesta recibida, Propuesta aceptada, Propuesta rechazada, Mensaje nuevo e Intercambio cancelado (el último lo agrega [[Script Cancelado.sql]] en bases viejas). Modelo: [[TipoNotificaciones]].

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)

**Desde otras notas:**
- [[Script Estructura.sql]] la contiene · `contains` EXTRACTED
- [[Script Notificaciones.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[TipoNotificaciones]] es su clase en C# · `maps_to` INFERRED
- [[BD.CrearNotificacion()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetNotificaciones()]] lee de acá · `reads_from` EXTRACTED
- [[BD.MarcarMensajesVistos()]] lee de acá · `reads_from` EXTRACTED
- [[BD.MarcarNotificacionLeida()]] lee de acá · `reads_from` EXTRACTED
- [[Tabla Notificaciones]] la usa como tipo · `references` EXTRACTED
