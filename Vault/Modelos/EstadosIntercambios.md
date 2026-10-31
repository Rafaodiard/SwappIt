---
tipo: modelo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/EstadosIntercambios.cs"
graphify_ids:
  - "models_estadosintercambios_swappit_models_estadosintercambios"
  - "models_estadosintercambios"
  - "models_estadosintercambios_swappit_models_estadosintercambios_idestadosintercambios"
  - "models_estadosintercambios_swappit_models_estadosintercambios_nombre"
tags:
  - tipo/modelo
  - comunidad/Tablas_y_acceso_a_datos
---
# EstadosIntercambios (modelo)

`Models/EstadosIntercambios.cs` · [[Tabla EstadosIntercambios]]: Pendiente, Aceptado, Rechazado, Realizado y Cancelado. Tiene constantes con esos nombres: [[BD]] busca los estados por nombre y [[IntercambioController]] las usa para validar cada cambio de estado.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Propiedades
`IdEstadosIntercambios` · `Nombre`

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Models]] · `contains` EXTRACTED
- corresponde a la tabla [[Tabla EstadosIntercambios]] · `maps_to` INFERRED

**Desde otras notas:**
- [[BD.GetEstadosIntercambios()]] la usa como tipo · `references` EXTRACTED
