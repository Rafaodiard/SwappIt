---
tipo: metodo
comunidad: "Categorías"
archivos:
  - "Models/BD.cs"
graphify_ids:
  - "models_bd_swappit_models_bd_getcategoriabyid"
tags:
  - tipo/metodo
  - comunidad/Categorías
---
# BD.GetCategoriaById()

Método de [[BD]] · `Models/BD.cs` línea 212. Parámetros: `int`.

Comunidad del grafo: [[Comunidad - Categorías]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Categorias]] · `reads_from` EXTRACTED
- usa el tipo [[Categorias]] · `references` EXTRACTED
- tiene un SP con el mismo nombre [[SP GetCategoriaById]] · `same_name_as_sp` INFERRED

**Desde otras notas:**
- [[ArticulosController.Detalle()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
