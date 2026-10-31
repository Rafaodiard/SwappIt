---
tipo: metodo
comunidad: "Controllers, vistas y JS"
archivos:
  - "Models/BD.cs"
graphify_ids:
  - "models_bd_swappit_models_bd_getprovinciabyid"
tags:
  - tipo/metodo
  - comunidad/Controllers_vistas_y_JS
---
# BD.GetProvinciaById()

Método de [[BD]] · `Models/BD.cs` línea 52. Parámetros: `int`.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Provincias]] · `reads_from` EXTRACTED
- usa el tipo [[Provincias]] · `references` EXTRACTED
- tiene un SP con el mismo nombre [[SP GetProvinciaById]] · `same_name_as_sp` INFERRED

**Desde otras notas:**
- [[ArticulosController.Detalle()]] la llama · `calls` EXTRACTED
- [[PerfilController.Index()]] la llama · `calls` EXTRACTED
- [[PerfilController.Publico()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
