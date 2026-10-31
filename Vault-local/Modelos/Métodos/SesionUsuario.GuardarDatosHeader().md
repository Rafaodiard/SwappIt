---
tipo: metodo
comunidad: "Usuarios, contraseñas y sesión"
archivos:
  - "Models/SesionUsuario.cs"
graphify_ids:
  - "models_sesionusuario_swappit_models_sesionusuario_guardardatosheader"
tags:
  - tipo/metodo
  - comunidad/Usuarios_contraseñas_y_sesión
---
# SesionUsuario.GuardarDatosHeader()

Método de [[SesionUsuario]] · `Models/SesionUsuario.cs` línea 8. Parámetros: `ISession,Usuarios`.

Comunidad del grafo: [[Comunidad - Usuarios, contraseñas y sesión]]

## Conexiones en el grafo (graphify)
- llama a [[BD.GetFotoUsuario()]] · `calls` EXTRACTED
- llama a [[SesionUsuario.ObtenerIniciales()]] · `calls` EXTRACTED
- usa el tipo [[ISession]] · `references` EXTRACTED
- usa el tipo [[Usuarios]] · `references` EXTRACTED

**Desde otras notas:**
- [[AccountController.Login()]] la llama · `calls` EXTRACTED
- [[AccountController.Registro() POST]] la llama · `calls` EXTRACTED
- [[PerfilController.Editar()]] la llama · `calls` EXTRACTED
- [[SesionUsuario]] la tiene como método · `method` EXTRACTED
