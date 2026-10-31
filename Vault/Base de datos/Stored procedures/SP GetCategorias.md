---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_getcategorias"
  - "sqlswappit_cualquiercompu_dbo_getcategorias"
  - "basedatos_storedprocedures_dbo_getcategorias"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP GetCategorias

Stored procedure `dbo.GetCategorias`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Es la copia en SQL de [[BD]].GetCategorias, pero **C# no lo llama** (ver [[Pendientes y problemas]]).

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Categorias]] · `reads_from` EXTRACTED

**Desde otras notas:**
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
- [[BD.GetCategorias()]] tiene el mismo nombre · `same_name_as_sp` INFERRED
