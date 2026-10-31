---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD.cs"
graphify_ids:
  - "models_bd_swappit_models_bd_actualizarcontrasena"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# BD.ActualizarContrasena()

Método de [[BD]] · `Models/BD.cs` línea 25. Parámetros: `int,string`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- tiene un SP con el mismo nombre [[SP ActualizarContrasena]] · `same_name_as_sp` INFERRED
- escribe en [[Tabla Usuarios]] · `writes_to` EXTRACTED

**Desde otras notas:**
- [[AccountController.CambiarContrasena() POST]] la llama · `calls` EXTRACTED
- [[AccountController.Login()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
