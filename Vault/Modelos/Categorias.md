---
tipo: modelo
comunidad: "Categorías"
archivos:
  - "Models/Categorias.cs"
graphify_ids:
  - "models_categorias_swappit_models_categorias"
  - "models_categorias"
  - "models_categorias_swappit_models_categorias_idcategorias"
  - "models_categorias_swappit_models_categorias_nombre"
tags:
  - tipo/modelo
  - comunidad/Categorías
---
# Categorias (modelo)

`Models/Categorias.cs` · [[Tabla Categorias]]: Tecnología, Libros, Ropa, Hogar, Deportes, Música.

Comunidad del grafo: [[Comunidad - Categorías]]

## Propiedades
`IdCategorias` · `Nombre`

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Models]] · `contains` EXTRACTED
- corresponde a la tabla [[Tabla Categorias]] · `maps_to` INFERRED

**Desde otras notas:**
- [[BD.GetCategoriaById()]] la usa como tipo · `references` EXTRACTED
- [[BD.GetCategorias()]] la usa como tipo · `references` EXTRACTED
