---
tipo: metodo
comunidad: "Categorías"
archivos:
  - "Models/BD.cs"
graphify_ids:
  - "models_bd_swappit_models_bd_getcategorias"
tags:
  - tipo/metodo
  - comunidad/Categorías
---
# BD.GetCategorias()

Método de [[BD]] · `Models/BD.cs` línea 221.

Comunidad del grafo: [[Comunidad - Categorías]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Categorias]] · `reads_from` EXTRACTED
- usa el tipo [[Categorias]] · `references` EXTRACTED
- usa el tipo [[List]] · `references` EXTRACTED
- tiene un SP con el mismo nombre [[SP GetCategorias]] · `same_name_as_sp` INFERRED

**Desde otras notas:**
- [[PublicarController.ObtenerCategorias()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
