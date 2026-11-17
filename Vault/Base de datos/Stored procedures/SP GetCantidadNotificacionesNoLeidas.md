---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_getcantidadnotificacionesnoleidas"
  - "sqlswappit_cualquiercompu_dbo_getcantidadnotificacionesnoleidas"
  - "basedatos_storedprocedures_dbo_getcantidadnotificacionesnoleidas"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP GetCantidadNotificacionesNoLeidas

Stored procedure `dbo.GetCantidadNotificacionesNoLeidas`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Stored procedure de la app.

Lo llama [[NotificacionesBD.GetCantidadNotificacionesNoLeidas()]].

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Notificaciones]] · `reads_from` EXTRACTED

**Desde otras notas:**
- [[NotificacionesBD.GetCantidadNotificacionesNoLeidas()]] lo llama · `calls_sp` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
