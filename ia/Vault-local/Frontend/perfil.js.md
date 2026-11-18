---
tipo: js
comunidad: "JS de perfil"
archivos:
  - "wwwroot/js/perfil.js"
graphify_ids:
  - "wwwroot_js_perfil"
tags:
  - tipo/js
  - comunidad/JS_de_perfil
---
# perfil.js

`wwwroot/js/perfil.js` · Pop up "Editar perfil" de [[Vista Perfil-Index]]: vista previa de la foto elegida (`URL.createObjectURL`, valida JPG/PNG y tamaño), "Quitar foto" (pone `QuitarFoto=true`), contador de la descripción, botones con `data-enfocar` que llevan el foco a un campo, descarta cambios al cancelar y **reabre el pop up solo** si el servidor devolvió un error (`data-error`). Funciones: `mostrarImagen`, `mostrarIniciales`, `liberarUrl`.

Comunidad del grafo: [[Comunidad - JS de perfil]]

## Conexiones en el grafo (graphify)
- contiene [[perfil.js liberarUrl()]] · `contains` EXTRACTED
- contiene [[perfil.js mostrarImagen()]] · `contains` EXTRACTED
- contiene [[perfil.js mostrarIniciales()]] · `contains` EXTRACTED

**Desde otras notas:**
- [[Vista Perfil-Index]] carga este script · `loads_script` EXTRACTED
