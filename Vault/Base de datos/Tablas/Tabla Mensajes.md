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

`IdMensajes` (PK), `Texto` varchar(**500**), `fueVisto` bit, `FechaEnviado` datetime, `FechaRecibido` datetime NULL, `IdUsuariosManda` (FK → [[Tabla Usuarios]]), `IdIntercambio` (FK → [[Tabla Intercambios]]). Cada chat es de un intercambio ([[Flujo Chat]]). Modelo: [[Mensajes]].

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- usa el tipo [[Tabla Usuarios]] · `references` EXTRACTED

**Desde otras notas:**
- [[Script Estructura.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Mensajes]] es su clase en C# · `maps_to` INFERRED
- [[SP Complejos_SeguimientoIntercambiosPendientes]] lee de acá · `reads_from` EXTRACTED
- [[SP ContarMensajesNoLeidos]] lee de acá · `reads_from` EXTRACTED
- [[SP GetIntercambios]] lee de acá · `reads_from` EXTRACTED
- [[SP GetMensajes]] lee de acá · `reads_from` EXTRACTED
- [[SP GetResumenesChat]] lee de acá · `reads_from` EXTRACTED
- [[SP EnviarMensaje]] escribe acá · `writes_to` EXTRACTED
- [[SP MarcarMensajesVistos]] escribe acá · `writes_to` EXTRACTED
- [[SP RegistrarMensaje]] escribe acá · `writes_to` EXTRACTED
