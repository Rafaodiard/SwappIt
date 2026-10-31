---
tipo: modelo
comunidad: "Intercambios y mensajes"
archivos:
  - "Models/Mensajes.cs"
graphify_ids:
  - "models_mensajes_swappit_models_mensajes"
  - "models_mensajes"
  - "models_mensajes_swappit_models_mensajes_fechaenviado"
  - "models_mensajes_swappit_models_mensajes_fecharecibido"
  - "models_mensajes_swappit_models_mensajes_fuevisto"
  - "models_mensajes_swappit_models_mensajes_idintercambio"
  - "models_mensajes_swappit_models_mensajes_idmensajes"
  - "models_mensajes_swappit_models_mensajes_idusuariosmanda"
  - "models_mensajes_swappit_models_mensajes_texto"
tags:
  - tipo/modelo
  - comunidad/Intercambios_y_mensajes
---
# Mensajes (modelo)

`Models/Mensajes.cs` · [[Tabla Mensajes]]: mensajes del chat de un intercambio. Sin uso por ahora ([[Flujo Chat]]).

Comunidad del grafo: [[Comunidad - Intercambios y mensajes]]

## Propiedades
`FechaEnviado` · `FechaRecibido` · `fueVisto` · `IdIntercambio` · `IdMensajes` · `IdUsuariosManda` · `Texto`

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Models]] · `contains` EXTRACTED
- corresponde a la tabla [[Tabla Mensajes]] · `maps_to` INFERRED
- usa el tipo [[DateTime]] · `references` EXTRACTED
