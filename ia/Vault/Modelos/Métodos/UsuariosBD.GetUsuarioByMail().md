---
tipo: metodo
comunidad: "Usuarios, contraseñas y sesión"
archivos:
  - "Models/BD/UsuariosBD.cs"
graphify_ids:
  - "models_bd_usuariosbd_swappit_models_usuariosbd_getusuariobymail"
tags:
  - tipo/metodo
  - comunidad/Usuarios_contraseñas_y_sesión
---
# UsuariosBD.GetUsuarioByMail()

Método de `UsuariosBD` ([[BD]]) · `Models/BD/UsuariosBD.cs` línea 10. Parámetros: `string`.

Llama al SP [[SP GetUsuarioByMail]] con `CommandType.StoredProcedure`.

Comunidad del grafo: [[Comunidad - Usuarios, contraseñas y sesión]]

## Conexiones en el grafo (graphify)
- llama al SP [[SP GetUsuarioByMail]] · `calls_sp` EXTRACTED
- usa el tipo [[Usuarios]] · `references` EXTRACTED

**Desde otras notas:**
- [[AccountController.Login()]] la llama · `calls` EXTRACTED
- [[AccountController.Registro() POST]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
