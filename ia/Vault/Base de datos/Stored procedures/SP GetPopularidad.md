---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_getpopularidad"
  - "sqlswappit_cualquiercompu_dbo_getpopularidad"
  - "basedatos_storedprocedures_dbo_getpopularidad"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP GetPopularidad

Stored procedure `dbo.GetPopularidad`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Puntos de popularidad por artículo en los últimos 30 días (vista 1, favorito 3), para las recomendaciones.

Nuevo del 17/11 (devolución docente: todo el acceso a datos por SP).

Lo llama [[RecomendacionesBD.GetPopularidad()]].

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)

**Desde otras notas:**
- [[RecomendacionesBD.GetPopularidad()]] lo llama · `calls_sp` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
