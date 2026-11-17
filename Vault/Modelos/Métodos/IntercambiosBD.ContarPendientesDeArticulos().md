---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD/IntercambiosBD.cs"
graphify_ids:
  - "models_bd_intercambiosbd_swappit_models_intercambiosbd_contarpendientesdearticulos"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# IntercambiosBD.ContarPendientesDeArticulos()

Método de `IntercambiosBD` ([[BD]]) · `Models/BD/IntercambiosBD.cs` línea 138. Parámetros: `int`.

Llama al SP [[SP ContarPendientesDeArticulos]] con `CommandType.StoredProcedure`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- llama al SP [[SP ContarPendientesDeArticulos]] · `calls_sp` EXTRACTED

**Desde otras notas:**
- [[IntercambioController.Aceptar()]] la llama · `calls` EXTRACTED
- [[IntercambioController.Detalle()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
