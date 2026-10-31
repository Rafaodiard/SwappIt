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
- llama a [[BD.ActualizarContrasena()]] · `calls` EXTRACTED
- llama a [[BD.GetUsuarioByMail()]] · `calls` EXTRACTED
- llama a [[Contrasenas.Hashear()]] · `calls` EXTRACTED
- llama a [[Contrasenas.Verificar()]] · `calls` EXTRACTED
- llama a [[SesionUsuario.GuardarDatosHeader()]] · `calls` EXTRACTED
- redirige a [[HomeController.Index()]] · `redirects_to` EXTRACTED
- usa el tipo [[HttpPost]] · `references` EXTRACTED
- usa el tipo [[IActionResult]] · `references` EXTRACTED
- usa el tipo [[LoginViewModel]] · `references` EXTRACTED
- muestra la vista [[Vista Account-Login]] · `renders` EXTRACTED

**Desde otras notas:**
- [[AccountController]] la tiene como método · `method` EXTRACTED
- [[Vista Account-Login]] envía su formulario acá · `posts_to` EXTRACTED
