---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_respondercambio"
  - "sqlswappit_cualquiercompu_dbo_respondercambio"
  - "basedatos_storedprocedures_dbo_respondercambio"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP ResponderCambio

Stored procedure `dbo.ResponderCambio`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

El otro acepta o rechaza un cambio pendiente; si lo acepta, el artículo entra o sale del intercambio. Le avisa a quien lo pidió.

Nuevo del 17/11 (devolución docente: todo el acceso a datos por SP).

Lo llama [[IntercambiosBD.ResponderCambio()]].

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- llama a [[SP CrearNotificacion]] · `calls` EXTRACTED
- llama a [[SP RechazarPendientesDeArticulos]] · `calls` EXTRACTED
- lee de [[Tabla Articulos]] · `reads_from` EXTRACTED
- lee de [[Tabla EstadosIntercambios]] · `reads_from` EXTRACTED
- lee de [[Tabla Intercambios]] · `reads_from` EXTRACTED

**Desde otras notas:**
- [[IntercambiosBD.ResponderCambio()]] lo llama · `calls_sp` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
