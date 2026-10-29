---
tipo: metodo
comunidad: "Usuarios, contraseñas y sesión"
archivos:
  - "Models/BD.cs"
graphify_ids:
  - "models_bd_swappit_models_bd_getusuariobymail"
tags:
  - tipo/metodo
  - comunidad/Usuarios_contraseñas_y_sesión
---
# BD.GetUsuarioByMail()

Método de [[BD]] · `Models/BD.cs` línea 16. Parámetros: `string`.

Comunidad del grafo: [[Comunidad - Usuarios, contraseñas y sesión]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Usuarios]] · `reads_from` EXTRACTED
- usa el tipo [[Usuarios]] · `references` EXTRACTED
- tiene un SP con el mismo nombre [[SP GetUsuarioByMail]] · `same_name_as_sp` INFERRED

**Desde otras notas:**
- [[AccountController.Login()]] la llama · `calls` EXTRACTED
- [[AccountController.Registro() POST]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
