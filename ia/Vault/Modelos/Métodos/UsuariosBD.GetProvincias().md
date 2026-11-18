---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD/UsuariosBD.cs"
graphify_ids:
  - "models_bd_usuariosbd_swappit_models_usuariosbd_getprovincias"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# UsuariosBD.GetProvincias()

Método de `UsuariosBD` ([[BD]]) · `Models/BD/UsuariosBD.cs` línea 60.

Llama al SP [[SP GetProvincias]] con `CommandType.StoredProcedure`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- llama al SP [[SP GetProvincias]] · `calls_sp` EXTRACTED
- usa el tipo [[List]] · `references` EXTRACTED
- usa el tipo [[Provincias]] · `references` EXTRACTED

**Desde otras notas:**
- [[AccountController.Registro() GET]] la llama · `calls` EXTRACTED
- [[AccountController.Registro() POST]] la llama · `calls` EXTRACTED
- [[PerfilController.Index()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
