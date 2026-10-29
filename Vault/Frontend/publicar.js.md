---
tipo: js
comunidad: "JS de publicar"
archivos:
  - "wwwroot/js/publicar.js"
graphify_ids:
  - "wwwroot_js_publicar"
tags:
  - tipo/js
  - comunidad/JS_de_publicar
---
# publicar.js

`wwwroot/js/publicar.js` · [[Vista Publicar-Index]]. Zona de carga con clic, teclado (Enter/Espacio) y arrastrar y soltar; descarta fotos que no son JPG/PNG o pasan el tamaño, respeta el máximo (lee `data-max-fotos` / `data-max-mb` que vienen de [[PublicarArticuloViewModel]]). Mantiene el `<input type="file">` sincronizado con `DataTransfer`, dibuja miniaturas con botón para quitar y 4 espacios "+" mínimos, y cuenta los caracteres de la descripción. Funciones: `agregar`, `quitar`, `mostrarAviso`, `actualizar`, `dibujarMiniaturas`. La validación que vale es la del servidor ([[PublicarController]]).

Comunidad del grafo: [[Comunidad - JS de publicar]]

## Conexiones en el grafo (graphify)
- contiene [[publicar.js actualizar()]] · `contains` EXTRACTED
- contiene [[publicar.js agregar()]] · `contains` EXTRACTED
- contiene [[publicar.js dibujarMiniaturas()]] · `contains` EXTRACTED
- contiene [[publicar.js mostrarAviso()]] · `contains` EXTRACTED
- contiene [[publicar.js quitar()]] · `contains` EXTRACTED

**Desde otras notas:**
- [[Vista Publicar-Index]] carga este script · `loads_script` EXTRACTED
