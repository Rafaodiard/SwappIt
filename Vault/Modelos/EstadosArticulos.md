---
tipo: modelo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/EstadosArticulos.cs"
graphify_ids:
  - "models_estadosarticulos_swappit_models_estadosarticulos"
  - "models_estadosarticulos"
  - "models_estadosarticulos_swappit_models_estadosarticulos_idestadosarticulos"
  - "models_estadosarticulos_swappit_models_estadosarticulos_nombre"
tags:
  - tipo/modelo
  - comunidad/Tablas_y_acceso_a_datos
---
# EstadosArticulos (modelo)

`Models/EstadosArticulos.cs` · [[Tabla EstadosArticulos]]: opciones de "Estado del objeto" al publicar (Como nuevo, Muy buen estado, Buen estado, Usado). `Articulos.IdEstado` apunta acá.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Propiedades
`IdEstadosArticulos` · `Nombre`

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Models]] · `contains` EXTRACTED
- corresponde a la tabla [[Tabla EstadosArticulos]] · `maps_to` INFERRED

**Desde otras notas:**
- [[BD.GetEstadoArticuloById()]] la usa como tipo · `references` EXTRACTED
- [[BD.GetEstadosArticulos()]] la usa como tipo · `references` EXTRACTED
- [[PublicarController.ObtenerEstados()]] la usa como tipo · `references` EXTRACTED
