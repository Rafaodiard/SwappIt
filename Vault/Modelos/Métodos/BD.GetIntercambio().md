---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD.cs"
graphify_ids:
  - "models_bd_swappit_models_bd_getintercambio"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# BD.GetIntercambio()

Método de [[BD]] · `Models/BD.cs` línea 324. Parámetros: `int,int`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Articulos]] · `reads_from` EXTRACTED
- lee de [[Tabla EstadosArticulos]] · `reads_from` EXTRACTED
- lee de [[Tabla EstadosIntercambios]] · `reads_from` EXTRACTED
- lee de [[Tabla Imagenes]] · `reads_from` EXTRACTED
- lee de [[Tabla Intercambios]] · `reads_from` EXTRACTED
- lee de [[Tabla Provincias]] · `reads_from` EXTRACTED
- lee de [[Tabla Usuarios]] · `reads_from` EXTRACTED
- usa el tipo [[IntercambioViewModel]] · `references` EXTRACTED

**Desde otras notas:**
- [[IntercambioController.Detalle()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
