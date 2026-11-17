---
tipo: modelo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/CantidadPorEstado.cs"
graphify_ids:
  - "models_cantidadporestado_swappit_models_cantidadporestado"
  - "models_cantidadporestado"
  - "models_cantidadporestado_swappit_models_cantidadporestado_cantidad"
  - "models_cantidadporestado_swappit_models_cantidadporestado_estado"
  - "models_cantidadporestado_swappit_models_cantidadporestado_porresponder"
tags:
  - tipo/modelo
  - comunidad/Tablas_y_acceso_a_datos
---
# CantidadPorEstado

`Models/CantidadPorEstado.cs` · Una fila de [[SP ContarIntercambiosPorEstado]]: `Estado`, `Cantidad` y `PorResponder`. La usan [[IntercambioController]] (pestañas de Mis intercambios) y [[HomeController]] (contadores del inicio).

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Models]] · `contains` EXTRACTED

**Desde otras notas:**
- [[IntercambiosBD.ContarIntercambiosPorEstado()]] la usa como tipo · `references` EXTRACTED
