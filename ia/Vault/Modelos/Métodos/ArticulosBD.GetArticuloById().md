---
tipo: metodo
comunidad: "Modelo Articulos"
archivos:
  - "Models/BD/ArticulosBD.cs"
graphify_ids:
  - "models_bd_articulosbd_swappit_models_articulosbd_getarticulobyid"
tags:
  - tipo/metodo
  - comunidad/Modelo_Articulos
---
# ArticulosBD.GetArticuloById()

Método de `ArticulosBD` ([[BD]]) · `Models/BD/ArticulosBD.cs` línea 37. Parámetros: `int`.

Llama al SP [[SP GetArticuloById]] con `CommandType.StoredProcedure`.

Comunidad del grafo: [[Comunidad - Modelo Articulos]]

## Conexiones en el grafo (graphify)
- llama al SP [[SP GetArticuloById]] · `calls_sp` EXTRACTED
- usa el tipo [[Articulos]] · `references` EXTRACTED

**Desde otras notas:**
- [[ArticulosController.Detalle()]] la llama · `calls` EXTRACTED
- [[IntercambioController.Proponer()]] la llama · `calls` EXTRACTED
- [[RecomendacionesController]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
