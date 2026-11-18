---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD/IntercambiosBD.cs"
graphify_ids:
  - "models_bd_intercambiosbd_swappit_models_intercambiosbd_getintercambio"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# IntercambiosBD.GetIntercambio()

Método de `IntercambiosBD` ([[BD]]) · `Models/BD/IntercambiosBD.cs` línea 31. Parámetros: `int,int`.

Llama al SP [[SP GetIntercambios]] con `CommandType.StoredProcedure`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- llama al SP [[SP GetIntercambios]] · `calls_sp` EXTRACTED
- usa el tipo [[IntercambioViewModel]] · `references` EXTRACTED

**Desde otras notas:**
- [[ChatController.Index()]] la llama · `calls` EXTRACTED
- [[IntercambioController.Aceptar()]] la llama · `calls` EXTRACTED
- [[IntercambioController.Detalle()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
