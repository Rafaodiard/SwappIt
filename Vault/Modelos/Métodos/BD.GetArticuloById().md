---
tipo: metodo
comunidad: "Modelo Articulos"
archivos:
  - "Models/BD.cs"
graphify_ids:
  - "models_bd_swappit_models_bd_getarticulobyid"
tags:
  - tipo/metodo
  - comunidad/Modelo_Articulos
---
# BD.GetArticuloById()

Método de [[BD]] · `Models/BD.cs` línea 166. Parámetros: `int`.

Comunidad del grafo: [[Comunidad - Modelo Articulos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Articulos]] · `reads_from` EXTRACTED
- usa el tipo [[Articulos]] · `references` EXTRACTED
- tiene un SP con el mismo nombre [[SP GetArticuloById]] · `same_name_as_sp` INFERRED

**Desde otras notas:**
- [[ArticulosController.Detalle()]] la llama · `calls` EXTRACTED
- [[IntercambioController.Proponer()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
