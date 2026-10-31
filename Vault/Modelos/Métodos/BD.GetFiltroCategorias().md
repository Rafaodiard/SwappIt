---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD.cs"
graphify_ids:
  - "models_bd_swappit_models_bd_getfiltrocategorias"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# BD.GetFiltroCategorias()

Método de [[BD]] · `Models/BD.cs` línea 251. Parámetros: `string?,int?`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- llama a [[BD.PatronBusqueda()]] · `calls` EXTRACTED
- lee de [[Tabla Articulos]] · `reads_from` EXTRACTED
- lee de [[Tabla Categorias]] · `reads_from` EXTRACTED
- lee de [[Tabla EstadosIntercambios]] · `reads_from` EXTRACTED
- lee de [[Tabla Intercambios]] · `reads_from` EXTRACTED
- usa el tipo [[List]] · `references` EXTRACTED
- usa el tipo [[OpcionFiltroViewModel]] · `references` EXTRACTED
- tiene un SP con el mismo nombre [[SP GetFiltroCategorias]] · `same_name_as_sp` INFERRED

**Desde otras notas:**
- [[ArticulosController.Buscar()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
