---
tipo: vista
comunidad: "Controllers, vistas y JS"
archivos:
  - "Views/Shared/_Layout.cshtml"
graphify_ids:
  - "views_shared_layout"
tags:
  - tipo/vista
  - comunidad/Controllers_vistas_y_JS
---
# Vista: _Layout

`Views/Shared/_Layout.cshtml` · Plantilla de todas las páginas (la asigna [[Vista _ViewStart]]).

- **Header:** logo, buscador (GET a `/Articulos/Buscar?q=`), botón de ubicación con texto fijo "Palermo, CABA".
  - Visitante (sin `UsuarioId` en sesión): "Iniciar sesión" y "Registrarse".
  - Logueado: favoritos (`#`), mensajes ([[ChatController]]), campana con [[Vista _PopupNotificaciones]], avatar con foto o iniciales (de la sesión, ver [[SesionUsuario]]) → [[PerfilController]], "Publicar" ([[PublicarController]]), cerrar sesión.
  - En celulares el buscador pasa a una segunda fila y "Publicar" queda como ícono "+".
- **Footer:** eslogan, links (Cómo funciona → `#como-funciona` de [[Vista Home-Index]], Términos y privacidad → [[Vista Home-Privacy]]); el resto apunta a `#`.
- **Recursos:** Google Fonts (Forum y Questrial), Bootstrap local, Bootstrap Icons 1.11.3 por CDN, [[site.css]]; scripts comunes [[plantillas.js]], [[imagenes.js]], [[favoritos.js]], [[notificaciones.js]] y la sección `Scripts` de cada página.
- Accesibilidad: link "Saltar al contenido", `aria-label` en los íconos, `main` con `tabindex="-1"`.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- incluye el partial [[Vista _PopupNotificaciones]] · `includes` EXTRACTED
- tiene un link a [[AccountController.Index()]] · `links_to` EXTRACTED
- tiene un link a [[AccountController.Logout()]] · `links_to` EXTRACTED
- tiene un link a [[AccountController.Registro() GET]] · `links_to` EXTRACTED
- tiene un link a [[ArticulosController.Buscar()]] · `links_to` EXTRACTED
- tiene un link a [[ChatController.Index()]] · `links_to` EXTRACTED
- tiene un link a [[HomeController.Index()]] · `links_to` EXTRACTED
- tiene un link a [[HomeController.Privacy()]] · `links_to` EXTRACTED
- tiene un link a [[PerfilController.Index()]] · `links_to` EXTRACTED
- tiene un link a [[PublicarController.Index() GET]] · `links_to` EXTRACTED
- carga el script [[favoritos.js]] · `loads_script` EXTRACTED
- carga el script [[imagenes.js]] · `loads_script` EXTRACTED
- carga el script [[notificaciones.js]] · `loads_script` EXTRACTED
- carga el script [[plantillas.js]] · `loads_script` EXTRACTED
