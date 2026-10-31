---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "BaseDatos/StoredProcedures.sql"
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
graphify_ids:
  - "sqlswappit_dbo_registrarusuario"
  - "sqlswappit_cualquiercompu_dbo_registrarusuario"
  - "basedatos_storedprocedures_dbo_registrarusuario"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP RegistrarUsuario

Stored procedure `dbo.RegistrarUsuario`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Original. Inserta un usuario si el `Usuario` y el teléfono no existen. **No inserta `Edad` (NOT NULL), así que siempre falla.** La app usa [[BD]].Register en su lugar.

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- escribe en [[Tabla Usuarios]] · `writes_to` EXTRACTED

**Desde otras notas:**
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
