---
tipo: general
tags:
  - tipo/general
---
# Bitácora

Lo más nuevo arriba. Para el detalle por commit ver [[Historial del repo]].

- **30/10** · Explorar (Buscar) sin filtro de distancia (sin commit, en `C:\Users\rafae\Proyectos\swappit`): se sacó el rango de km de los filtros y la opción "Más cercanos" del orden, que no hacían nada porque la base no tiene coordenadas. El orden por defecto ahora dice "Más recientes", que es el orden real. Se borró el JS y el CSS del rango. Sin cambios en la base.
- **30/10** · Puesta al día de la compu y de la vault: `git pull` de `cc3a330` a `f639baa` (la vault vieja quedó en `Vault-local/`, sin nada que no esté acá). Grafo regenerado con graphify + complemento de SQL: 492 nodos, 1119 conexiones, 31 comunidades (antes 343 / 683 / 21). 72 notas nuevas (IntercambioController, NotificacionesController, métodos nuevos de BD, viewmodels, vistas de intercambio, chat, notificaciones e inicio, tablas y scripts de notificaciones/chat) y textos corregidos de chat, intercambios, notificaciones, SP arreglados y pendientes.
- **30/10** · Rediseño del inicio para usuarios logueados (sin commit, en `C:\Users\rafae\Proyectos\swappit`): saludo grande y centrado con los botones abajo; resumen e intercambios en curso en una columna al costado (filas compactas, con "Responder" en bordó cuando hay que contestar); "Recién publicados" pasa a "Artículos recomendados" (por ahora, los últimos artículos disponibles de los demás). Sin cambios en la base.
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
