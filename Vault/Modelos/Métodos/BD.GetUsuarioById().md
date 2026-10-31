---
tipo: metodo
comunidad: "Controllers, vistas y JS"
archivos:
  - "Models/BD.cs"
graphify_ids:
  - "models_bd_swappit_models_bd_getusuariobyid"
tags:
  - tipo/metodo
  - comunidad/Controllers_vistas_y_JS
---
# BD.GetUsuarioById()

Método de [[BD]] · `Models/BD.cs` línea 43. Parámetros: `int`.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Usuarios]] · `reads_from` EXTRACTED
- usa el tipo [[Usuarios]] · `references` EXTRACTED
- tiene un SP con el mismo nombre [[SP GetUsuarioById]] · `same_name_as_sp` INFERRED

**Desde otras notas:**
- [[AccountController.CambiarContrasena() POST]] la llama · `calls` EXTRACTED
- [[ArticulosController.Detalle()]] la llama · `calls` EXTRACTED
- [[HomeController.Inicio()]] la llama · `calls` EXTRACTED
- [[PerfilController.Editar()]] la llama · `calls` EXTRACTED
- [[PerfilController.Index()]] la llama · `calls` EXTRACTED
- [[PerfilController.Publico()]] la llama · `calls` EXTRACTED
- [[PublicarController.Index() GET]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
