---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD.cs"
graphify_ids:
  - "models_bd_swappit_models_bd_proponerintercambio"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# BD.ProponerIntercambio()

Método de [[BD]] · `Models/BD.cs` línea 365. Parámetros: `int,int,int,int`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- llama a [[BD.CrearNotificacion()]] · `calls` EXTRACTED
- lee de [[Tabla EstadosIntercambios]] · `reads_from` EXTRACTED
- lee de [[Tabla Intercambios]] · `reads_from` EXTRACTED
- escribe en [[Tabla Intercambios]] · `writes_to` EXTRACTED

**Desde otras notas:**
- [[IntercambioController.Proponer()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
