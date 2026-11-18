---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD/ChatBD.cs"
graphify_ids:
  - "models_bd_chatbd_swappit_models_chatbd_marcarmensajesvistos"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# ChatBD.MarcarMensajesVistos()

Método de `ChatBD` ([[BD]]) · `Models/BD/ChatBD.cs` línea 55. Parámetros: `int,int`.

Llama al SP [[SP MarcarMensajesVistos]] con `CommandType.StoredProcedure`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- llama al SP [[SP MarcarMensajesVistos]] · `calls_sp` EXTRACTED

**Desde otras notas:**
- [[ChatController.Index()]] la llama · `calls` EXTRACTED
- [[ChatController.Mensajes()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
