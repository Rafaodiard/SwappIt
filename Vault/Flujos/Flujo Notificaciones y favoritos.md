---
tipo: flujo
tags:
  - tipo/flujo
---
# Flujo: Notificaciones y favoritos

**Estado:** las notificaciones funcionan (necesitan [[Script Notificaciones.sql]] en bases viejas). Favoritos no existe: no hay tabla y el corazón se sacó de la card y del header.

- **Notificaciones:** se crean dentro de la transacción de cada acción: "Propuesta recibida" (al dueño del artículo pedido), "Propuesta aceptada" y "Propuesta rechazada" (a quien propuso, también cuando se rechaza sola al aceptar otra), "Intercambio cancelado" y "Mensaje nuevo" (a la otra persona; una sola sin leer por chat). Tablas: [[Tabla Notificaciones]] y [[Tabla TipoNotificaciones]].
- La campana del header ([[Vista _Layout]]) muestra cuántas hay sin leer y abre [[Vista _PopupNotificaciones]]; [[notificaciones.js]] pide la lista a [[NotificacionesController]] ([[Vista Notificaciones-_Lista]]: Nuevas y Anteriores). "Ver ..." la marca como leída y lleva al intercambio o al chat; también se puede marcar todas como leídas.
- **Favoritos:** [[favoritos.js]] quedó en el proyecto pero ninguna vista lo carga.
