---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD/IntercambiosBD.cs"
graphify_ids:
  - "models_bd_intercambiosbd_swappit_models_intercambiosbd_cambiarestadointercambio"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# IntercambiosBD.CambiarEstadoIntercambio()

Método de `IntercambiosBD` ([[BD]]) · `Models/BD/IntercambiosBD.cs` línea 107. Parámetros: `int,int,string,string,bool,string?,List<NotificacionCreada>?,int?`.

Llama al SP [[SP CambiarEstadoIntercambio]] con `CommandType.StoredProcedure`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- llama a [[NotificacionesBD.LeerCreadas()]] · `calls` EXTRACTED
- llama al SP [[SP CambiarEstadoIntercambio]] · `calls_sp` EXTRACTED
- usa el tipo [[List]] · `references` EXTRACTED

**Desde otras notas:**
- [[IntercambioController.CambiarEstado()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
