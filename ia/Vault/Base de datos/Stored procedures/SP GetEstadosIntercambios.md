---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_getestadosintercambios"
  - "sqlswappit_cualquiercompu_dbo_getestadosintercambios"
  - "basedatos_storedprocedures_dbo_getestadosintercambios"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP GetEstadosIntercambios

Stored procedure `dbo.GetEstadosIntercambios`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Stored procedure de la app.

Lo llama [[IntercambiosBD.GetEstadosIntercambios()]].

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla EstadosIntercambios]] · `reads_from` EXTRACTED

**Desde otras notas:**
- [[IntercambiosBD.GetEstadosIntercambios()]] lo llama · `calls_sp` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
