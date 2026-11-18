---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_contararticulosactivos"
  - "sqlswappit_cualquiercompu_dbo_contararticulosactivos"
  - "basedatos_storedprocedures_dbo_contararticulosactivos"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP ContarArticulosActivos

Stored procedure `dbo.ContarArticulosActivos`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Cuántos artículos disponibles tiene publicados el usuario (para el límite de Publicar y el inicio).

Nuevo del 17/11 (devolución docente: todo el acceso a datos por SP).

Lo llama [[ArticulosBD.ContarArticulosActivos()]].

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Articulos]] · `reads_from` EXTRACTED
- lee de [[Tabla EstadosIntercambios]] · `reads_from` EXTRACTED
- lee de [[Tabla Intercambios]] · `reads_from` EXTRACTED

**Desde otras notas:**
- [[ArticulosBD.ContarArticulosActivos()]] lo llama · `calls_sp` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
