---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD/UsuariosBD.cs"
graphify_ids:
  - "models_bd_usuariosbd_swappit_models_usuariosbd_register"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# UsuariosBD.Register()

Método de `UsuariosBD` ([[BD]]) · `Models/BD/UsuariosBD.cs` línea 68. Parámetros: `Usuarios`.

Llama al SP [[SP RegistrarUsuario]] con `CommandType.StoredProcedure`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- llama al SP [[SP RegistrarUsuario]] · `calls_sp` EXTRACTED
- usa el tipo [[Usuarios]] · `references` EXTRACTED

**Desde otras notas:**
- [[AccountController.Registro() POST]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
