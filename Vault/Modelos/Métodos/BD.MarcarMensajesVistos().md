---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD.cs"
graphify_ids:
  - "models_bd_swappit_models_bd_marcarmensajesvistos"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# BD.MarcarMensajesVistos()

Método de [[BD]] · `Models/BD.cs` línea 709. Parámetros: `int,int`.

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- lee de [[Tabla Intercambios]] · `reads_from` EXTRACTED
- lee de [[Tabla TipoNotificaciones]] · `reads_from` EXTRACTED
- escribe en [[Tabla Mensajes]] · `writes_to` EXTRACTED
- escribe en [[Tabla Notificaciones]] · `writes_to` EXTRACTED

**Desde otras notas:**
- [[ChatController.Index()]] la llama · `calls` EXTRACTED
- [[ChatController.Mensajes()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
