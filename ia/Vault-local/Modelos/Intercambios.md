---
tipo: modelo
comunidad: "Intercambios y mensajes"
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
  - comunidad/Intercambios_y_mensajes
---
# Intercambios (modelo)

`Models/Intercambios.cs` · [[Tabla Intercambios]]: dos usuarios (`IdUsuarios1`, `IdUsuarios2`) y dos artículos (`IdArticulos1`, `IdArticulos2`). Todavía no hay código que diga cuál es el que propone; el comentario del pop up en [[Vista Articulos-Detalle]] dice que el artículo ofrecido iría en `IdArticulos2`. Le falta la propiedad `Ubicacion` que sí tiene la tabla. Sin uso por ahora ([[Flujo Proponer intercambio]]).

Comunidad del grafo: [[Comunidad - Intercambios y mensajes]]

## Propiedades
`Fecha` · `IdArticulos1` · `IdArticulos2` · `IdEstado` · `IdIntercambios` · `IdUsuarios1` · `IdUsuarios2`

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Models]] · `contains` EXTRACTED
- corresponde a la tabla [[Tabla Intercambios]] · `maps_to` INFERRED
- usa el tipo [[DateTime]] · `references` EXTRACTED
