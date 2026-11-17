---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_rechazarpendientesdearticulos"
  - "sqlswappit_cualquiercompu_dbo_rechazarpendientesdearticulos"
  - "basedatos_storedprocedures_dbo_rechazarpendientesdearticulos"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP RechazarPendientesDeArticulos

Stored procedure `dbo.RechazarPendientesDeArticulos`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Ayudante de otros SP: rechaza las otras propuestas pendientes que usan artículos de este intercambio y le avisa a quien las hizo ([[SP CrearNotificacion]]).

Nuevo del 17/11 (devolución docente: todo el acceso a datos por SP).

Lo ejecutan los SP [[SP AgregarArticulos]], [[SP CambiarEstadoIntercambio]], [[SP ResponderCambio]].

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- llama a [[SP CrearNotificacion]] · `calls` EXTRACTED
- lee de [[Tabla EstadosIntercambios]] · `reads_from` EXTRACTED
- escribe en [[Tabla Intercambios]] · `writes_to` EXTRACTED

**Desde otras notas:**
- [[SP AgregarArticulos]] la llama · `calls` EXTRACTED
- [[SP CambiarEstadoIntercambio]] la llama · `calls` EXTRACTED
- [[SP ResponderCambio]] la llama · `calls` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
