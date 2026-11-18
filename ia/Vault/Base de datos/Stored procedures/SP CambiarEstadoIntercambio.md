---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_cambiarestadointercambio"
  - "sqlswappit_cualquiercompu_dbo_cambiarestadointercambio"
  - "basedatos_storedprocedures_dbo_cambiarestadointercambio"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP CambiarEstadoIntercambio

Stored procedure `dbo.CambiarEstadoIntercambio`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Pasa un intercambio de un estado a otro (aceptar, rechazar, marcar realizado) si el usuario puede hacerlo y si nada cambió desde que lo vio (`@ultimoCambioVisto`). Al aceptar rechaza las otras propuestas con esos artículos. Crea las notificaciones.

Nuevo del 17/11 (devolución docente: todo el acceso a datos por SP).

Lo llama [[IntercambiosBD.CambiarEstadoIntercambio()]].

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- llama a [[SP CrearNotificacion]] · `calls` EXTRACTED
- llama a [[SP RechazarPendientesDeArticulos]] · `calls` EXTRACTED
- lee de [[Tabla EstadosIntercambios]] · `reads_from` EXTRACTED
- escribe en [[Tabla Intercambios]] · `writes_to` EXTRACTED

**Desde otras notas:**
- [[IntercambiosBD.CambiarEstadoIntercambio()]] lo llama · `calls_sp` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
