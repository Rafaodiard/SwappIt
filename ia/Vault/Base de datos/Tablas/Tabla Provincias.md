---
tipo: tabla
comunidad: "Tablas y acceso a datos"
archivos:
  - "BaseDatos/Estructura.sql"
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
graphify_ids:
  - "basedatos_estructura_dbo_provincias"
  - "sqlswappit_dbo_provincias"
  - "sqlswappit_cualquiercompu_dbo_provincias"
  - "basedatos_storedprocedures_sql_provincias"
tags:
  - tipo/tabla
  - comunidad/Tablas_y_acceso_a_datos
---
# Tabla Provincias

`IdProvincia` (identity, PK, ojo: en singular) y `Nombre` varchar(50). 24 filas en los scripts de creación desde el 08/11 (antes 48: las 25 a 48 repetían las 1 a 24 y se veían dos veces en Editar perfil). Modelo: [[Provincias]].

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)

**Desde otras notas:**
- [[Script Estructura.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Provincias]] es su clase en C# · `maps_to` INFERRED
- [[SP Complejos_RendimientoPlataformaPorPeriodo]] lee de acá · `reads_from` EXTRACTED
- [[SP GetIntercambios]] lee de acá · `reads_from` EXTRACTED
- [[SP GetProvinciaById]] lee de acá · `reads_from` EXTRACTED
- [[SP GetProvincias]] lee de acá · `reads_from` EXTRACTED
- [[Tabla Notificaciones]] la usa como tipo · `references` EXTRACTED
