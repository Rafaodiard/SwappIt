---
tipo: metodo
comunidad: "Controllers, vistas y JS"
archivos:
  - "Controllers/ChatController.cs"
graphify_ids:
  - "controllers_chatcontroller_swappit_controllers_chatcontroller_puedeescribir"
tags:
  - tipo/metodo
  - comunidad/Controllers_vistas_y_JS
---
# ChatController.PuedeEscribir()

Método de [[ChatController]] · `Controllers/ChatController.cs`. Parámetros: [[IntercambioViewModel]] y `bool` (si la otra persona ya escribió). true si el intercambio está Aceptado, o si está Pendiente y quien escribe es el que recibió la propuesta (o ese ya le escribió). La misma regla está en el SQL de [[ChatBD.EnviarMensaje()]]. Hasta el 08/11 se llamaba `EnCurso`.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- usa el tipo [[IntercambioViewModel]] · `references` EXTRACTED

**Desde otras notas:**
- [[ChatController.Index()]] la llama · `calls` EXTRACTED
- [[ChatController]] la tiene como método · `method` EXTRACTED
