---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "BaseDatos/StoredProcedures.sql"
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
graphify_ids:
  - "sqlswappit_dbo_registrarmensaje"
  - "sqlswappit_cualquiercompu_dbo_registrarmensaje"
  - "basedatos_storedprocedures_dbo_registrarmensaje"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP RegistrarMensaje

Stored procedure `dbo.RegistrarMensaje`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Original. Recibe `@usuariorecibe` pero no lo guarda (la tabla no tiene esa columna); `FechaRecibido` = `FechaEnviado`. Sin uso.

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Intercambios]] · `reads_from` EXTRACTED
- lee de [[Tabla Usuarios]] · `reads_from` EXTRACTED
- escribe en [[Tabla Mensajes]] · `writes_to` EXTRACTED

**Desde otras notas:**
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
