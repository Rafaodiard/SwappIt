---
tipo: modelo
comunidad: "Usuarios, contraseñas y sesión"
archivos:
  - "Models/SesionUsuario.cs"
graphify_ids:
  - "models_sesionusuario_swappit_models_sesionusuario"
  - "models_sesionusuario"
tags:
  - tipo/modelo
  - comunidad/Usuarios_contraseñas_y_sesión
---
# SesionUsuario

`Models/SesionUsuario.cs` · `GuardarDatosHeader(session, usuario)` guarda en la sesión las **iniciales** y la **foto** ([[BD]].GetFotoUsuario) para el avatar de [[Vista _Layout]]. Lo llaman [[AccountController]] (login y registro) y [[PerfilController]] (al editar).

Comunidad del grafo: [[Comunidad - Usuarios, contraseñas y sesión]]

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Models]] · `contains` EXTRACTED
- tiene el método [[SesionUsuario.GuardarDatosHeader()]] · `method` EXTRACTED
- tiene el método [[SesionUsuario.ObtenerIniciales()]] · `method` EXTRACTED
