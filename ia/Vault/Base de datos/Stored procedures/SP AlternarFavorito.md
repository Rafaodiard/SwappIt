---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_alternarfavorito"
  - "sqlswappit_cualquiercompu_dbo_alternarfavorito"
  - "basedatos_storedprocedures_dbo_alternarfavorito"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP AlternarFavorito

Stored procedure `dbo.AlternarFavorito`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Marca o desmarca un artículo como favorito (Interacción "Favorito"); no deja marcar los propios. Devuelve si quedó favorito (NULL si no se pudo).

Nuevo del 17/11 (devolución docente: todo el acceso a datos por SP).

Lo llama [[FavoritosBD.AlternarFavorito()]].

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Articulos]] · `reads_from` EXTRACTED

**Desde otras notas:**
- [[FavoritosBD.AlternarFavorito()]] lo llama · `calls_sp` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
