---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD/ArticulosBD.cs"
graphify_ids:
  - "models_bd_articulosbd_swappit_models_articulosbd_getimagenesarticulo"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# ArticulosBD.GetImagenesArticulo()

Método de `ArticulosBD` ([[BD]]) · `Models/BD/ArticulosBD.cs` línea 87. Parámetros: `int`.

Llama al SP [[SP GetImagenesArticulo]] con `CommandType.StoredProcedure`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- llama al SP [[SP GetImagenesArticulo]] · `calls_sp` EXTRACTED
- usa el tipo [[List]] · `references` EXTRACTED

**Desde otras notas:**
- [[ArticulosController.Detalle()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
