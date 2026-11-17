---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD/IntercambiosBD.cs"
graphify_ids:
  - "models_bd_intercambiosbd_swappit_models_intercambiosbd_crearpedido"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# IntercambiosBD.CrearPedido()

Método de `IntercambiosBD` ([[BD]]) · `Models/BD/IntercambiosBD.cs` línea 211. Parámetros: `int,int,int,string,List<NotificacionCreada>?`. Privado.

Llama al SP [[SP CrearPedido]] con `CommandType.StoredProcedure`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- llama a [[NotificacionesBD.LeerCreadas()]] · `calls` EXTRACTED
- llama al SP [[SP CrearPedido]] · `calls_sp` EXTRACTED
- usa el tipo [[List]] · `references` EXTRACTED

**Desde otras notas:**
- [[IntercambiosBD.PedirArticulo()]] la llama · `calls` EXTRACTED
- [[IntercambiosBD.PedirSacarArticulo()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
