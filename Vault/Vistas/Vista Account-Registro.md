---
tipo: vista
comunidad: "Controllers, vistas y JS"
archivos:
  - "Views/Account/Registro.cshtml"
graphify_ids:
  - "views_account_registro"
tags:
  - tipo/vista
  - comunidad/Controllers_vistas_y_JS
---
# Vista: Account / Registro

`Views/Account/Registro.cshtml` · Form POST a [[AccountController]].Registro: Nombre, Apellido, Email, Contraseña, Repetir contraseña (`password2`), Fecha de nacimiento, Teléfono ([[RegistroViewModel]]). Si vuelve con errores, recarga lo escrito desde `ViewBag.registro` (menos las contraseñas). Ver [[Flujo Registro]].

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- incluye el partial [[Vista _ValidationScriptsPartial]] · `includes` EXTRACTED
- tiene un link a [[AccountController.Index()]] · `links_to` EXTRACTED
- envía el formulario a [[AccountController.Registro() POST]] · `posts_to` EXTRACTED

**Desde otras notas:**
- [[AccountController.Registro() GET]] muestra esta vista · `renders` INFERRED
- [[AccountController.Registro() POST]] muestra esta vista · `renders` INFERRED
