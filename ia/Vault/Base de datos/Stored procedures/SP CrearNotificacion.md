---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_crearnotificacion"
  - "sqlswappit_cualquiercompu_dbo_crearnotificacion"
  - "basedatos_storedprocedures_dbo_crearnotificacion"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP CrearNotificacion

Stored procedure `dbo.CrearNotificacion`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Ayudante de otros SP: inserta una notificación buscando el tipo por nombre y, si el SP que lo llamó creó la tabla temporal `#Creadas`, la anota ahí para que C# mande el mail. Con `@siNoHayOtraSinLeer = 1` no repite la notificación si ya hay una igual sin leer (la usa "Mensaje nuevo").

Nuevo del 17/11 (devolución docente: todo el acceso a datos por SP).

Lo ejecutan los SP [[SP AgregarArticulos]], [[SP CambiarEstadoIntercambio]], [[SP CancelarIntercambio]], [[SP CrearPedido]], [[SP EnviarMensaje]], [[SP ProponerIntercambio]], [[SP RechazarPendientesDeArticulos]], [[SP ResponderCambio]].

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla TipoNotificaciones]] · `reads_from` EXTRACTED
- escribe en [[Tabla Notificaciones]] · `writes_to` EXTRACTED

**Desde otras notas:**
- [[SP AgregarArticulos]] la llama · `calls` EXTRACTED
- [[SP CambiarEstadoIntercambio]] la llama · `calls` EXTRACTED
- [[SP CancelarIntercambio]] la llama · `calls` EXTRACTED
- [[SP CrearPedido]] la llama · `calls` EXTRACTED
- [[SP EnviarMensaje]] la llama · `calls` EXTRACTED
- [[SP ProponerIntercambio]] la llama · `calls` EXTRACTED
- [[SP RechazarPendientesDeArticulos]] la llama · `calls` EXTRACTED
- [[SP ResponderCambio]] la llama · `calls` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
