---
tipo: vista
comunidad: "Controllers, vistas y JS"
archivos:
  - "Views/Account/Login.cshtml"
graphify_ids:
  - "views_account_login"
tags:
  - tipo/vista
  - comunidad/Controllers_vistas_y_JS
---
# Vista: Account / Login

`Views/Account/Login.cshtml` · Form POST a [[AccountController]].Login con Mail y Contrasena ([[LoginViewModel]]). Errores de validación por campo (`ClaseError`), mensaje general `ViewBag.Error`. Link "¿Olvidaste tu contraseña?" a `#` y link a Registro. Carga jQuery + [[Vista _ValidationScriptsPartial]]. No hay frame de login en Figma: está derivada del de Registro.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- incluye el partial [[Vista _ValidationScriptsPartial]] · `includes` EXTRACTED
- tiene un link a [[AccountController.Registro() GET]] · `links_to` EXTRACTED
- envía el formulario a [[AccountController.Login()]] · `posts_to` EXTRACTED

**Desde otras notas:**
- [[AccountController.Index()]] muestra esta vista · `renders` EXTRACTED
- [[AccountController.Login()]] muestra esta vista · `renders` EXTRACTED
