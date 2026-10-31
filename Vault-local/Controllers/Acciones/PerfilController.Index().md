---
tipo: metodo
comunidad: "Controllers, vistas y JS"
archivos:
  - "Controllers/PerfilController.cs"
graphify_ids:
  - "controllers_perfilcontroller_swappit_controllers_perfilcontroller_index"
tags:
  - tipo/metodo
  - comunidad/Controllers_vistas_y_JS
---
# PerfilController.Index()

Método de [[PerfilController]] · `Controllers/PerfilController.cs` línea 18.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- llama a [[BD.GetArticulosCatalogo()]] · `calls` EXTRACTED
- llama a [[BD.GetFotoUsuario()]] · `calls` EXTRACTED
- llama a [[BD.GetProvinciaById()]] · `calls` EXTRACTED
- llama a [[BD.GetProvincias()]] · `calls` EXTRACTED
- llama a [[BD.GetUsuarioById()]] · `calls` EXTRACTED
- redirige a [[AccountController.Index()]] · `redirects_to` EXTRACTED
- usa el tipo [[IActionResult]] · `references` EXTRACTED
- muestra la vista [[Vista Perfil-Index]] · `renders` INFERRED

**Desde otras notas:**
- [[Vista Account-CambiarContrasena]] tiene un link acá · `links_to` EXTRACTED
- [[Vista Articulos-Detalle]] tiene un link acá · `links_to` EXTRACTED
- [[Vista _Layout]] tiene un link acá · `links_to` EXTRACTED
- [[PerfilController]] la tiene como método · `method` EXTRACTED
- [[PerfilController.Editar()]] redirige acá · `redirects_to` EXTRACTED
- [[PerfilController.Publico()]] redirige acá · `redirects_to` EXTRACTED
