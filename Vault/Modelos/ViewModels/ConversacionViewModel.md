---
tipo: modelo
comunidad: "Resumen del chat"
archivos:
  - "Models/ViewModels/ConversacionViewModel.cs"
graphify_ids:
  - "models_viewmodels_conversacionviewmodel_swappit_models_viewmodels_conversacionviewmodel"
  - "models_viewmodels_conversacionviewmodel"
  - "models_viewmodels_conversacionviewmodel_swappit_models_viewmodels_conversacionviewmodel_idintercambio"
  - "models_viewmodels_conversacionviewmodel_swappit_models_viewmodels_conversacionviewmodel_noleidos"
  - "models_viewmodels_conversacionviewmodel_swappit_models_viewmodels_conversacionviewmodel_ultimafecha"
  - "models_viewmodels_conversacionviewmodel_swappit_models_viewmodels_conversacionviewmodel_ultimoesmio"
  - "models_viewmodels_conversacionviewmodel_swappit_models_viewmodels_conversacionviewmodel_ultimotexto"
tags:
  - tipo/modelo
  - comunidad/Resumen_del_chat
---
# ConversacionViewModel

`Models/ViewModels/ConversacionViewModel.cs` · Resumen del chat de un intercambio para la lista de conversaciones de [[Vista Chat-Index]]: último mensaje (`UltimoTexto`, `UltimaFecha`, `UltimoEsMio` para mostrar "Vos: ...") y cuántos mensajes de la otra persona no vio (`NoLeidos`). Sale de [[Tabla Mensajes]] con [[BD.GetResumenesChat()]]. El inicio suma los `NoLeidos` para "mensajes sin leer".

Comunidad del grafo: [[Comunidad - Resumen del chat]]

## Propiedades
`IdIntercambio` · `NoLeidos` · `UltimaFecha` · `UltimoEsMio` · `UltimoTexto`

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Models.ViewModels]] · `contains` EXTRACTED
- usa el tipo [[DateTime]] · `references` EXTRACTED

**Desde otras notas:**
- [[BD.GetResumenesChat()]] la usa como tipo · `references` EXTRACTED
