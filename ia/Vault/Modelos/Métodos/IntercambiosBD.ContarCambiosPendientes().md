---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD/IntercambiosBD.cs"
graphify_ids:
  - "models_bd_intercambiosbd_swappit_models_intercambiosbd_contarcambiospendientes"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# IntercambiosBD.ContarCambiosPendientes()

Método de `IntercambiosBD` ([[BD]]) · `Models/BD/IntercambiosBD.cs` línea 160. Parámetros: `int,int,bool`.

Llama al SP [[SP ContarCambiosPendientes]] con `CommandType.StoredProcedure`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- llama al SP [[SP ContarCambiosPendientes]] · `calls_sp` EXTRACTED

**Desde otras notas:**
- [[IntercambioController.Aceptar()]] la llama · `calls` EXTRACTED
- [[IntercambioController.MarcarRealizado()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
