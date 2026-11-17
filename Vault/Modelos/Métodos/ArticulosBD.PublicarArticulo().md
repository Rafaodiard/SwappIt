---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD/ArticulosBD.cs"
graphify_ids:
  - "models_bd_articulosbd_swappit_models_articulosbd_publicararticulo"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# ArticulosBD.PublicarArticulo()

Método de `ArticulosBD` ([[BD]]) · `Models/BD/ArticulosBD.cs` línea 47. Parámetros: `Articulos,List<string>`.

Llama al SP [[SP PublicarArticulo]] con `CommandType.StoredProcedure`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- llama al SP [[SP PublicarArticulo]] · `calls_sp` EXTRACTED
- usa el tipo [[Articulos]] · `references` EXTRACTED
- usa el tipo [[List]] · `references` EXTRACTED

**Desde otras notas:**
- [[PublicarController.Index() POST]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
