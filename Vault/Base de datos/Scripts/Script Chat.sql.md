---
tipo: script
comunidad: "Script del chat"
archivos:
  - "BaseDatos/Chat.sql"
graphify_ids:
  - "basedatos_chat"
tags:
  - tipo/script
  - comunidad/Script_del_chat
---
# Script Chat.sql

`BaseDatos/Chat.sql` · Para bases **ya creadas**: `Mensajes.Texto` pasa de varchar(50) a varchar(500) y `FechaEnviado`/`FechaRecibido` de date a datetime (el chat muestra la hora). Actualiza [[SP RegistrarMensaje]] con los mismos tipos. Conserva los mensajes que haya y se puede ejecutar varias veces. Ver [[Tabla Mensajes]].

Comunidad del grafo: [[Comunidad - Script del chat]]

## Conexiones en el grafo (graphify)
