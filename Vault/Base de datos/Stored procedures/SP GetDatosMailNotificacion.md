---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_getdatosmailnotificacion"
  - "sqlswappit_cualquiercompu_dbo_getdatosmailnotificacion"
  - "basedatos_storedprocedures_dbo_getdatosmailnotificacion"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP GetDatosMailNotificacion

Stored procedure `dbo.GetDatosMailNotificacion`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Todo lo que necesita un mail: datos de los dos usuarios, nombres de los artículos de cada lado y, si la notificación es de un cambio, su tipo y artículos (cuatro resultados).

Nuevo del 17/11 (devolución docente: todo el acceso a datos por SP).

Lo llama [[NotificacionesBD.GetDatosMailNotificacion()]].

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Articulos]] · `reads_from` EXTRACTED
- lee de [[Tabla Intercambios]] · `reads_from` EXTRACTED
- lee de [[Tabla Usuarios]] · `reads_from` EXTRACTED

**Desde otras notas:**
- [[NotificacionesBD.GetDatosMailNotificacion()]] lo llama · `calls_sp` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
