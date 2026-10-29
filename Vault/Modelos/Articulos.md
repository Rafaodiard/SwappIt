---
tipo: modelo
comunidad: "Modelo Articulos"
archivos:
  - "Models/Articulos.cs"
graphify_ids:
  - "models_articulos_swappit_models_articulos"
  - "models_articulos"
  - "models_articulos_swappit_models_articulos_acambio"
  - "models_articulos_swappit_models_articulos_descripcion"
  - "models_articulos_swappit_models_articulos_idarticulos"
  - "models_articulos_swappit_models_articulos_idcategorias"
  - "models_articulos_swappit_models_articulos_idestado"
  - "models_articulos_swappit_models_articulos_idusuarios"
  - "models_articulos_swappit_models_articulos_nombre"
  - "models_articulos_swappit_models_articulos_ubicacion"
tags:
  - tipo/modelo
  - comunidad/Modelo_Articulos
---
# Articulos (modelo)

`Models/Articulos.cs` · Una fila de [[Tabla Articulos]]. `IdEstado` apunta a [[Tabla EstadosArticulos]]. `Ubicacion` y `ACambio` son opcionales. Para las cards se usa [[ArticuloCardViewModel]] en su lugar.

Comunidad del grafo: [[Comunidad - Modelo Articulos]]

## Propiedades
`ACambio` · `Descripcion` · `IdArticulos` · `IdCategorias` · `IdEstado` · `IdUsuarios` · `Nombre` · `Ubicacion`

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Models]] · `contains` EXTRACTED
- corresponde a la tabla [[Tabla Articulos]] · `maps_to` INFERRED

**Desde otras notas:**
- [[PublicarController.Index() POST]] la llama · `calls` INFERRED
- [[BD.GetArticuloById()]] la usa como tipo · `references` EXTRACTED
- [[BD.PublicarArticulo()]] la usa como tipo · `references` EXTRACTED
