---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD/RecomendacionesBD.cs"
graphify_ids:
  - "models_bd_recomendacionesbd_swappit_models_recomendacionesbd_registrarbusqueda"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# RecomendacionesBD.RegistrarBusqueda()

Método de `RecomendacionesBD` ([[BD]]) · `Models/BD/RecomendacionesBD.cs` línea 30. Parámetros: `int,string?,IReadOnlyCollection<int>,int`.

Llama al SP [[SP RegistrarBusqueda]] con `CommandType.StoredProcedure`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- llama a [[ConexionBD.ListaDeIds()]] · `calls` EXTRACTED
- llama al SP [[SP RegistrarBusqueda]] · `calls_sp` EXTRACTED
- usa el tipo [[IReadOnlyCollection]] · `references` EXTRACTED

**Desde otras notas:**
- [[RecomendacionesController]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
