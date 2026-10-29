---
tipo: js
comunidad: "Controllers, vistas y JS"
archivos:
  - "wwwroot/js/plantillas.js"
graphify_ids:
  - "wwwroot_js_plantillas"
  - "wwwroot_js_plantillas_swappit"
tags:
  - tipo/js
  - comunidad/Controllers_vistas_y_JS
---
# plantillas.js

`wwwroot/js/plantillas.js` · Se carga en todas las páginas. Define el objeto global `swappit` con:
- `renderLista(selector, items, nombre, extra)`: toma el elemento marcado `data-template="nombre"` como molde, lo clona por cada dato y rellena los `[data-campo]` (como `src` si es `<img>`, si no como texto).
- `renderObjetos(selector, articulos)`: caso de las cards ([[Vista _CardObjeto]]), arma el link `/Articulos/Detalle/{id}` y muestra/oculta "sin resultados".

Hoy **no se usa**: todas las listas se arman en el servidor. Queda para cuando el chat, el historial o el catálogo se carguen con `fetch` ([[Vista Chat-Index]], [[Vista Perfil-Index]]).

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)

**Desde otras notas:**
- [[Vista _Layout]] carga este script · `loads_script` EXTRACTED
