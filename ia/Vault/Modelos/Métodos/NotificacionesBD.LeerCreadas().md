---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD/NotificacionesBD.cs"
graphify_ids:
  - "models_bd_notificacionesbd_swappit_models_notificacionesbd_leercreadas"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# NotificacionesBD.LeerCreadas()

Método de `NotificacionesBD` ([[BD]]) · `Models/BD/NotificacionesBD.cs` línea 78. Parámetros: `SqlMapper.GridReader,List<NotificacionCreada>?`.

Lee el último resultado que devuelven los SP que crean notificaciones (Id del usuario, del intercambio, tipo y cambio) y lo suma a la lista que después usa [[EmailService]].

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- usa el tipo [[List]] · `references` EXTRACTED

**Desde otras notas:**
- [[ChatBD.EnviarMensaje()]] la llama · `calls` EXTRACTED
- [[IntercambiosBD.AgregarArticulos()]] la llama · `calls` EXTRACTED
- [[IntercambiosBD.CambiarEstadoIntercambio()]] la llama · `calls` EXTRACTED
- [[IntercambiosBD.CancelarIntercambio()]] la llama · `calls` EXTRACTED
- [[IntercambiosBD.CrearPedido()]] la llama · `calls` EXTRACTED
- [[IntercambiosBD.ProponerIntercambio()]] la llama · `calls` EXTRACTED
- [[IntercambiosBD.ResponderCambio()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
