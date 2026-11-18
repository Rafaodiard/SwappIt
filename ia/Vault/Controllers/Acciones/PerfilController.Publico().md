---
tipo: metodo
comunidad: "Controllers, vistas y JS"
archivos:
  - "Controllers/PerfilController.cs"
graphify_ids:
  - "controllers_perfilcontroller_swappit_controllers_perfilcontroller_publico"
tags:
  - tipo/metodo
  - comunidad/Controllers_vistas_y_JS
---
# PerfilController.Publico()

Método de [[PerfilController]] · `Controllers/PerfilController.cs` línea 42. Parámetros: `int`.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- llama a [[ArticulosBD.GetArticulosCatalogo()]] · `calls` EXTRACTED
- llama a [[Usuarios]] · `calls` INFERRED
- llama a [[UsuariosBD.GetFotoUsuario()]] · `calls` EXTRACTED
- llama a [[UsuariosBD.GetProvinciaById()]] · `calls` EXTRACTED
- llama a [[UsuariosBD.GetUsuarioById()]] · `calls` EXTRACTED
- redirige a [[AccountController.Index()]] · `redirects_to` EXTRACTED
- redirige a [[PerfilController.Index()]] · `redirects_to` EXTRACTED
- usa el tipo [[IActionResult]] · `references` EXTRACTED
- muestra la vista [[Vista Perfil-Publico]] · `renders` INFERRED

**Desde otras notas:**
- [[Vista Articulos-Detalle]] tiene un link acá · `links_to` EXTRACTED
- [[Vista Chat-Index]] tiene un link acá · `links_to` EXTRACTED
- [[Vista Intercambio-Detalle]] tiene un link acá · `links_to` EXTRACTED
- [[PerfilController]] la tiene como método · `method` EXTRACTED
