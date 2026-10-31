---
tipo: js
comunidad: "JS de notificaciones"
archivos:
  - "wwwroot/js/notificaciones.js"
graphify_ids:
  - "wwwroot_js_notificaciones"
tags:
  - tipo/js
  - comunidad/JS_de_notificaciones
---
# notificaciones.js

`wwwroot/js/notificaciones.js` · Todas las páginas (si hay campana, o sea, si estás logueado). `abrir(abierto)` alterna la clase `abierto` y `aria-expanded`. Cierra con Esc (vuelve el foco a la campana), con clic afuera o al salir con Tab. Pop up: [[Vista _PopupNotificaciones]].
- `cargarCantidad()` / `mostrarCantidad()`: pide `NotificacionesController.NoLeidas` y muestra el contador de la campana.
- `cargarLista()`: al abrir, pide `NotificacionesController.Lista` ([[Vista Notificaciones-_Lista]]).
- "Marcar todas como leídas": fetch POST a `MarcarTodasLeidas` y vuelve a cargar lista y contador.
Las URLs vienen de [[Vista _Layout]] en `data-url-no-leidas` / `data-url-lista` (un .js no puede usar Razor).

Comunidad del grafo: [[Comunidad - JS de notificaciones]]

## Conexiones en el grafo (graphify)
- contiene [[notificaciones.js abrir()]] · `contains` EXTRACTED
- contiene [[notificaciones.js cargarCantidad()]] · `contains` EXTRACTED
- contiene [[notificaciones.js cargarLista()]] · `contains` EXTRACTED
- contiene [[notificaciones.js mostrarCantidad()]] · `contains` EXTRACTED

**Desde otras notas:**
- [[Vista _Layout]] carga este script · `loads_script` EXTRACTED
