---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD/FavoritosBD.cs"
graphify_ids:
  - "models_bd_favoritosbd_swappit_models_favoritosbd_getfavoritos"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# FavoritosBD.GetFavoritos()

Método de `FavoritosBD` ([[BD]]) · `Models/BD/FavoritosBD.cs` línea 20. Parámetros: `int`.

Llama al SP [[SP GetFavoritos]] con `CommandType.StoredProcedure`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- llama al SP [[SP GetFavoritos]] · `calls_sp` EXTRACTED
- usa el tipo [[ArticuloCardViewModel]] · `references` EXTRACTED
- usa el tipo [[List]] · `references` EXTRACTED

**Desde otras notas:**
- [[BD]] la tiene como método · `method` EXTRACTED
