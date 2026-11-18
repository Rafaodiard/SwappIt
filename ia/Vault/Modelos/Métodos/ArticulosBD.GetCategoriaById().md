---
tipo: metodo
comunidad: "Categorías"
archivos:
  - "Models/BD/ArticulosBD.cs"
graphify_ids:
  - "models_bd_articulosbd_swappit_models_articulosbd_getcategoriabyid"
tags:
  - tipo/metodo
  - comunidad/Categorías
---
# ArticulosBD.GetCategoriaById()

Método de `ArticulosBD` ([[BD]]) · `Models/BD/ArticulosBD.cs` línea 97. Parámetros: `int`.

Llama al SP [[SP GetCategoriaById]] con `CommandType.StoredProcedure`.

Comunidad del grafo: [[Comunidad - Categorías]]

## Conexiones en el grafo (graphify)
- llama al SP [[SP GetCategoriaById]] · `calls_sp` EXTRACTED
- usa el tipo [[Categorias]] · `references` EXTRACTED

**Desde otras notas:**
- [[ArticulosController.Detalle()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
