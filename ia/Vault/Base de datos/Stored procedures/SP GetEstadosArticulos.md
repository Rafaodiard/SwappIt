---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_getestadosarticulos"
  - "sqlswappit_cualquiercompu_dbo_getestadosarticulos"
  - "basedatos_storedprocedures_dbo_getestadosarticulos"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP GetEstadosArticulos

Stored procedure `dbo.GetEstadosArticulos`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Lo llama [[ArticulosBD.GetEstadosArticulos()]].

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla EstadosArticulos]] · `reads_from` EXTRACTED

**Desde otras notas:**
- [[ArticulosBD.GetEstadosArticulos()]] lo llama · `calls_sp` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
