---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_importarfavoritos"
  - "sqlswappit_cualquiercompu_dbo_importarfavoritos"
  - "basedatos_storedprocedures_dbo_importarfavoritos"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP ImportarFavoritos

Stored procedure `dbo.ImportarFavoritos`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Pasa a la base los favoritos que el usuario tenía guardados en el navegador.

Nuevo del 17/11 (devolución docente: todo el acceso a datos por SP).

Lo llama [[FavoritosBD.ImportarFavoritos()]].

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Articulos]] · `reads_from` EXTRACTED

**Desde otras notas:**
- [[FavoritosBD.ImportarFavoritos()]] lo llama · `calls_sp` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
