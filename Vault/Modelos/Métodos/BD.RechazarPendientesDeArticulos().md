---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD.cs"
graphify_ids:
  - "models_bd_swappit_models_bd_rechazarpendientesdearticulos"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# BD.RechazarPendientesDeArticulos()

Método de [[BD]] · `Models/BD.cs` línea 520. Parámetros: `SqlConnection,SqlTransaction,int,int`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- llama a [[BD.CrearNotificacion()]] · `calls` EXTRACTED
- lee de [[Tabla EstadosIntercambios]] · `reads_from` EXTRACTED
- lee de [[Tabla Intercambios]] · `reads_from` EXTRACTED
- usa el tipo [[SqlConnection]] · `references` EXTRACTED
- usa el tipo [[SqlTransaction]] · `references` EXTRACTED
- escribe en [[Tabla Intercambios]] · `writes_to` EXTRACTED

**Desde otras notas:**
- [[BD.CambiarEstadoIntercambio()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
