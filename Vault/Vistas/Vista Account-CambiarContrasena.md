---
tipo: vista
comunidad: "Controllers, vistas y JS"
archivos:
  - "Views/Account/CambiarContrasena.cshtml"
graphify_ids:
  - "views_account_cambiarcontrasena"
tags:
  - tipo/vista
  - comunidad/Controllers_vistas_y_JS
---
# Vista: Account / CambiarContrasena

`Views/Account/CambiarContrasena.cshtml` · Contraseña actual, nueva y repetición; POST a [[AccountController]].CambiarContrasena. Muestra `ViewBag.Error` o `ViewBag.Message`. Link "Volver a mi perfil". Ninguna otra vista linkea acá ([[Flujo Cambiar contraseña]]).

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- tiene un link a [[PerfilController.Index()]] · `links_to` EXTRACTED
- envía el formulario a [[AccountController.CambiarContrasena() POST]] · `posts_to` EXTRACTED

**Desde otras notas:**
- [[AccountController.CambiarContrasena() GET]] muestra esta vista · `renders` INFERRED
- [[AccountController.CambiarContrasena() POST]] muestra esta vista · `renders` INFERRED
