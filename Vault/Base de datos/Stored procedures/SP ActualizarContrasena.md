---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
graphify_ids:
  - "sqlswappit_dbo_actualizarcontrasena"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP ActualizarContrasena

Stored procedure `dbo.ActualizarContrasena`. Está en: [[Script SQLSwappit.sql]].

**Bug:** `@contrasenaHash varchar(50)` corta el hash de 84 caracteres. Tiene que ser varchar(100).

Es la copia en SQL de [[BD]].ActualizarContrasena, pero **C# no lo llama** (ver [[Pendientes y problemas]]).

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- escribe en [[Tabla Usuarios]] · `writes_to` EXTRACTED

**Desde otras notas:**
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[BD.ActualizarContrasena()]] tiene el mismo nombre · `same_name_as_sp` INFERRED
