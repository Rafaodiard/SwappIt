---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_getresumeneschat"
  - "sqlswappit_cualquiercompu_dbo_getresumeneschat"
  - "basedatos_storedprocedures_dbo_getresumeneschat"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP GetResumenesChat

Stored procedure `dbo.GetResumenesChat`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Para cada chat del usuario: el último mensaje y cuántos no leyó.

Nuevo del 17/11 (devolución docente: todo el acceso a datos por SP).

Lo llama [[ChatBD.GetResumenesChat()]].

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Intercambios]] · `reads_from` EXTRACTED
- lee de [[Tabla Mensajes]] · `reads_from` EXTRACTED

**Desde otras notas:**
- [[ChatBD.GetResumenesChat()]] lo llama · `calls_sp` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
