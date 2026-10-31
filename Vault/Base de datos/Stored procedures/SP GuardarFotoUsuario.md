---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_guardarfotousuario"
  - "sqlswappit_cualquiercompu_dbo_guardarfotousuario"
  - "basedatos_storedprocedures_dbo_guardarfotousuario"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP GuardarFotoUsuario

Stored procedure `dbo.GuardarFotoUsuario`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Borra la foto de perfil anterior e inserta la nueva. Recibe `@idUsuario` y `@ruta varchar(100)`, como la columna (se corrigió el 29/10).

Es la copia en SQL de [[BD]].GuardarFotoUsuario, pero **C# no lo llama** (ver [[Pendientes y problemas]]).

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- escribe en [[Tabla Imagenes]] · `writes_to` EXTRACTED

**Desde otras notas:**
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
- [[BD.GuardarFotoUsuario()]] tiene el mismo nombre · `same_name_as_sp` INFERRED
