---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD.cs"
graphify_ids:
  - "models_bd_swappit_models_bd_getarticuloscatalogo"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# BD.GetArticulosCatalogo()

Método de [[BD]] · `Models/BD.cs` línea 120. Parámetros: `string?,int?,IReadOnlyCollection&lt;int&gt;?,IReadOnlyCollection&lt;int&gt;?,int?`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- llama a [[BD.PatronBusqueda()]] · `calls` EXTRACTED
- lee de [[Tabla Articulos]] · `reads_from` EXTRACTED
- lee de [[Tabla EstadosArticulos]] · `reads_from` EXTRACTED
- lee de [[Tabla Imagenes]] · `reads_from` EXTRACTED
- lee de [[Tabla Usuarios]] · `reads_from` EXTRACTED
- usa el tipo [[ArticuloCardViewModel]] · `references` EXTRACTED
- usa el tipo [[IReadOnlyCollection]] · `references` EXTRACTED
- usa el tipo [[List]] · `references` EXTRACTED
- tiene un SP con el mismo nombre [[SP GetArticulosCatalogo]] · `same_name_as_sp` INFERRED

**Desde otras notas:**
- [[ArticulosController.Buscar()]] la llama · `calls` EXTRACTED
- [[ArticulosController.Detalle()]] la llama · `calls` EXTRACTED
- [[HomeController.Index()]] la llama · `calls` EXTRACTED
- [[PerfilController.Index()]] la llama · `calls` EXTRACTED
- [[PerfilController.Publico()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
