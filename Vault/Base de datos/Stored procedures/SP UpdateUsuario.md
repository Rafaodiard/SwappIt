---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_updateusuario"
  - "sqlswappit_cualquiercompu_dbo_updateusuario"
  - "basedatos_storedprocedures_dbo_updateusuario"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP UpdateUsuario

Stored procedure `dbo.UpdateUsuario`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Desde el 29/10 tiene código (antes era la plantilla vacía de SSMS): actualiza todas las columnas del usuario, como [[BD]].UpdateUsuario.

Es la copia en SQL de [[BD]].UpdateUsuario, pero **C# no lo llama** (ver [[Pendientes y problemas]]).

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- escribe en [[Tabla Usuarios]] · `writes_to` EXTRACTED

**Desde otras notas:**
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
- [[BD.UpdateUsuario()]] tiene el mismo nombre · `same_name_as_sp` INFERRED
