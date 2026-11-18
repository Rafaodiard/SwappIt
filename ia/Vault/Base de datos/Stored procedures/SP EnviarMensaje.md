---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_enviarmensaje"
  - "sqlswappit_cualquiercompu_dbo_enviarmensaje"
  - "basedatos_storedprocedures_dbo_enviarmensaje"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP EnviarMensaje

Stored procedure `dbo.EnviarMensaje`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Guarda un mensaje del chat si el usuario es parte del intercambio y avisa al otro ("Mensaje nuevo", una sola sin leer por chat).

Nuevo del 17/11 (devolución docente: todo el acceso a datos por SP).

Lo llama [[ChatBD.EnviarMensaje()]].

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- llama a [[SP CrearNotificacion]] · `calls` EXTRACTED
- lee de [[Tabla EstadosIntercambios]] · `reads_from` EXTRACTED
- lee de [[Tabla Intercambios]] · `reads_from` EXTRACTED
- escribe en [[Tabla Mensajes]] · `writes_to` EXTRACTED

**Desde otras notas:**
- [[ChatBD.EnviarMensaje()]] lo llama · `calls_sp` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
