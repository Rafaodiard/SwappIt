---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD/ArticulosBD.cs"
graphify_ids:
  - "models_bd_articulosbd_swappit_models_articulosbd_contararticulosactivos"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# ArticulosBD.ContarArticulosActivos()

Método de `ArticulosBD` ([[BD]]) · `Models/BD/ArticulosBD.cs` línea 67. Parámetros: `int`.

Llama al SP [[SP ContarArticulosActivos]] con `CommandType.StoredProcedure`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- llama al SP [[SP ContarArticulosActivos]] · `calls_sp` EXTRACTED

**Desde otras notas:**
- [[HomeController.Inicio()]] la llama · `calls` EXTRACTED
- [[PublicarController.Index() GET]] la llama · `calls` EXTRACTED
- [[PublicarController.Index() POST]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
