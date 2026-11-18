---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD/ChatBD.cs"
graphify_ids:
  - "models_bd_chatbd_swappit_models_chatbd_enviarmensaje"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# ChatBD.EnviarMensaje()

Método de `ChatBD` ([[BD]]) · `Models/BD/ChatBD.cs` línea 40. Parámetros: `int,int,string,List<NotificacionCreada>?`.

Llama al SP [[SP EnviarMensaje]] con `CommandType.StoredProcedure`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- llama a [[NotificacionesBD.LeerCreadas()]] · `calls` EXTRACTED
- llama al SP [[SP EnviarMensaje]] · `calls_sp` EXTRACTED
- usa el tipo [[List]] · `references` EXTRACTED

**Desde otras notas:**
- [[ChatController.Enviar()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
