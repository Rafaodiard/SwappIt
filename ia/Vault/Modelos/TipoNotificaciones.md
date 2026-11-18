---
tipo: modelo
comunidad: "Namespaces y formularios"
archivos:
  - "Models/TipoNotificaciones.cs"
graphify_ids:
  - "models_tiponotificaciones_swappit_models_tiponotificaciones"
  - "models_tiponotificaciones"
  - "models_tiponotificaciones_swappit_models_tiponotificaciones_id"
  - "models_tiponotificaciones_swappit_models_tiponotificaciones_nombre"
tags:
  - tipo/modelo
  - comunidad/Namespaces_y_formularios
---
# TipoNotificaciones

`Models/TipoNotificaciones.cs` · Modelo de [[Tabla TipoNotificaciones]] y constantes con los nombres de los tipos: `PropuestaRecibida` (al dueño del artículo pedido), `PropuestaAceptada` y `PropuestaRechazada` (a quien propuso), `MensajeNuevo` e `IntercambioCancelado` (a la otra persona). [[BD]] busca el Id por nombre para no depender de los ids.

Comunidad del grafo: [[Comunidad - Namespaces y formularios]]

## Propiedades
`Id` · `Nombre`

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Models]] · `contains` EXTRACTED
- corresponde a la tabla [[Tabla TipoNotificaciones]] · `maps_to` INFERRED
