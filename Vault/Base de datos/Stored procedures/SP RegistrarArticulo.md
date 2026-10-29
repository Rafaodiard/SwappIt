---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "BaseDatos/StoredProcedures.sql"
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
graphify_ids:
  - "sqlswappit_dbo_registrararticulo"
  - "sqlswappit_cualquiercompu_dbo_registrararticulo"
  - "basedatos_storedprocedures_dbo_registrararticulo"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP RegistrarArticulo

Stored procedure `dbo.RegistrarArticulo`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Original. Busca usuario, categoría y estado **por nombre**. `@descripcion varchar(50)` (la columna es 500) y no carga Ubicacion ni ACambio. La app usa [[BD]].PublicarArticulo.

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Categorias]] · `reads_from` EXTRACTED
- lee de [[Tabla EstadosArticulos]] · `reads_from` EXTRACTED
- lee de [[Tabla Usuarios]] · `reads_from` EXTRACTED
- escribe en [[Tabla Articulos]] · `writes_to` EXTRACTED

**Desde otras notas:**
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
