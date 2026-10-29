---
tipo: flujo
tags:
  - tipo/flujo
---
# Flujo: Notificaciones y favoritos

**Estado:** solo visual. No hay tablas en la base para ninguno de los dos.

- **Notificaciones:** la campana del header ([[Vista _Layout]]) abre [[Vista _PopupNotificaciones]], que muestra el estado vacío ("No tenés notificaciones"). [[notificaciones.js]] lo abre y cierra (clic, Esc, clic afuera, Tab). El partial ya documenta el HTML de la lista para cuando haya backend.
- **Favoritos:** el corazón de cada [[Vista _CardObjeto]] alterna el ícono con [[favoritos.js]]. El corazón del header apunta a `#`.
