---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD.cs"
graphify_ids:
  - "models_bd_swappit_models_bd_usuarioexiste"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# BD.UsuarioExiste()

Método de [[BD]] · `Models/BD.cs` línea 34. Parámetros: `string`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Usuarios]] · `reads_from` EXTRACTED
- tiene un SP con el mismo nombre [[SP UsuarioExiste]] · `same_name_as_sp` INFERRED

**Desde otras notas:**
- [[AccountController.Registro() POST]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
