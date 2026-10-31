---
tipo: js
comunidad: "Controllers, vistas y JS"
archivos:
  - "wwwroot/js/chat.js"
graphify_ids:
  - "wwwroot_js_chat"
tags:
  - tipo/js
  - comunidad/Controllers_vistas_y_JS
---
# chat.js

`wwwroot/js/chat.js` · Solo en [[Vista Chat-Index]]. Baja hasta el último mensaje al abrir y, en compu, pone el foco en el campo de texto. Cada 4 segundos `actualizar()` pide `ChatController.Mensajes` (partial [[Vista Chat-_Mensajes]]) y, si cambió, lo reemplaza: así aparecen los mensajes nuevos y los "visto" sin recargar. La URL viene en `data-url-mensajes` (la arma la vista con `@Url.Action`). El buscador de la lista filtra las conversaciones.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- llama indirectamente a [[chat.js actualizar()]] · `indirect_call` INFERRED

**Desde otras notas:**
- [[Vista Chat-Index]] carga este script · `loads_script` EXTRACTED
