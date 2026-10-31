---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_getfiltrocategorias"
  - "sqlswappit_cualquiercompu_dbo_getfiltrocategorias"
  - "basedatos_storedprocedures_dbo_getfiltrocategorias"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP GetFiltroCategorias

Stored procedure `dbo.GetFiltroCategorias`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Desde el 29/10 tiene código (antes era la plantilla vacía de SSMS): categorías con la cantidad de artículos que coinciden con la búsqueda. **Quedó atrás de [[BD]].GetFiltroCategorias**: no excluye al usuario logueado ni los artículos comprometidos.

Es la copia en SQL de [[BD]].GetFiltroCategorias, pero **C# no lo llama** (ver [[Pendientes y problemas]]).

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Articulos]] · `reads_from` EXTRACTED
- lee de [[Tabla Categorias]] · `reads_from` EXTRACTED

**Desde otras notas:**
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
- [[BD.GetFiltroCategorias()]] tiene el mismo nombre · `same_name_as_sp` INFERRED
