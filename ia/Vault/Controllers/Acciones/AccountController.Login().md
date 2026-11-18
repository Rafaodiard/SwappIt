---
tipo: metodo
comunidad: "Controllers, vistas y JS"
archivos:
  - "Controllers/AccountController.cs"
graphify_ids:
  - "controllers_accountcontroller_swappit_controllers_accountcontroller_login"
tags:
  - tipo/metodo
  - comunidad/Controllers_vistas_y_JS
---
# AccountController.Login()

Método de [[AccountController]] · `Controllers/AccountController.cs` línea 33. Parámetros: `LoginViewModel`.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- llama a [[Contrasenas.Hashear()]] · `calls` EXTRACTED
- llama a [[Contrasenas.Verificar()]] · `calls` EXTRACTED
- llama a [[SesionUsuario.GuardarDatosHeader()]] · `calls` EXTRACTED
- llama a [[UsuariosBD.ActualizarContrasena()]] · `calls` EXTRACTED
- llama a [[UsuariosBD.GetUsuarioByMail()]] · `calls` EXTRACTED
- redirige a [[HomeController.Index()]] · `redirects_to` EXTRACTED
- usa el tipo [[HttpPost]] · `references` EXTRACTED
- usa el tipo [[IActionResult]] · `references` EXTRACTED
- usa el tipo [[LoginViewModel]] · `references` EXTRACTED

**Desde otras notas:**
- [[Vista Account-Login]] tiene un link acá · `links_to` EXTRACTED
- [[AccountController]] la tiene como método · `method` EXTRACTED
