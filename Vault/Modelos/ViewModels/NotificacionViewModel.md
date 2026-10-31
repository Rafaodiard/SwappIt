---
tipo: modelo
comunidad: "Notificaciones"
archivos:
  - "Models/ViewModels/NotificacionViewModel.cs"
graphify_ids:
  - "models_viewmodels_notificacionviewmodel_swappit_models_viewmodels_notificacionviewmodel"
  - "models_viewmodels_notificacionviewmodel"
  - "models_viewmodels_notificacionviewmodel_swappit_models_viewmodels_notificacionviewmodel_articulonombre"
  - "models_viewmodels_notificacionviewmodel_swappit_models_viewmodels_notificacionviewmodel_fecha"
  - "models_viewmodels_notificacionviewmodel_swappit_models_viewmodels_notificacionviewmodel_id"
  - "models_viewmodels_notificacionviewmodel_swappit_models_viewmodels_notificacionviewmodel_idintercambio"
  - "models_viewmodels_notificacionviewmodel_swappit_models_viewmodels_notificacionviewmodel_leida"
  - "models_viewmodels_notificacionviewmodel_swappit_models_viewmodels_notificacionviewmodel_otronombre"
  - "models_viewmodels_notificacionviewmodel_swappit_models_viewmodels_notificacionviewmodel_tipo"
tags:
  - tipo/modelo
  - comunidad/Notificaciones
---
# NotificacionViewModel

`Models/ViewModels/NotificacionViewModel.cs` · Una notificación del pop up ([[Vista Notificaciones-_Lista]]). Sale de [[Tabla Notificaciones]] + [[Tabla TipoNotificaciones]] + el intercambio: `Tipo` (nombre, ver [[TipoNotificaciones]]), `Leida`, `Fecha`, `IdIntercambio`, la otra persona (`OtroNombre`) y el artículo pedido (`ArticuloNombre`).

Comunidad del grafo: [[Comunidad - Notificaciones]]

## Propiedades
`ArticuloNombre` · `Fecha` · `Id` · `IdIntercambio` · `Leida` · `OtroNombre` · `Tipo`

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Models.ViewModels]] · `contains` EXTRACTED
- usa el tipo [[DateTime]] · `references` EXTRACTED

**Desde otras notas:**
- [[BD.GetNotificaciones()]] la usa como tipo · `references` EXTRACTED
- [[BD.MarcarNotificacionLeida()]] la usa como tipo · `references` EXTRACTED
