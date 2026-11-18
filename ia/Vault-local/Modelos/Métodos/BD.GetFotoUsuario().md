---
tipo: metodo
comunidad: "Controllers, vistas y JS"
archivos:
  - "Models/BD.cs"
graphify_ids:
  - "models_bd_swappit_models_bd_getfotousuario"
tags:
  - tipo/metodo
  - comunidad/Controllers_vistas_y_JS
---
# BD.GetFotoUsuario()

Método de [[BD]] · `Models/BD.cs` línea 91. Parámetros: `int`.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Imagenes]] · `reads_from` EXTRACTED
- tiene un SP con el mismo nombre [[SP GetFotoUsuario]] · `same_name_as_sp` INFERRED

**Desde otras notas:**
- [[ArticulosController.Detalle()]] la llama · `calls` EXTRACTED
- [[PerfilController.Editar()]] la llama · `calls` EXTRACTED
- [[PerfilController.Index()]] la llama · `calls` EXTRACTED
- [[PerfilController.Publico()]] la llama · `calls` EXTRACTED
- [[SesionUsuario.GuardarDatosHeader()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
