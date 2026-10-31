---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_getarticuloscatalogo"
  - "sqlswappit_cualquiercompu_dbo_getarticuloscatalogo"
  - "basedatos_storedprocedures_dbo_getarticuloscatalogo"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP GetArticulosCatalogo

Stored procedure `dbo.GetArticulosCatalogo`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Desde el 29/10 tiene código (antes era la plantilla vacía de SSMS): búsqueda, categorías y estados como ids separados por coma (`STRING_SPLIT`), `@idUsuario` y `@cantidad`. **Quedó atrás de [[BD]].GetArticulosCatalogo**: no tiene `excluirUsuario` ni oculta los artículos comprometidos en un intercambio.

Es la copia en SQL de [[BD]].GetArticulosCatalogo, pero **C# no lo llama** (ver [[Pendientes y problemas]]).

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Articulos]] · `reads_from` EXTRACTED
- lee de [[Tabla EstadosArticulos]] · `reads_from` EXTRACTED
- lee de [[Tabla Imagenes]] · `reads_from` EXTRACTED
- lee de [[Tabla Usuarios]] · `reads_from` EXTRACTED

**Desde otras notas:**
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
- [[BD.GetArticulosCatalogo()]] tiene el mismo nombre · `same_name_as_sp` INFERRED
