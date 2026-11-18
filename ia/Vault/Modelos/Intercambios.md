---
tipo: modelo
comunidad: "Modelo Intercambios"
archivos:
  - "Models/Intercambios.cs"
graphify_ids:
  - "models_intercambios_swappit_models_intercambios"
  - "models_intercambios"
  - "models_intercambios_swappit_models_intercambios_fecha"
  - "models_intercambios_swappit_models_intercambios_idarticulos1"
  - "models_intercambios_swappit_models_intercambios_idarticulos2"
  - "models_intercambios_swappit_models_intercambios_idestado"
  - "models_intercambios_swappit_models_intercambios_idintercambios"
  - "models_intercambios_swappit_models_intercambios_idusuarios1"
  - "models_intercambios_swappit_models_intercambios_idusuarios2"
tags:
  - tipo/modelo
  - comunidad/Modelo_Intercambios
---
# Intercambios (modelo)

`Models/Intercambios.cs` · [[Tabla Intercambios]]: dos usuarios (`IdUsuarios1`, `IdUsuarios2`) y dos artículos (`IdArticulos1`, `IdArticulos2`). Quien propone va en `IdUsuarios1`/`IdArticulos1` y el dueño del artículo pedido en `IdUsuarios2`/`IdArticulos2` (decisión del 29/10). Le falta la propiedad `Ubicacion` que sí tiene la tabla. Las pantallas no usan esta clase: leen [[IntercambioViewModel]] ([[Flujo Proponer intercambio]]).

Comunidad del grafo: [[Comunidad - Modelo Intercambios]]

## Propiedades
`Fecha` · `IdArticulos1` · `IdArticulos2` · `IdEstado` · `IdIntercambios` · `IdUsuarios1` · `IdUsuarios2`

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Models]] · `contains` EXTRACTED
- corresponde a la tabla [[Tabla Intercambios]] · `maps_to` INFERRED
- usa el tipo [[DateTime]] · `references` EXTRACTED
