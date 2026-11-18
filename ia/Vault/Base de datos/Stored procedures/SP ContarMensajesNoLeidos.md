---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_contarmensajesnoleidos"
  - "sqlswappit_cualquiercompu_dbo_contarmensajesnoleidos"
  - "basedatos_storedprocedures_dbo_contarmensajesnoleidos"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP ContarMensajesNoLeidos

Stored procedure `dbo.ContarMensajesNoLeidos`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Mensajes sin leer del usuario en todos sus chats.

Nuevo del 17/11 (devolución docente: todo el acceso a datos por SP).

Lo llama [[ChatBD.ContarMensajesNoLeidos()]].

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Intercambios]] · `reads_from` EXTRACTED
- lee de [[Tabla Mensajes]] · `reads_from` EXTRACTED

**Desde otras notas:**
- [[ChatBD.ContarMensajesNoLeidos()]] lo llama · `calls_sp` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
