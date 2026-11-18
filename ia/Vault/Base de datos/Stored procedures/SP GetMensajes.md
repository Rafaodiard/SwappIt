---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_getmensajes"
  - "sqlswappit_cualquiercompu_dbo_getmensajes"
  - "basedatos_storedprocedures_dbo_getmensajes"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP GetMensajes

Stored procedure `dbo.GetMensajes`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Mensajes de un intercambio, si el usuario es parte.

Nuevo del 17/11 (devolución docente: todo el acceso a datos por SP).

Lo llama [[ChatBD.GetMensajes()]].

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Intercambios]] · `reads_from` EXTRACTED
- lee de [[Tabla Mensajes]] · `reads_from` EXTRACTED

**Desde otras notas:**
- [[ChatBD.GetMensajes()]] lo llama · `calls_sp` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
