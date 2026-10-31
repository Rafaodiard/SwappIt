---
tipo: tabla
comunidad: "Tablas y acceso a datos"
archivos:
  - "BaseDatos/Estructura.sql"
  - "BaseDatos/Notificaciones.sql"
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
graphify_ids:
  - "basedatos_estructura_dbo_notificaciones"
  - "basedatos_notificaciones_dbo_notificaciones"
  - "sqlswappit_dbo_notificaciones"
  - "sqlswappit_cualquiercompu_dbo_notificaciones"
tags:
  - tipo/tabla
  - comunidad/Tablas_y_acceso_a_datos
---
# Tabla Notificaciones

`Id` (PK), `IdUsuario` (a quién le llega, FK → [[Tabla Usuarios]]), `IdIntercambio` (FK → [[Tabla Intercambios]]), `IdTipoNotificacion` (FK → [[Tabla TipoNotificaciones]]), `Leida` bit, `Fecha` datetime. Se crean dentro de la transacción de cada acción de intercambio o chat (`CrearNotificacion` en [[BD]]). Para bases ya creadas: [[Script Notificaciones.sql]].

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- usa el tipo [[Tabla Provincias]] · `references` EXTRACTED
- usa el tipo [[Tabla TipoNotificaciones]] · `references` EXTRACTED
- usa el tipo [[Tabla Usuarios]] · `references` EXTRACTED

**Desde otras notas:**
- [[Script Estructura.sql]] la contiene · `contains` EXTRACTED
- [[Script Notificaciones.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[BD.GetCantidadNotificacionesNoLeidas()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetNotificaciones()]] lee de acá · `reads_from` EXTRACTED
- [[BD.CrearNotificacion()]] escribe acá · `writes_to` EXTRACTED
- [[BD.MarcarMensajesVistos()]] escribe acá · `writes_to` EXTRACTED
- [[BD.MarcarNotificacionesLeidas()]] escribe acá · `writes_to` EXTRACTED
- [[BD.MarcarNotificacionLeida()]] escribe acá · `writes_to` EXTRACTED
