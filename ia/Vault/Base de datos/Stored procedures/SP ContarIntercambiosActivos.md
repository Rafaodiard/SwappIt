---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_contarintercambiosactivos"
  - "sqlswappit_cualquiercompu_dbo_contarintercambiosactivos"
  - "basedatos_storedprocedures_dbo_contarintercambiosactivos"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP ContarIntercambiosActivos

Stored procedure `dbo.ContarIntercambiosActivos`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Cuántos intercambios en curso tiene el usuario.

Nuevo del 17/11 (devolución docente: todo el acceso a datos por SP).

Lo llama [[IntercambiosBD.ContarIntercambiosActivos()]].

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla EstadosIntercambios]] · `reads_from` EXTRACTED
- lee de [[Tabla Intercambios]] · `reads_from` EXTRACTED

**Desde otras notas:**
- [[IntercambiosBD.ContarIntercambiosActivos()]] lo llama · `calls_sp` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
