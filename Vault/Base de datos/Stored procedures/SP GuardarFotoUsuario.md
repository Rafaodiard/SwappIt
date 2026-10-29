---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
graphify_ids:
  - "sqlswappit_dbo_guardarfotousuario"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP GuardarFotoUsuario

Stored procedure `dbo.GuardarFotoUsuario`. Está en: [[Script SQLSwappit.sql]].

**Bug:** `@ruta varchar(50)` (la columna es 100) y el parámetro se llama `@idUauario`.

Es la copia en SQL de [[BD]].GuardarFotoUsuario, pero **C# no lo llama** (ver [[Pendientes y problemas]]).

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- escribe en [[Tabla Imagenes]] · `writes_to` EXTRACTED

**Desde otras notas:**
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[BD.GuardarFotoUsuario()]] tiene el mismo nombre · `same_name_as_sp` INFERRED
