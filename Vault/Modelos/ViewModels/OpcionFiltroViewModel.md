---
tipo: modelo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/ViewModels/OpcionFiltroViewModel.cs"
  - "Views/Articulos/Buscar.cshtml"
graphify_ids:
  - "models_viewmodels_opcionfiltroviewmodel_swappit_models_viewmodels_opcionfiltroviewmodel"
  - "models_viewmodels_opcionfiltroviewmodel"
  - "models_viewmodels_opcionfiltroviewmodel_swappit_models_viewmodels_opcionfiltroviewmodel_cantidad"
  - "models_viewmodels_opcionfiltroviewmodel_swappit_models_viewmodels_opcionfiltroviewmodel_texto"
  - "models_viewmodels_opcionfiltroviewmodel_swappit_models_viewmodels_opcionfiltroviewmodel_valor"
  - "views_articulos_buscar_cshtml_opcionfiltroviewmodel"
tags:
  - tipo/modelo
  - comunidad/Tablas_y_acceso_a_datos
---
# OpcionFiltroViewModel

`Models/ViewModels/OpcionFiltroViewModel.cs` · Una opción de los filtros de [[Vista Articulos-Buscar]] (categoría o estado): Valor, Texto y Cantidad de artículos. Lo devuelven [[BD]].GetFiltroCategorias y GetFiltroEstados.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Propiedades
`Cantidad` · `Texto` · `Valor`

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Models.ViewModels]] · `contains` EXTRACTED

**Desde otras notas:**
- [[Vista Articulos-Buscar]] la llama · `calls` EXTRACTED
- [[BD.GetFiltroCategorias()]] la usa como tipo · `references` EXTRACTED
- [[BD.GetFiltroEstados()]] la usa como tipo · `references` EXTRACTED
