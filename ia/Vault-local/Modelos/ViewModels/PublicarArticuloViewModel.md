---
tipo: modelo
comunidad: "Publicar artículo"
archivos:
  - "Models/ViewModels/PublicarArticuloViewModel.cs"
graphify_ids:
  - "models_viewmodels_publicararticuloviewmodel_swappit_models_viewmodels_publicararticuloviewmodel"
  - "models_viewmodels_publicararticuloviewmodel"
  - "models_viewmodels_publicararticuloviewmodel_swappit_models_viewmodels_publicararticuloviewmodel_acambio"
  - "models_viewmodels_publicararticuloviewmodel_swappit_models_viewmodels_publicararticuloviewmodel_descripcion"
  - "models_viewmodels_publicararticuloviewmodel_swappit_models_viewmodels_publicararticuloviewmodel_fotos"
  - "models_viewmodels_publicararticuloviewmodel_swappit_models_viewmodels_publicararticuloviewmodel_idcategorias"
  - "models_viewmodels_publicararticuloviewmodel_swappit_models_viewmodels_publicararticuloviewmodel_idestado"
  - "models_viewmodels_publicararticuloviewmodel_swappit_models_viewmodels_publicararticuloviewmodel_titulo"
  - "models_viewmodels_publicararticuloviewmodel_swappit_models_viewmodels_publicararticuloviewmodel_ubicacion"
tags:
  - tipo/modelo
  - comunidad/Publicar_artículo
---
# PublicarArticuloViewModel

`Models/ViewModels/PublicarArticuloViewModel.cs` · Form de [[Vista Publicar-Index]]. Constantes `MaxFotos = 6`, `MaxFotoMB = 10`, `MaxDescripcion = 500`. Campos: Titulo (→ `Articulos.Nombre`, 50), IdCategorias, Ubicacion (100), IdEstado, Descripcion (500), ACambio (opcional, 100), Fotos. La vista y [[publicar.js]] leen los límites de acá. Lo usa [[PublicarController]].

Comunidad del grafo: [[Comunidad - Publicar artículo]]

## Propiedades
`ACambio` · `Descripcion` · `Fotos` · `IdCategorias` · `IdEstado` · `Titulo` · `Ubicacion`

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Models.ViewModels]] · `contains` EXTRACTED
- importa [[System.ComponentModel.DataAnnotations]] · `imports` EXTRACTED
- usa el tipo [[IFormFile]] · `references` EXTRACTED
- usa el tipo [[List]] · `references` EXTRACTED

**Desde otras notas:**
- [[PublicarController.Index() GET]] la llama · `calls` INFERRED
- [[PublicarController.Index() POST]] la usa como tipo · `references` EXTRACTED
