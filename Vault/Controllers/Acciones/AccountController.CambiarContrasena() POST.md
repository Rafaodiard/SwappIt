---
tipo: metodo
comunidad: "Controllers, vistas y JS"
archivos:
  - "Controllers/AccountController.cs"
graphify_ids:
  - "controllers_accountcontroller_swappit_controllers_accountcontroller_cambiarcontrasena_ff5087"
tags:
  - tipo/metodo
  - comunidad/Controllers_vistas_y_JS
---
# AccountController.CambiarContrasena() POST

Método de [[AccountController]] · `Controllers/AccountController.cs` línea 103. Parámetros: `string?,string?,string?`.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- llama a [[Contrasenas.Hashear()]] · `calls` EXTRACTED
- llama a [[Contrasenas.Verificar()]] · `calls` EXTRACTED
- llama a [[UsuariosBD.ActualizarContrasena()]] · `calls` EXTRACTED
- llama a [[UsuariosBD.GetUsuarioById()]] · `calls` EXTRACTED
- redirige a [[AccountController.Index()]] · `redirects_to` EXTRACTED
- usa el tipo [[HttpPost]] · `references` EXTRACTED
- usa el tipo [[IActionResult]] · `references` EXTRACTED
- muestra la vista [[Vista Account-CambiarContrasena]] · `renders` INFERRED

**Desde otras notas:**
- [[AccountController]] la tiene como método · `method` EXTRACTED
