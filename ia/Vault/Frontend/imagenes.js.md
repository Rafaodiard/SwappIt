---
tipo: js
comunidad: "Controllers, vistas y JS"
archivos:
  - "wwwroot/js/imagenes.js"
graphify_ids:
  - "wwwroot_js_imagenes"
tags:
  - tipo/js
  - comunidad/Controllers_vistas_y_JS
---
# imagenes.js

`wwwroot/js/imagenes.js` · Todas las páginas. Si una imagen no carga: en fotos de objetos (`.sw-img`) quita el `src` y queda el fondo de placeholder; en avatares (`[data-iniciales]`) la reemplaza por las iniciales. Escucha el evento `error` en fase de captura (no burbujea) y revisa las que ya fallaron antes de cargar el script. Útil porque las fotos subidas no están en git y en otra compu no existen.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- contiene [[imagenes.js mostrarIniciales()]] · `contains` EXTRACTED

**Desde otras notas:**
- [[Vista _Layout]] carga este script · `loads_script` EXTRACTED
