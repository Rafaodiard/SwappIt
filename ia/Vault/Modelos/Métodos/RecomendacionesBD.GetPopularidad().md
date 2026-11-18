---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD/RecomendacionesBD.cs"
graphify_ids:
  - "models_bd_recomendacionesbd_swappit_models_recomendacionesbd_getpopularidad"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# RecomendacionesBD.GetPopularidad()

Método de `RecomendacionesBD` ([[BD]]) · `Models/BD/RecomendacionesBD.cs` línea 51.

Llama al SP [[SP GetPopularidad]] con `CommandType.StoredProcedure`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- llama al SP [[SP GetPopularidad]] · `calls_sp` EXTRACTED
- usa el tipo [[List]] · `references` EXTRACTED
- usa el tipo [[PopularidadArticulo]] · `references` EXTRACTED

**Desde otras notas:**
- [[RecomendacionesController]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
