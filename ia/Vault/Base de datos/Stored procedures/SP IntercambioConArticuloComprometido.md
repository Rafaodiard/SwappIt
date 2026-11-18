---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_intercambioconarticulocomprometido"
  - "sqlswappit_cualquiercompu_dbo_intercambioconarticulocomprometido"
  - "basedatos_storedprocedures_dbo_intercambioconarticulocomprometido"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP IntercambioConArticuloComprometido

Stored procedure `dbo.IntercambioConArticuloComprometido`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Dice si algún artículo del intercambio ya está comprometido en otro.

Nuevo del 17/11 (devolución docente: todo el acceso a datos por SP).

Lo llama [[IntercambiosBD.IntercambioConArticuloComprometido()]].

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla EstadosIntercambios]] · `reads_from` EXTRACTED
- lee de [[Tabla Intercambios]] · `reads_from` EXTRACTED

**Desde otras notas:**
- [[IntercambiosBD.IntercambioConArticuloComprometido()]] lo llama · `calls_sp` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
