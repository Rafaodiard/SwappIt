---
tipo: modelo
comunidad: "Usuarios, contraseñas y sesión"
archivos:
  - "Models/Usuarios.cs"
graphify_ids:
  - "models_usuarios_swappit_models_usuarios"
  - "models_usuarios"
  - "models_usuarios_swappit_models_usuarios_apellido"
  - "models_usuarios_swappit_models_usuarios_barrio"
  - "models_usuarios_swappit_models_usuarios_contraseña"
  - "models_usuarios_swappit_models_usuarios_descripcion"
  - "models_usuarios_swappit_models_usuarios_edad"
  - "models_usuarios_swappit_models_usuarios_fechanacimiento"
  - "models_usuarios_swappit_models_usuarios_idprovincias"
  - "models_usuarios_swappit_models_usuarios_idusuarios"
  - "models_usuarios_swappit_models_usuarios_mail"
  - "models_usuarios_swappit_models_usuarios_nombre"
  - "models_usuarios_swappit_models_usuarios_telefono"
  - "models_usuarios_swappit_models_usuarios_usuario"
tags:
  - tipo/modelo
  - comunidad/Usuarios_contraseñas_y_sesión
---
# Usuarios (modelo)

`Models/Usuarios.cs` · Una fila de [[Tabla Usuarios]]. `FechaNacimiento` viene de la columna `[Fecha nacimiento]` (alias en [[BD]]). `Telefono` es `int` (ver [[Telefonos]]). `Contraseña` guarda el hash ([[Contrasenas]]). `Descripcion` es opcional (hasta 500).

Comunidad del grafo: [[Comunidad - Usuarios, contraseñas y sesión]]

## Propiedades
`Apellido` · `Barrio` · `Contraseña` · `Descripcion` · `Edad` · `FechaNacimiento` · `IdProvincias` · `IdUsuarios` · `Mail` · `Nombre` · `Telefono` · `Usuario`

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Models]] · `contains` EXTRACTED
- corresponde a la tabla [[Tabla Usuarios]] · `maps_to` INFERRED
- usa el tipo [[DateTime]] · `references` EXTRACTED

**Desde otras notas:**
- [[AccountController.Registro() POST]] la llama · `calls` INFERRED
- [[PerfilController.Publico()]] la llama · `calls` INFERRED
- [[BD.GetUsuarioById()]] la usa como tipo · `references` EXTRACTED
- [[BD.GetUsuarioByMail()]] la usa como tipo · `references` EXTRACTED
- [[BD.Register()]] la usa como tipo · `references` EXTRACTED
- [[BD.UpdateUsuario()]] la usa como tipo · `references` EXTRACTED
- [[Contrasenas]] la usa como tipo · `references` EXTRACTED
- [[SesionUsuario.GuardarDatosHeader()]] la usa como tipo · `references` EXTRACTED
- [[SesionUsuario.ObtenerIniciales()]] la usa como tipo · `references` EXTRACTED
