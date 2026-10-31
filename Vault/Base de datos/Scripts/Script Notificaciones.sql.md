---
tipo: script
comunidad: "Script de notificaciones"
archivos:
  - "BaseDatos/Notificaciones.sql"
graphify_ids:
  - "basedatos_notificaciones"
tags:
  - tipo/script
  - comunidad/Script_de_notificaciones
---
# Script Notificaciones.sql

`BaseDatos/Notificaciones.sql` · Para bases **ya creadas**: crea [[Tabla TipoNotificaciones]] (con sus 5 tipos) y [[Tabla Notificaciones]] con sus claves foráneas. Solo crea lo que falta, se puede ejecutar varias veces. Lo mismo ya está en [[Script SQLSwappit.sql]].

Comunidad del grafo: [[Comunidad - Script de notificaciones]]

## Conexiones en el grafo (graphify)
- contiene [[Tabla Notificaciones]] · `contains` EXTRACTED
- contiene [[Tabla TipoNotificaciones]] · `contains` EXTRACTED
