---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_registrarvista"
  - "sqlswappit_cualquiercompu_dbo_registrarvista"
  - "basedatos_storedprocedures_dbo_registrarvista"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP RegistrarVista

Stored procedure `dbo.RegistrarVista`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Guarda que el usuario abrió un artículo (Interacción "Vista") y devuelve su id.

Nuevo del 17/11 (devolución docente: todo el acceso a datos por SP).

Lo llama [[RecomendacionesBD.RegistrarVista()]].

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)

**Desde otras notas:**
- [[RecomendacionesBD.RegistrarVista()]] lo llama · `calls_sp` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
