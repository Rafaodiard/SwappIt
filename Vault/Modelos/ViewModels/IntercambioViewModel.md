---
tipo: modelo
comunidad: "Intercambios del usuario"
archivos:
  - "Models/ViewModels/IntercambioViewModel.cs"
graphify_ids:
  - "models_viewmodels_intercambioviewmodel_swappit_models_viewmodels_intercambioviewmodel"
  - "models_viewmodels_intercambioviewmodel"
  - "models_viewmodels_intercambioviewmodel_swappit_models_viewmodels_intercambioviewmodel_esrecibido"
  - "models_viewmodels_intercambioviewmodel_swappit_models_viewmodels_intercambioviewmodel_estado"
  - "models_viewmodels_intercambioviewmodel_swappit_models_viewmodels_intercambioviewmodel_fecha"
  - "models_viewmodels_intercambioviewmodel_swappit_models_viewmodels_intercambioviewmodel_idintercambios"
  - "models_viewmodels_intercambioviewmodel_swappit_models_viewmodels_intercambioviewmodel_miarticuloestado"
  - "models_viewmodels_intercambioviewmodel_swappit_models_viewmodels_intercambioviewmodel_miarticuloid"
  - "models_viewmodels_intercambioviewmodel_swappit_models_viewmodels_intercambioviewmodel_miarticuloimagen"
  - "models_viewmodels_intercambioviewmodel_swappit_models_viewmodels_intercambioviewmodel_miarticulonombre"
  - "models_viewmodels_intercambioviewmodel_swappit_models_viewmodels_intercambioviewmodel_otroapellido"
  - "models_viewmodels_intercambioviewmodel_swappit_models_viewmodels_intercambioviewmodel_otrobarrio"
  - "models_viewmodels_intercambioviewmodel_swappit_models_viewmodels_intercambioviewmodel_otroidusuario"
  - "models_viewmodels_intercambioviewmodel_swappit_models_viewmodels_intercambioviewmodel_otronombre"
  - "models_viewmodels_intercambioviewmodel_swappit_models_viewmodels_intercambioviewmodel_otroprovincia"
  - "models_viewmodels_intercambioviewmodel_swappit_models_viewmodels_intercambioviewmodel_otrousuario"
  - "models_viewmodels_intercambioviewmodel_swappit_models_viewmodels_intercambioviewmodel_suarticuloestado"
  - "models_viewmodels_intercambioviewmodel_swappit_models_viewmodels_intercambioviewmodel_suarticuloid"
  - "models_viewmodels_intercambioviewmodel_swappit_models_viewmodels_intercambioviewmodel_suarticuloimagen"
  - "models_viewmodels_intercambioviewmodel_swappit_models_viewmodels_intercambioviewmodel_suarticulonombre"
tags:
  - tipo/modelo
  - comunidad/Intercambios_del_usuario
---
# IntercambioViewModel

`Models/ViewModels/IntercambioViewModel.cs` · Un intercambio visto desde el usuario logueado (Mis intercambios, Ver intercambio, chat, historial de Mi perfil e inicio). Sale de [[Tabla Intercambios]] + estado + los dos artículos (con su estado y primera foto) + la otra persona. [[BD.GetIntercambios()]] lo da vuelta para que **Mi...** sea siempre lo del usuario logueado y **Su...**/**Otro...** lo de la otra persona. `EsRecibido`: la propuesta la recibió el usuario (es el dueño del artículo pedido).

Comunidad del grafo: [[Comunidad - Intercambios del usuario]]

## Propiedades
`EsRecibido` · `Estado` · `Fecha` · `IdIntercambios` · `MiArticuloEstado` · `MiArticuloId` · `MiArticuloImagen` · `MiArticuloNombre` · `OtroApellido` · `OtroBarrio` · `OtroIdUsuario` · `OtroNombre` · `OtroProvincia` · `OtroUsuario` · `SuArticuloEstado` · `SuArticuloId` · `SuArticuloImagen` · `SuArticuloNombre`

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Models.ViewModels]] · `contains` EXTRACTED
- usa el tipo [[DateTime]] · `references` EXTRACTED

**Desde otras notas:**
- [[BD.GetIntercambio()]] la usa como tipo · `references` EXTRACTED
- [[BD.GetIntercambios()]] la usa como tipo · `references` EXTRACTED
- [[HomeController.PorResponder()]] la usa como tipo · `references` EXTRACTED
