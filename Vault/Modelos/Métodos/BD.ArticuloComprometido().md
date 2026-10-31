---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD.cs"
graphify_ids:
  - "models_bd_swappit_models_bd_articulocomprometido"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# BD.ArticuloComprometido()

Método de [[BD]] · `Models/BD.cs` línea 352. Parámetros: `int`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Articulos]] · `reads_from` EXTRACTED
- lee de [[Tabla EstadosIntercambios]] · `reads_from` EXTRACTED
- lee de [[Tabla Intercambios]] · `reads_from` EXTRACTED

**Desde otras notas:**
- [[ArticulosController.Detalle()]] la llama · `calls` EXTRACTED
- [[IntercambioController.Detalle()]] la llama · `calls` EXTRACTED
- [[IntercambioController.Proponer()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
