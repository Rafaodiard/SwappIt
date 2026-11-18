---
tipo: js
comunidad: "Publicar artículo"
archivos:
  - "wwwroot/js/publicar.js"
graphify_ids:
  - "wwwroot_js_publicar"
tags:
  - tipo/js
  - comunidad/Publicar_artículo
---
# publicar.js

`wwwroot/js/publicar.js` · [[Vista Publicar-Index]]. Zona de carga con clic, teclado (Enter/Espacio) y arrastrar y soltar; descarta fotos que no son JPG/PNG o pasan el tamaño, respeta el máximo (lee `data-max-fotos` / `data-max-mb` que vienen de [[PublicarArticuloViewModel]]). Mantiene el `<input type="file">` sincronizado con `DataTransfer`, dibuja miniaturas con botón para quitar y 4 espacios "+" mínimos, y cuenta los caracteres de la descripción. Desde el 08/11, al mandar el form revisa los campos con `data-requerido` (título, categoría, ubicación, estado, descripción): escribe el mensaje en el `<span data-valmsg-for>` de cada uno, marca el campo y no deja mandar, así no se recarga la página y no se pierden las fotos. Funciones: `agregar`, `quitar`, `mostrarAviso`, `actualizar`, `dibujarMiniaturas`, `marcar`, `completo`. La validación que vale sigue siendo la del servidor ([[PublicarController]]).

Comunidad del grafo: [[Comunidad - Publicar artículo]]

## Conexiones en el grafo (graphify)
- contiene [[publicar.js actualizar()]] · `contains` EXTRACTED
- contiene [[publicar.js agregar()]] · `contains` EXTRACTED
- contiene [[publicar.js dibujarMiniaturas()]] · `contains` EXTRACTED
- contiene [[publicar.js mostrarAviso()]] · `contains` EXTRACTED
- contiene [[publicar.js quitar()]] · `contains` EXTRACTED

**Desde otras notas:**
- [[Vista Publicar-Index]] carga este script · `loads_script` EXTRACTED
