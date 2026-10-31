---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD.cs"
graphify_ids:
  - "models_bd_swappit_models_bd_getmensajes"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# BD.GetMensajes()

Método de [[BD]] · `Models/BD.cs` línea 654. Parámetros: `int,int`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Intercambios]] · `reads_from` EXTRACTED
- lee de [[Tabla Mensajes]] · `reads_from` EXTRACTED
- usa el tipo [[List]] · `references` EXTRACTED
- usa el tipo [[Mensajes]] · `references` EXTRACTED

**Desde otras notas:**
- [[ChatController.Index()]] la llama · `calls` EXTRACTED
- [[ChatController.Mensajes()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
