---
tipo: flujo
tags:
  - tipo/flujo
---
# Flujo: Chat

**URL:** `/Chat` y `/Chat/Index/5` · **Estado:** funciona (necesita [[Script Chat.sql]] en bases creadas antes del 29/10).

- Se entra por el ícono de mensajes del header, por los links al chat de [[Vista Intercambio-Detalle]], por la notificación "Mensaje nuevo" o por "mensajes sin leer" en [[Vista Home-Inicio]] → [[ChatController]].Index → [[Vista Chat-Index]].
- Un chat por intercambio ([[Tabla Mensajes]].IdIntercambio → [[Tabla Intercambios]]), solo para sus dos partes. Se escribe mientras está Pendiente o Aceptado; si se rechazó o se realizó, queda para leer.
- Enviar es un form normal (POST a `Enviar`, hasta 500 caracteres) que recarga la página. [[BD.EnviarMensaje()]] guarda el mensaje y, en la misma transacción, crea la notificación "Mensaje nuevo" (una sola mientras no la lea).
- [[chat.js]] pide `ChatController.Mensajes` cada 4 segundos para mostrar los mensajes nuevos y los "visto" sin recargar. Al abrir un chat, [[BD.MarcarMensajesVistos()]] marca como vistos los mensajes de la otra persona y como leídas sus notificaciones de ese chat.
- Escrito en [[BD]] con Dapper, sin usar [[SP RegistrarMensaje]] (decisión del 29/10).
