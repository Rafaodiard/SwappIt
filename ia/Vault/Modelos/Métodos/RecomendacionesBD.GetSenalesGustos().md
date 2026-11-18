---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD/RecomendacionesBD.cs"
graphify_ids:
  - "models_bd_recomendacionesbd_swappit_models_recomendacionesbd_getsenalesgustos"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# RecomendacionesBD.GetSenalesGustos()

Método de `RecomendacionesBD` ([[BD]]) · `Models/BD/RecomendacionesBD.cs` línea 40. Parámetros: `IReadOnlyCollection<int>,DateTime`.

Llama al SP [[SP GetSenalesGustos]] con `CommandType.StoredProcedure`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- llama a [[ConexionBD.ListaDeIds()]] · `calls` EXTRACTED
- llama al SP [[SP GetSenalesGustos]] · `calls_sp` EXTRACTED
- usa el tipo [[DateTime]] · `references` EXTRACTED
- usa el tipo [[IReadOnlyCollection]] · `references` EXTRACTED
- usa el tipo [[List]] · `references` EXTRACTED

**Desde otras notas:**
- [[RecomendacionesController]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
