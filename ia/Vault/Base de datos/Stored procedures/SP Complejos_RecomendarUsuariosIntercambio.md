---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_complejos_recomendarusuariosintercambio"
  - "sqlswappit_cualquiercompu_dbo_complejos_recomendarusuariosintercambio"
  - "basedatos_storedprocedures_dbo_complejos_recomendarusuariosintercambio"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP Complejos_RecomendarUsuariosIntercambio

Stored procedure `dbo.Complejos_RecomendarUsuariosIntercambio`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

SP de consultas complejas para la materia (06/11).

Lo ejecutan los SP [[SP Complejos_Ejecucion]].

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Articulos]] · `reads_from` EXTRACTED
- lee de [[Tabla Usuarios]] · `reads_from` EXTRACTED

**Desde otras notas:**
- [[SP Complejos_Ejecucion]] la llama · `calls` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
