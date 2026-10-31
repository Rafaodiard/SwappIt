---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_borrarfotousuario"
  - "sqlswappit_cualquiercompu_dbo_borrarfotousuario"
  - "basedatos_storedprocedures_dbo_borrarfotousuario"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP BorrarFotoUsuario

Stored procedure `dbo.BorrarFotoUsuario`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Es la copia en SQL de [[BD]].BorrarFotoUsuario, pero **C# no lo llama** (ver [[Pendientes y problemas]]).

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- escribe en [[Tabla Imagenes]] · `writes_to` EXTRACTED

**Desde otras notas:**
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
- [[BD.BorrarFotoUsuario()]] tiene el mismo nombre · `same_name_as_sp` INFERRED
