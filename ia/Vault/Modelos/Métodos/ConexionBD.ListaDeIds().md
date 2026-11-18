---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD/ConexionBD.cs"
graphify_ids:
  - "models_bd_conexionbd_swappit_models_conexionbd_listadeids"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# ConexionBD.ListaDeIds()

Método de `ConexionBD` ([[BD]]) · `Models/BD/ConexionBD.cs` línea 8. Parámetros: `IReadOnlyCollection<int>?`.

Convierte una lista de ids en texto separado por coma para los SP (que la leen con `STRING_SPLIT`). Devuelve null si la lista está vacía.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- usa el tipo [[IReadOnlyCollection]] · `references` EXTRACTED

**Desde otras notas:**
- [[ArticulosBD.GetArticulosCatalogo()]] la llama · `calls` EXTRACTED
- [[FavoritosBD.ImportarFavoritos()]] la llama · `calls` EXTRACTED
- [[IntercambiosBD.AgregarArticulos()]] la llama · `calls` EXTRACTED
- [[IntercambiosBD.ProponerIntercambio()]] la llama · `calls` EXTRACTED
- [[RecomendacionesBD.GetSenalesGustos()]] la llama · `calls` EXTRACTED
- [[RecomendacionesBD.RegistrarBusqueda()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
