---
tipo: metodo
comunidad: "Controllers, vistas y JS"
archivos:
  - "Models/BD/UsuariosBD.cs"
graphify_ids:
  - "models_bd_usuariosbd_swappit_models_usuariosbd_getprovinciabyid"
tags:
  - tipo/metodo
  - comunidad/Controllers_vistas_y_JS
---
# UsuariosBD.GetProvinciaById()

Método de `UsuariosBD` ([[BD]]) · `Models/BD/UsuariosBD.cs` línea 50. Parámetros: `int`.

Llama al SP [[SP GetProvinciaById]] con `CommandType.StoredProcedure`.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- llama al SP [[SP GetProvinciaById]] · `calls_sp` EXTRACTED
- usa el tipo [[Provincias]] · `references` EXTRACTED

**Desde otras notas:**
- [[ArticulosController.Detalle()]] la llama · `calls` EXTRACTED
- [[PerfilController.Index()]] la llama · `calls` EXTRACTED
- [[PerfilController.Publico()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
