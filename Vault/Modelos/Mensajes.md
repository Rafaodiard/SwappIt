---
tipo: modelo
comunidad: "Modelo Mensajes"
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
  - comunidad/Modelo_Mensajes
---
# Mensajes (modelo)

`Models/Mensajes.cs` · [[Tabla Mensajes]]: mensajes del chat de un intercambio, que manda una de las dos partes (`IdUsuariosManda`). `fueVisto` y `FechaRecibido` se completan cuando la otra persona abre el chat ([[BD.MarcarMensajesVistos()]]). Constante `LargoMaximoTexto = 500` ([[Flujo Chat]]).

Comunidad del grafo: [[Comunidad - Modelo Mensajes]]

## Propiedades
`FechaEnviado` · `FechaRecibido` · `fueVisto` · `IdIntercambio` · `IdMensajes` · `IdUsuariosManda` · `Texto`

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Models]] · `contains` EXTRACTED
- corresponde a la tabla [[Tabla Mensajes]] · `maps_to` INFERRED
- usa el tipo [[DateTime]] · `references` EXTRACTED

**Desde otras notas:**
- [[BD.GetMensajes()]] la usa como tipo · `references` EXTRACTED
