---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_registrarbusqueda"
  - "sqlswappit_cualquiercompu_dbo_registrarbusqueda"
  - "basedatos_storedprocedures_dbo_registrarbusqueda"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP RegistrarBusqueda

Stored procedure `dbo.RegistrarBusqueda`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Guarda una búsqueda o un filtro por categoría como Interacción, sin repetirla si es igual a una de los últimos minutos.

Nuevo del 17/11 (devolución docente: todo el acceso a datos por SP).

Lo llama [[RecomendacionesBD.RegistrarBusqueda()]].

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Categorias]] · `reads_from` EXTRACTED

**Desde otras notas:**
- [[RecomendacionesBD.RegistrarBusqueda()]] lo llama · `calls_sp` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
