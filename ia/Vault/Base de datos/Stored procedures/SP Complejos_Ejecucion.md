---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_complejos_ejecucion"
  - "sqlswappit_cualquiercompu_dbo_complejos_ejecucion"
  - "basedatos_storedprocedures_dbo_complejos_ejecucion"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP Complejos_Ejecucion

Stored procedure `dbo.Complejos_Ejecucion`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

SP de consultas complejas para la materia (06/11).

La app no lo llama.

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- llama a [[SP Complejos_EstadisticasUsuario]] · `calls` EXTRACTED
- llama a [[SP Complejos_Personalizado_GestionarPropuestaYNotificacion]] · `calls` EXTRACTED
- llama a [[SP Complejos_RecomendarUsuariosIntercambio]] · `calls` EXTRACTED
- llama a [[SP Complejos_RendimientoPlataformaPorPeriodo]] · `calls` EXTRACTED
- llama a [[SP Complejos_SeguimientoIntercambiosPendientes]] · `calls` EXTRACTED

**Desde otras notas:**
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
