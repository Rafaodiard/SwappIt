---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_getarticuloscatalogo"
  - "sqlswappit_cualquiercompu_dbo_getarticuloscatalogo"
  - "basedatos_storedprocedures_dbo_getarticuloscatalogo"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP GetArticulosCatalogo

Stored procedure `dbo.GetArticulosCatalogo`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Catálogo de Explorar, inicio, perfiles, favoritos y recomendaciones, con todos los filtros adentro del SP: búsqueda (escapa `[`, `%` y `_`), categorías y estados como ids separados por coma (`STRING_SPLIT`), excluir un usuario o un artículo, dejar afuera los comprometidos, solo los que se pueden sumar a un intercambio (`@fueraDeIntercambio`), cantidad y orden (`recientes`, `az` o `populares`, que suma vistas y favoritos de los últimos 30 días). Desde el 17/11 reemplaza al SQL que se armaba en C#.

Lo llama [[ArticulosBD.GetArticulosCatalogo()]].

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Articulos]] · `reads_from` EXTRACTED
- lee de [[Tabla EstadosArticulos]] · `reads_from` EXTRACTED
- lee de [[Tabla EstadosIntercambios]] · `reads_from` EXTRACTED
- lee de [[Tabla Imagenes]] · `reads_from` EXTRACTED
- lee de [[Tabla Intercambios]] · `reads_from` EXTRACTED
- lee de [[Tabla Usuarios]] · `reads_from` EXTRACTED

**Desde otras notas:**
- [[ArticulosBD.GetArticulosCatalogo()]] lo llama · `calls_sp` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
