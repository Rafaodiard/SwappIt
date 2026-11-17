---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD/UsuariosBD.cs"
graphify_ids:
  - "models_bd_usuariosbd_swappit_models_usuariosbd_actualizarcontrasena"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# UsuariosBD.ActualizarContrasena()

Método de `UsuariosBD` ([[BD]]) · `Models/BD/UsuariosBD.cs` línea 20. Parámetros: `int,string`.

Llama al SP [[SP ActualizarContrasena]] con `CommandType.StoredProcedure`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- llama al SP [[SP ActualizarContrasena]] · `calls_sp` EXTRACTED

**Desde otras notas:**
- [[AccountController.CambiarContrasena() POST]] la llama · `calls` EXTRACTED
- [[AccountController.Login()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
