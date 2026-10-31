---
tipo: general
tags:
  - tipo/general
---
# Decisiones

| Fecha | Decisión | Motivo / nota |
|---|---|---|
| 22/10 | Filtros de Buscar: categoría y estado desde la base | Distancia quedó visual (no hay coordenadas); se sacó el 30/10 |
| 25/10 | Paleta oficial en todo el sitio (`#0d596a`, `#6e2c3a`, `#a5babe`, `#ece6d8`) | Elegido por Rafael |
| 25/10 | Contraseñas con `PasswordHasher`, sin paquetes extra | Las de prueba se re-hashean al primer login |
| 25/10 | "Proponer intercambio" queda visual por ahora | Plan propuesto: insertar en Intercambios con estado Pendiente, sin usar RegistrarIntercambio |
| 25/10 | Perfil público sin mail, teléfono ni edad | Privacidad |
| 26/10 | Notificaciones como pop up de la campana, no como página | Pedido de Rafael |
| 27/10 | Fotos de artículos: hasta 6, JPG/PNG, 10 MB; se guardan en `wwwroot/img/articulos` | |
| 28/10 | Estados como tablas: EstadosArticulos y EstadosIntercambios, con IdEstado FK | Estados de intercambio: Pendiente, **Aceptado**, Rechazado, Realizado (Figma dice "En curso") |
| 28/10 | Controllers separados por tema, con URLs nuevas | Articulos, Publicar, Perfil, Chat, Account, Home |
| 28/10 | Tipografías Century Gothic (texto) + Forum (títulos) | Aunque Figma use Jost en algunos lugares |
| 28/10 | Scripts sueltos de `BaseDatos/` que ya estaban en los de creación se borraron | Quedan Estructura, Datos, StoredProcedures (+ Estados.sql hasta que Rafael lo corra) |
| 29/10 | Vault de Obsidian + grafo de graphify como documentación y memoria | Ver [[Cómo usar esta vault]] |
| 29/10 | Intercambios: quien propone en IdUsuarios1/IdArticulos1, el dueño del artículo pedido en IdUsuarios2/IdArticulos2; sin usar el SP RegistrarIntercambio | Solo el dueño acepta o rechaza; cualquiera de los dos marca Realizado. Una propuesta en curso por artículo. Sin notificaciones por ahora |
| 29/10 | Chat: uno por intercambio (Mensajes.IdIntercambio), escrito en BD.cs con Dapper, sin usar el SP RegistrarMensaje; mensajes con form normal + actualización cada 4 s con fetch (sin SignalR) | Se escribe en Pendiente y Aceptado; en Rechazado y Realizado queda para leer. Una sola notificación "Mensaje nuevo" sin leer por chat. Mensajes.Texto varchar(500) y fechas datetime (BaseDatos/Chat.sql) |
| 29/10 | "/" (Home/Index) muestra la landing a visitantes y el inicio (`Home/Inicio.cshtml`) a quien tiene sesión, en la misma URL | Pedido de Rafael. Contenido elegido con lo que ya existe: intercambios en curso (primero los que hay que responder), contadores y últimos artículos de los demás. Las notificaciones no se repiten: están en la campana |
| 30/10 | Sacar el filtro de distancia y "Más cercanos" de Explorar | Pedido de Rafael: no hay coordenadas en la base, así que no hacían nada. Si vuelve, necesita ubicación real (no solo barrio) |
