---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD/ArticulosBD.cs"
graphify_ids:
  - "models_bd_articulosbd_swappit_models_articulosbd_getfiltroestados"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# ArticulosBD.GetFiltroEstados()

Método de `ArticulosBD` ([[BD]]) · `Models/BD/ArticulosBD.cs` línea 148. Parámetros: `string?,int?`.

Llama al SP [[SP GetFiltroEstados]] con `CommandType.StoredProcedure`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- llama a [[ArticulosBD.TextoBusqueda()]] · `calls` EXTRACTED
- llama al SP [[SP GetFiltroEstados]] · `calls_sp` EXTRACTED
- usa el tipo [[List]] · `references` EXTRACTED
- usa el tipo [[OpcionFiltroViewModel]] · `references` EXTRACTED

**Desde otras notas:**
- [[ArticulosController.Buscar()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
