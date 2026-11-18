---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD/ChatBD.cs"
graphify_ids:
  - "models_bd_chatbd_swappit_models_chatbd_getresumeneschat"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# ChatBD.GetResumenesChat()

Método de `ChatBD` ([[BD]]) · `Models/BD/ChatBD.cs` línea 10. Parámetros: `int`.

Llama al SP [[SP GetResumenesChat]] con `CommandType.StoredProcedure`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- llama al SP [[SP GetResumenesChat]] · `calls_sp` EXTRACTED
- usa el tipo [[ConversacionViewModel]] · `references` EXTRACTED
- usa el tipo [[List]] · `references` EXTRACTED

**Desde otras notas:**
- [[ChatController.Index()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
