---
tipo: tabla
comunidad: "Tablas y acceso a datos"
archivos:
  - "BaseDatos/Estructura.sql"
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
graphify_ids:
  - "basedatos_estructura_dbo_mensajes"
  - "sqlswappit_dbo_mensajes"
  - "sqlswappit_cualquiercompu_dbo_mensajes"
  - "basedatos_storedprocedures_sql_mensajes"
tags:
  - tipo/tabla
  - comunidad/Tablas_y_acceso_a_datos
---
# Tabla Mensajes

`IdMensajes` (PK), `Texto` varchar(**500**), `fueVisto` bit, `FechaEnviado` datetime, `FechaRecibido` datetime NULL, `IdUsuariosManda` (FK → [[Tabla Usuarios]]), `IdIntercambio` (FK → [[Tabla Intercambios]]). Cada chat es de un intercambio ([[Flujo Chat]]). En bases creadas antes del chat hay que correr [[Script Chat.sql]] (de 50 a 500 caracteres y de date a datetime). Modelo: [[Mensajes]].

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- usa el tipo [[Tabla Intercambios]] · `references` EXTRACTED
- usa el tipo [[Tabla Usuarios]] · `references` EXTRACTED

**Desde otras notas:**
- [[Script Estructura.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Mensajes]] es su clase en C# · `maps_to` INFERRED
- [[BD.GetMensajes()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetResumenesChat()]] lee de acá · `reads_from` EXTRACTED
- [[BD.EnviarMensaje()]] escribe acá · `writes_to` EXTRACTED
- [[BD.MarcarMensajesVistos()]] escribe acá · `writes_to` EXTRACTED
- [[SP RegistrarMensaje]] escribe acá · `writes_to` EXTRACTED
