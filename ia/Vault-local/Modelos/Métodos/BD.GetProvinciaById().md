---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD.cs"
graphify_ids:
  - "models_bd_swappit_models_bd_getprovinciabyid"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# BD.GetProvinciaById()

Método de [[BD]] · `Models/BD.cs` línea 52. Parámetros: `int`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Provincias]] · `reads_from` EXTRACTED
- usa el tipo [[Provincias]] · `references` EXTRACTED
- tiene un SP con el mismo nombre [[SP GetProvinciaById]] · `same_name_as_sp` INFERRED

**Desde otras notas:**
- [[ArticulosController.Detalle()]] la llama · `calls` EXTRACTED
- [[PerfilController.Index()]] la llama · `calls` EXTRACTED
- [[PerfilController.Publico()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
