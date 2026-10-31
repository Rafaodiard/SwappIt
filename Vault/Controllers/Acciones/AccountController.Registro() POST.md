---
tipo: metodo
comunidad: "Controllers, vistas y JS"
archivos:
  - "Controllers/AccountController.cs"
graphify_ids:
  - "controllers_accountcontroller_swappit_controllers_accountcontroller_registro_e89142"
tags:
  - tipo/metodo
  - comunidad/Controllers_vistas_y_JS
---
# AccountController.Registro() POST

Método de [[AccountController]] · `Controllers/AccountController.cs` línea 58. Parámetros: `RegistroViewModel,string`.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- llama a [[AccountController.CalcularEdad()]] · `calls` EXTRACTED
- llama a [[BD.GetUsuarioByMail()]] · `calls` EXTRACTED
- llama a [[BD.Register()]] · `calls` EXTRACTED
- llama a [[BD.UsuarioExiste()]] · `calls` EXTRACTED
- llama a [[Contrasenas.Hashear()]] · `calls` EXTRACTED
- llama a [[SesionUsuario.GuardarDatosHeader()]] · `calls` EXTRACTED
- llama a [[Telefonos.Convertir()]] · `calls` EXTRACTED
- llama a [[Usuarios]] · `calls` INFERRED
- redirige a [[HomeController.Index()]] · `redirects_to` EXTRACTED
- usa el tipo [[HttpPost]] · `references` EXTRACTED
- usa el tipo [[IActionResult]] · `references` EXTRACTED
- usa el tipo [[RegistroViewModel]] · `references` EXTRACTED
- muestra la vista [[Vista Account-Registro]] · `renders` INFERRED

**Desde otras notas:**
- [[AccountController]] la tiene como método · `method` EXTRACTED
- [[Vista Account-Registro]] envía su formulario acá · `posts_to` EXTRACTED
