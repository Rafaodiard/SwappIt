---
tipo: metodo
comunidad: "Usuarios, contraseñas y sesión"
archivos:
  - "Models/SesionUsuario.cs"
graphify_ids:
  - "models_sesionusuario_swappit_models_sesionusuario_iniciales"
tags:
  - tipo/metodo
  - comunidad/Usuarios_contraseñas_y_sesión
---
# SesionUsuario.Iniciales()

Método de [[SesionUsuario]] · `Models/SesionUsuario.cs`. Parámetros: `string?,string?`.

Devuelve las iniciales de nombre y apellido para el avatar. Es pública desde el 17/11 (reemplaza a la privada `ObtenerIniciales`) y la usan también las vistas de perfil, detalle y chat, que antes las calculaban con LINQ.

Comunidad del grafo: [[Comunidad - Usuarios, contraseñas y sesión]]

## Conexiones en el grafo (graphify)

**Desde otras notas:**
- [[SesionUsuario.GuardarDatosHeader()]] la llama · `calls` EXTRACTED
- [[SesionUsuario]] la tiene como método · `method` EXTRACTED
