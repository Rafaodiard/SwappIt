---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD/ArticulosBD.cs"
graphify_ids:
  - "models_bd_articulosbd_swappit_models_articulosbd_getestadosarticulos"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# ArticulosBD.GetEstadosArticulos()

Método de `ArticulosBD` ([[BD]]) · `Models/BD/ArticulosBD.cs` línea 115.

Llama al SP [[SP GetEstadosArticulos]] con `CommandType.StoredProcedure`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- llama al SP [[SP GetEstadosArticulos]] · `calls_sp` EXTRACTED
- usa el tipo [[EstadosArticulos]] · `references` EXTRACTED
- usa el tipo [[List]] · `references` EXTRACTED

**Desde otras notas:**
- [[PublicarController.ObtenerEstados()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
