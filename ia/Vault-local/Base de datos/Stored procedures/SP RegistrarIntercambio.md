---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "BaseDatos/StoredProcedures.sql"
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
graphify_ids:
  - "sqlswappit_dbo_registrarintercambio"
  - "sqlswappit_cualquiercompu_dbo_registrarintercambio"
  - "basedatos_storedprocedures_dbo_registrarintercambio"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP RegistrarIntercambio

Stored procedure `dbo.RegistrarIntercambio`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Original. Busca usuarios por `Usuario` y artículos **por nombre**; solo inserta si `@fecha < GETDATE()`. Sin uso.

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Articulos]] · `reads_from` EXTRACTED
- lee de [[Tabla EstadosIntercambios]] · `reads_from` EXTRACTED
- lee de [[Tabla Usuarios]] · `reads_from` EXTRACTED
- escribe en [[Tabla Intercambios]] · `writes_to` EXTRACTED

**Desde otras notas:**
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
