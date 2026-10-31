---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD.cs"
graphify_ids:
  - "models_bd_swappit_models_bd_cancelarintercambio"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# BD.CancelarIntercambio()

Método de [[BD]] · `Models/BD.cs` línea 463. Parámetros: `int,int`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- llama a [[BD.CrearNotificacion()]] · `calls` EXTRACTED
- lee de [[Tabla EstadosIntercambios]] · `reads_from` EXTRACTED
- escribe en [[Tabla Intercambios]] · `writes_to` EXTRACTED

**Desde otras notas:**
- [[IntercambioController.Cancelar()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
