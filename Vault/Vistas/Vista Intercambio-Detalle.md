---
tipo: vista
comunidad: "Controllers, vistas y JS"
archivos:
  - "Views/Intercambio/Detalle.cshtml"
graphify_ids:
  - "views_intercambio_detalle"
tags:
  - tipo/vista
  - comunidad/Controllers_vistas_y_JS
---
# Vista: Intercambio / Detalle

`Views/Intercambio/Detalle.cshtml` · [[IntercambioController]].Detalle. Solo lo ven las dos partes:
- Propuesta recibida y Pendiente: "Recibiste una propuesta" con Aceptar (con pop up que avisa cuántas propuestas se rechazan solas) / Rechazar.
- El resto: "Intercambio con @usuario", con el avance (Pendiente → Aceptado → Realizado, o Rechazado / Cancelado), lo que das y lo que recibís, y marcar como realizado cuando está aceptado.
- Cancelar con pop up de confirmación. Mientras está en curso, links al chat del intercambio.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- importa [[Namespace Swappit.Models]] · `imports` EXTRACTED
- tiene un link a [[ArticulosController.Buscar()]] · `links_to` EXTRACTED
- tiene un link a [[ArticulosController.Detalle()]] · `links_to` EXTRACTED
- tiene un link a [[ChatController.Index()]] · `links_to` EXTRACTED
- tiene un link a [[IntercambioController.Index()]] · `links_to` EXTRACTED
- tiene un link a [[PerfilController.Publico()]] · `links_to` EXTRACTED
- envía el formulario a [[IntercambioController.Aceptar()]] · `posts_to` EXTRACTED
- envía el formulario a [[IntercambioController.Cancelar()]] · `posts_to` EXTRACTED
- envía el formulario a [[IntercambioController.MarcarRealizado()]] · `posts_to` EXTRACTED
- envía el formulario a [[IntercambioController.Rechazar()]] · `posts_to` EXTRACTED

**Desde otras notas:**
- [[IntercambioController.Detalle()]] muestra esta vista · `renders` INFERRED
