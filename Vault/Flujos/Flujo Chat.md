---
tipo: flujo
tags:
  - tipo/flujo
---
# Flujo: Chat

**URL:** `/Chat` y `/Chat/Index/5` · **Estado:** funciona (necesita [[Script Chat.sql]] en bases creadas antes del 29/10).

- Se entra por el ícono de mensajes del header, por los links al chat de [[Vista Intercambio-Detalle]], por la notificación "Mensaje nuevo" o por "mensajes sin leer" en [[Vista Home-Inicio]] → [[ChatController]].Index → [[Vista Chat-Index]].
- Un chat por intercambio ([[Tabla Mensajes]].IdIntercambio → [[Tabla Intercambios]]), solo para sus dos partes. Con el intercambio **Pendiente**, el chat solo lo empieza quien recibió la propuesta; quien propuso puede responder cuando el otro ya le escribió. Con el intercambio **Aceptado** escriben los dos. Si se rechazó, se canceló o se realizó, queda para leer. La regla está en [[ChatController.PuedeEscribir()]] y en el SQL de [[BD.EnviarMensaje()]]. Historia: hasta el 04/11 escribían los dos en Pendiente; del 04/11 al 08/11 solo en Aceptado; desde el 08/11, esta regla (pedido de Rafael).
- Enviar es un form normal (POST a `Enviar`, hasta 500 caracteres) que recarga la página. [[BD.EnviarMensaje()]] guarda el mensaje y, en la misma transacción, crea la notificación "Mensaje nuevo" (una sola mientras no la lea).
- [[chat.js]] pide `ChatController.Mensajes` cada 4 segundos para mostrar los mensajes nuevos y los "visto" sin recargar. Al abrir un chat, [[BD.MarcarMensajesVistos()]] marca como vistos los mensajes de la otra persona y como leídas sus notificaciones de ese chat.
- El avatar del encabezado tiene `data-iniciales`: si la foto no carga, [[imagenes.js]] pone las iniciales (antes del 08/11 se veía la imagen rota).
- Escrito en [[BD]] con Dapper, sin usar [[SP RegistrarMensaje]] (decisión del 29/10).
