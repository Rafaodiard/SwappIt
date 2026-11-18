---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD/ArticulosBD.cs"
graphify_ids:
  - "models_bd_articulosbd_swappit_models_articulosbd_getestadoarticulobyid"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# ArticulosBD.GetEstadoArticuloById()

Método de `ArticulosBD` ([[BD]]) · `Models/BD/ArticulosBD.cs` línea 123. Parámetros: `int`.

Llama al SP [[SP GetEstadoArticuloById]] con `CommandType.StoredProcedure`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- llama al SP [[SP GetEstadoArticuloById]] · `calls_sp` EXTRACTED
- usa el tipo [[EstadosArticulos]] · `references` EXTRACTED

**Desde otras notas:**
- [[ArticulosController.Detalle()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
