---
tipo: general
tags:
  - tipo/general
---
# Bitácora

Lo más nuevo arriba. Para el detalle por commit ver [[Historial del repo]].

- **29/10** · Inicio para usuarios logueados (sin commit, en `C:\Users\49758734\Desktop\swappit`): "/" muestra la landing solo a visitantes; con sesión se ve `Views/Home/Inicio.cshtml` con saludo, resumen (propuestas por responder, mensajes sin leer, artículos publicados), intercambios en curso y "Recién publicados" sin los artículos propios. No necesita cambios en la base.
- **29/10** · Chat funcionando (sin commit, en `C:\Users\49758734\Desktop\swappit`): un chat por intercambio, se puede escribir mientras está Pendiente o Aceptado, se actualiza solo cada 4 segundos, marca "visto" y avisa con la notificación "Mensaje nuevo". Hay que correr `BaseDatos/Chat.sql` (Mensajes.Texto pasa a 500 caracteres y las fechas a datetime).
- **29/10** · Intercambios funcionando (rama `Intercambios`, sin commit): proponer desde el artículo, Mis intercambios con filtros, Ver intercambio (aceptar, rechazar, marcar realizado) e historial en Mi perfil. Sin notificaciones todavía.
- **29/10** · Vault de Obsidian en `Vault` con 230 notas y el grafo de graphify (343 nodos, 683 conexiones). Rafael recreó la bóveda en Obsidian y se volvió a copiar. Reglas nuevas: actualizar vault y grafo en cada mensaje en esta compu; usar la vault como memoria secundaria.
- **28/10** · Martina: estados como tablas, pop up de notificaciones, rutas de imágenes de prueba, controllers separados, 20 SP nuevos en SQLSwappit.sql (con bugs, ver [[Pendientes y problemas]]). Guía completa del código para la hackatón del 29/10.
- **27/10** · Publicar artículo guarda en la base con fotos. Descripción del perfil. Todos los scripts de creación sincronizados.
- **26/10** · Pantallas nuevas en Figma. Martina cambió los artículos de prueba (20 con foto).
- **25/10** · ViewBag en todo el proyecto, detalle de artículo, perfil público, hash de contraseñas, pulido de diseño y paleta oficial.
- **22/10** · Catálogo y filtros leen de la base.
- **21/10** · Login, registro, sesión y edición de perfil.
- **15/10** · Creación del proyecto.
