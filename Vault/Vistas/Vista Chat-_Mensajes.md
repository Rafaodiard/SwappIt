---
tipo: vista
comunidad: "Controllers, vistas y JS"
archivos:
  - "Views/Chat/_Mensajes.cshtml"
graphify_ids:
  - "views_chat_mensajes"
tags:
  - tipo/vista
  - comunidad/Controllers_vistas_y_JS
---
# Vista: Chat / _Mensajes (partial)

`Views/Chat/_Mensajes.cshtml` · Mensajes del chat abierto ([[Tabla Mensajes]]). Lo incluye [[Vista Chat-Index]] y lo devuelve `ChatController.Mensajes`, que [[chat.js]] pide cada 4 segundos. Clase `enviado` o `recibido` según quién lo mandó; antes del primer mensaje de cada día va la fecha.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)

**Desde otras notas:**
- [[Vista Chat-Index]] incluye este partial · `includes` EXTRACTED
- [[ChatController.Mensajes()]] muestra esta vista · `renders` EXTRACTED
