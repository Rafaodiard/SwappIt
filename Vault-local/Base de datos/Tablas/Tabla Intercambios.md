---
tipo: tabla
comunidad: "Tablas y acceso a datos"
archivos:
  - "BaseDatos/Estructura.sql"
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
graphify_ids:
  - "basedatos_estructura_dbo_intercambios"
  - "sqlswappit_dbo_intercambios"
  - "sqlswappit_cualquiercompu_dbo_intercambios"
  - "intercambios"
tags:
  - tipo/tabla
  - comunidad/Tablas_y_acceso_a_datos
---
# Tabla Intercambios

| Columna | Tipo |
|---|---|
| IdIntercambios | int identity, PK |
| Fecha | date NOT NULL |
| IdEstado | int NOT NULL, FK → [[Tabla EstadosIntercambios]] |
| IdUsuarios1, IdUsuarios2 | int NOT NULL, FK → [[Tabla Usuarios]] |
| IdArticulos1, IdArticulos2 | int NOT NULL, FK → [[Tabla Articulos]] |
| Ubicacion | varchar(50) NULL (punto de encuentro) |

Sin datos de prueba y sin uso en el código todavía ([[Flujo Proponer intercambio]]). Modelo: [[Intercambios]] (le falta `Ubicacion`).

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- usa el tipo [[Tabla Articulos]] · `references` EXTRACTED
- usa el tipo [[Tabla EstadosIntercambios]] · `references` EXTRACTED
- usa el tipo [[Tabla Usuarios]] · `references` EXTRACTED

**Desde otras notas:**
- [[Script Estructura.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Intercambios]] es su clase en C# · `maps_to` INFERRED
- [[SP RegistrarMensaje]] lee de acá · `reads_from` EXTRACTED
- [[SP RegistrarIntercambio]] escribe acá · `writes_to` EXTRACTED
