---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD/ArticulosBD.cs"
graphify_ids:
  - "models_bd_articulosbd_swappit_models_articulosbd_getarticuloscatalogo"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# ArticulosBD.GetArticulosCatalogo()

Método de `ArticulosBD` ([[BD]]) · `Models/BD/ArticulosBD.cs` línea 12. Parámetros: `string?,int?,IReadOnlyCollection<int>?,IReadOnlyCollection<int>?,int?,int?,int?,int?,bool,string?`.

Llama al SP [[SP GetArticulosCatalogo]] con `CommandType.StoredProcedure`.

Por defecto trae solo los artículos disponibles (sin intercambio aceptado ni realizado). Con `incluirEnIntercambio: true` (11/11, solo lo usa [[PerfilController]].Index) trae todos los que no se intercambiaron, igual que el límite de 5 de BD.ContarArticulosActivos, y marca `EnIntercambio` en los que están en un intercambio aceptado.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- llama a [[ArticulosBD.TextoBusqueda()]] · `calls` EXTRACTED
- llama a [[ConexionBD.ListaDeIds()]] · `calls` EXTRACTED
- llama al SP [[SP GetArticulosCatalogo]] · `calls_sp` EXTRACTED
- usa el tipo [[ArticuloCardViewModel]] · `references` EXTRACTED
- usa el tipo [[IReadOnlyCollection]] · `references` EXTRACTED
- usa el tipo [[List]] · `references` EXTRACTED

**Desde otras notas:**
- [[ArticulosController.Buscar()]] la llama · `calls` EXTRACTED
- [[ArticulosController.Detalle()]] la llama · `calls` EXTRACTED
- [[IntercambioController.Detalle()]] la llama · `calls` EXTRACTED
- [[PerfilController.Index()]] la llama · `calls` EXTRACTED
- [[PerfilController.Publico()]] la llama · `calls` EXTRACTED
- [[RecomendacionesController]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
