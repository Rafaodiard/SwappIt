---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_getidsfavoritos"
  - "sqlswappit_cualquiercompu_dbo_getidsfavoritos"
  - "basedatos_storedprocedures_dbo_getidsfavoritos"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP GetIdsFavoritos

Stored procedure `dbo.GetIdsFavoritos`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Ids de los favoritos del usuario (para pintar los corazones).

Nuevo del 17/11 (devolución docente: todo el acceso a datos por SP).

Lo llama [[FavoritosBD.GetIdsFavoritos()]].

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)

**Desde otras notas:**
- [[FavoritosBD.GetIdsFavoritos()]] lo llama · `calls_sp` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
