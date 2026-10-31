---
tipo: tabla
comunidad: "Tablas y acceso a datos"
archivos:
  - "BaseDatos/Estados.sql"
  - "BaseDatos/Estructura.sql"
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
graphify_ids:
  - "basedatos_estructura_dbo_estadosarticulos"
  - "basedatos_estados_dbo_estadosarticulos"
  - "sqlswappit_dbo_estadosarticulos"
  - "sqlswappit_cualquiercompu_dbo_estadosarticulos"
  - "basedatos_storedprocedures_sql_estadosarticulos"
tags:
  - tipo/tabla
  - comunidad/Tablas_y_acceso_a_datos
---
# Tabla EstadosArticulos

`IdEstadosArticulos` (PK) y `Nombre`. Datos: 1 Como nuevo, 2 Muy buen estado, 3 Buen estado, 4 Usado (de mejor a peor; se ordena por id). Antes se llamaba `Estados` y `Articulos.Estado` era texto: [[Script Estados.sql]] migra bases viejas. Modelo: [[EstadosArticulos]].

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)

**Desde otras notas:**
- [[Script Estados.sql]] la contiene · `contains` EXTRACTED
- [[Script Estructura.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[EstadosArticulos]] es su clase en C# · `maps_to` INFERRED
- [[BD.GetArticulosCatalogo()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetEstadoArticuloById()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetEstadosArticulos()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetFiltroEstados()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetIntercambio()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetIntercambios()]] lee de acá · `reads_from` EXTRACTED
- [[SP GetArticulosCatalogo]] lee de acá · `reads_from` EXTRACTED
- [[SP GetEstadoArticuloById]] lee de acá · `reads_from` EXTRACTED
- [[SP GetEstadosArticulos]] lee de acá · `reads_from` EXTRACTED
- [[SP GetFiltroEstados]] lee de acá · `reads_from` EXTRACTED
- [[SP RegistrarArticulo]] lee de acá · `reads_from` EXTRACTED
- [[Tabla Articulos]] la usa como tipo · `references` EXTRACTED
