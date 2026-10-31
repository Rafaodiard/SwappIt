---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_actualizarcontrasena"
  - "sqlswappit_cualquiercompu_dbo_actualizarcontrasena"
  - "basedatos_storedprocedures_dbo_actualizarcontrasena"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP ActualizarContrasena

Stored procedure `dbo.ActualizarContrasena`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Recibe `@contrasenaHash varchar(100)`, como la columna (antes era varchar(50) y cortaba el hash de 84 caracteres; se corrigió el 29/10 en "scripts y sp arreglados").

Es la copia en SQL de [[BD]].ActualizarContrasena, pero **C# no lo llama** (ver [[Pendientes y problemas]]).

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- escribe en [[Tabla Usuarios]] · `writes_to` EXTRACTED

**Desde otras notas:**
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
- [[BD.ActualizarContrasena()]] tiene el mismo nombre · `same_name_as_sp` INFERRED
