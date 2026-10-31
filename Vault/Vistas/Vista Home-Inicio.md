---
tipo: vista
comunidad: "Controllers, vistas y JS"
archivos:
  - "Views/Home/Inicio.cshtml"
graphify_ids:
  - "views_home_inicio"
tags:
  - tipo/vista
  - comunidad/Controllers_vistas_y_JS
---
# Vista: Home / Inicio

`Views/Home/Inicio.cshtml` · Inicio del usuario logueado (`HomeController.Index` con sesión; sin sesión se ve [[Vista Home-Index]]). Rediseño del 30/10 (sin commit):
- Saludo grande y centrado "¡Hola, {nombre}!" con "Publicar un artículo" y "Explorar artículos" abajo.
- Columna principal: aviso "Publicá tu primer artículo" si no tiene artículos y "Artículos recomendados" (9 cards [[Vista _CardObjeto]]; por ahora, los últimos disponibles de los demás).
- Columna lateral (arriba en celular, fija al bajar en pantallas grandes): "Tu resumen" (propuestas por responder, mensajes sin leer, artículos publicados) e "Intercambios en curso" (hasta 4 filas compactas con "Responder" en bordó o el estado).

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- incluye el partial [[Vista _CardObjeto]] · `includes` EXTRACTED
- tiene un link a [[ArticulosController.Buscar()]] · `links_to` EXTRACTED
- tiene un link a [[ChatController.Index()]] · `links_to` EXTRACTED
- tiene un link a [[IntercambioController.Detalle()]] · `links_to` EXTRACTED
- tiene un link a [[IntercambioController.Index()]] · `links_to` EXTRACTED
- tiene un link a [[PerfilController.Index()]] · `links_to` EXTRACTED
- tiene un link a [[PublicarController.Index() GET]] · `links_to` EXTRACTED

**Desde otras notas:**
- [[HomeController.Inicio()]] muestra esta vista · `renders` EXTRACTED
