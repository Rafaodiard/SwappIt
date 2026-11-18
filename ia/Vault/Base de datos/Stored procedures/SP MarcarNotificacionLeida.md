---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_marcarnotificacionleida"
  - "sqlswappit_cualquiercompu_dbo_marcarnotificacionleida"
  - "basedatos_storedprocedures_dbo_marcarnotificacionleida"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP MarcarNotificacionLeida

Stored procedure `dbo.MarcarNotificacionLeida`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Marca una notificación como leída y devuelve a qué intercambio lleva.

Nuevo del 17/11 (devolución docente: todo el acceso a datos por SP).

Lo llama [[NotificacionesBD.MarcarNotificacionLeida()]].

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla TipoNotificaciones]] · `reads_from` EXTRACTED
- escribe en [[Tabla Notificaciones]] · `writes_to` EXTRACTED

**Desde otras notas:**
- [[NotificacionesBD.MarcarNotificacionLeida()]] lo llama · `calls_sp` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
