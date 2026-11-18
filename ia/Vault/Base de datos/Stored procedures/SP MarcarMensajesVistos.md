---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_marcarmensajesvistos"
  - "sqlswappit_cualquiercompu_dbo_marcarmensajesvistos"
  - "basedatos_storedprocedures_dbo_marcarmensajesvistos"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP MarcarMensajesVistos

Stored procedure `dbo.MarcarMensajesVistos`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Marca como leídos los mensajes que recibió el usuario en un chat y sus notificaciones de ese chat.

Nuevo del 17/11 (devolución docente: todo el acceso a datos por SP).

Lo llama [[ChatBD.MarcarMensajesVistos()]].

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Intercambios]] · `reads_from` EXTRACTED
- lee de [[Tabla TipoNotificaciones]] · `reads_from` EXTRACTED
- escribe en [[Tabla Mensajes]] · `writes_to` EXTRACTED
- escribe en [[Tabla Notificaciones]] · `writes_to` EXTRACTED

**Desde otras notas:**
- [[ChatBD.MarcarMensajesVistos()]] lo llama · `calls_sp` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
