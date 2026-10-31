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

`IdProvincia` (identity, PK, ojo: en singular) y `Nombre` varchar(50). 48 filas en los datos: las 25 a 48 repiten las 1 a 24 (las agrega [[Script Provincias.sql]]). Modelo: [[Provincias]].

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)

**Desde otras notas:**
- [[Script Estructura.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Provincias]] es su clase en C# · `maps_to` INFERRED
- [[BD.GetIntercambio()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetIntercambios()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetProvinciaById()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetProvincias()]] lee de acá · `reads_from` EXTRACTED
- [[SP GetProvinciaById]] lee de acá · `reads_from` EXTRACTED
- [[SP GetProvincias]] lee de acá · `reads_from` EXTRACTED
- [[Tabla Notificaciones]] la usa como tipo · `references` EXTRACTED
