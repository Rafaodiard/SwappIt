---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD/IntercambiosBD.cs"
graphify_ids:
  - "models_bd_intercambiosbd_swappit_models_intercambiosbd_agregararticulos"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# IntercambiosBD.AgregarArticulos()

Método de `IntercambiosBD` ([[BD]]) · `Models/BD/IntercambiosBD.cs` línea 180. Parámetros: `int,int,IReadOnlyCollection<int>,List<NotificacionCreada>?`.

Llama al SP [[SP AgregarArticulos]] con `CommandType.StoredProcedure`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- llama a [[ConexionBD.ListaDeIds()]] · `calls` EXTRACTED
- llama a [[NotificacionesBD.LeerCreadas()]] · `calls` EXTRACTED
- llama al SP [[SP AgregarArticulos]] · `calls_sp` EXTRACTED
- usa el tipo [[IReadOnlyCollection]] · `references` EXTRACTED
- usa el tipo [[List]] · `references` EXTRACTED

**Desde otras notas:**
- [[BD]] la tiene como método · `method` EXTRACTED
