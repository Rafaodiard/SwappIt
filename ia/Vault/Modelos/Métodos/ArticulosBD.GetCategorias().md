---
tipo: metodo
comunidad: "Categorías"
archivos:
  - "Models/BD/ArticulosBD.cs"
graphify_ids:
  - "models_bd_articulosbd_swappit_models_articulosbd_getcategorias"
tags:
  - tipo/metodo
  - comunidad/Categorías
---
# ArticulosBD.GetCategorias()

Método de `ArticulosBD` ([[BD]]) · `Models/BD/ArticulosBD.cs` línea 107.

Llama al SP [[SP GetCategorias]] con `CommandType.StoredProcedure`.

Comunidad del grafo: [[Comunidad - Categorías]]

## Conexiones en el grafo (graphify)
- llama al SP [[SP GetCategorias]] · `calls_sp` EXTRACTED
- usa el tipo [[Categorias]] · `references` EXTRACTED
- usa el tipo [[List]] · `references` EXTRACTED

**Desde otras notas:**
- [[PublicarController.ObtenerCategorias()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
