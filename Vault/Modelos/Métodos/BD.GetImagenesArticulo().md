---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD.cs"
graphify_ids:
  - "models_bd_swappit_models_bd_getimagenesarticulo"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# BD.GetImagenesArticulo()

Método de [[BD]] · `Models/BD.cs` línea 203. Parámetros: `int`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Imagenes]] · `reads_from` EXTRACTED
- usa el tipo [[List]] · `references` EXTRACTED
- tiene un SP con el mismo nombre [[SP GetImagenesArticulo]] · `same_name_as_sp` INFERRED

**Desde otras notas:**
- [[ArticulosController.Detalle()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
