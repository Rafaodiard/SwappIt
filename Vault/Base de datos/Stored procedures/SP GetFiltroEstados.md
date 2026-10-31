---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_getfiltroestados"
  - "sqlswappit_cualquiercompu_dbo_getfiltroestados"
  - "basedatos_storedprocedures_dbo_getfiltroestados"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP GetFiltroEstados

Stored procedure `dbo.GetFiltroEstados`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Desde el 29/10 tiene código (antes era la plantilla vacía de SSMS): estados de artículo con la cantidad que coincide con la búsqueda. **Quedó atrás de [[BD]].GetFiltroEstados**: no excluye al usuario logueado ni los artículos comprometidos.

Es la copia en SQL de [[BD]].GetFiltroEstados, pero **C# no lo llama** (ver [[Pendientes y problemas]]).

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Articulos]] · `reads_from` EXTRACTED
- lee de [[Tabla EstadosArticulos]] · `reads_from` EXTRACTED

**Desde otras notas:**
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
- [[BD.GetFiltroEstados()]] tiene el mismo nombre · `same_name_as_sp` INFERRED
