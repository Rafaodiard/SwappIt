---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD.cs"
graphify_ids:
  - "models_bd_swappit_models_bd_getprovincias"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# BD.GetProvincias()

Método de [[BD]] · `Models/BD.cs` línea 61.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Provincias]] · `reads_from` EXTRACTED
- usa el tipo [[List]] · `references` EXTRACTED
- usa el tipo [[Provincias]] · `references` EXTRACTED
- tiene un SP con el mismo nombre [[SP GetProvincias]] · `same_name_as_sp` INFERRED

**Desde otras notas:**
- [[PerfilController.Index()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
