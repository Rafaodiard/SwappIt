---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD.cs"
graphify_ids:
  - "models_bd_swappit_models_bd_crearnotificacion"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# BD.CrearNotificacion()

Método de [[BD]] · `Models/BD.cs` línea 558. Parámetros: `SqlConnection,SqlTransaction,int,int,string,bool`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla TipoNotificaciones]] · `reads_from` EXTRACTED
- usa el tipo [[SqlConnection]] · `references` EXTRACTED
- usa el tipo [[SqlTransaction]] · `references` EXTRACTED
- escribe en [[Tabla Notificaciones]] · `writes_to` EXTRACTED

**Desde otras notas:**
- [[BD.CambiarEstadoIntercambio()]] la llama · `calls` EXTRACTED
- [[BD.CancelarIntercambio()]] la llama · `calls` EXTRACTED
- [[BD.EnviarMensaje()]] la llama · `calls` EXTRACTED
- [[BD.ProponerIntercambio()]] la llama · `calls` EXTRACTED
- [[BD.RechazarPendientesDeArticulos()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
