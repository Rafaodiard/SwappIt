---
tipo: modelo
comunidad: "Card de artículo"
archivos:
  - "Models/ViewModels/ArticuloCardViewModel.cs"
  - "Views/Articulos/Buscar.cshtml"
graphify_ids:
  - "models_viewmodels_articulocardviewmodel_swappit_models_viewmodels_articulocardviewmodel"
  - "models_viewmodels_articulocardviewmodel"
  - "models_viewmodels_articulocardviewmodel_swappit_models_viewmodels_articulocardviewmodel_barrio"
  - "models_viewmodels_articulocardviewmodel_swappit_models_viewmodels_articulocardviewmodel_estado"
  - "models_viewmodels_articulocardviewmodel_swappit_models_viewmodels_articulocardviewmodel_idarticulos"
  - "models_viewmodels_articulocardviewmodel_swappit_models_viewmodels_articulocardviewmodel_imagen"
  - "models_viewmodels_articulocardviewmodel_swappit_models_viewmodels_articulocardviewmodel_nombre"
  - "views_articulos_buscar_cshtml_articulocardviewmodel"
tags:
  - tipo/modelo
  - comunidad/Card_de_artículo
---
# ArticuloCardViewModel

`Models/ViewModels/ArticuloCardViewModel.cs` · Lo que necesita una card ([[Vista _CardObjeto]]): IdArticulos, Nombre, Estado (nombre del estado), Barrio (ubicación del artículo o barrio del dueño) e Imagen (primera foto). Lo devuelve [[BD]].GetArticulosCatalogo.

Comunidad del grafo: [[Comunidad - Card de artículo]]

## Propiedades
`Barrio` · `Estado` · `IdArticulos` · `Imagen` · `Nombre`

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Models.ViewModels]] · `contains` EXTRACTED

**Desde otras notas:**
- [[Vista Articulos-Buscar]] la llama · `calls` EXTRACTED
- [[BD.GetArticulosCatalogo()]] la usa como tipo · `references` EXTRACTED
