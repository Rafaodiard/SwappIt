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

Inserta un usuario nuevo con todos sus datos, incluida la edad. Desde el 17/11 lo usa [[UsuariosBD.Register()]] (antes el INSERT estaba escrito en C# y este SP no guardaba la edad).

Lo llama [[UsuariosBD.Register()]].

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- escribe en [[Tabla Usuarios]] · `writes_to` EXTRACTED

**Desde otras notas:**
- [[UsuariosBD.Register()]] lo llama · `calls_sp` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
