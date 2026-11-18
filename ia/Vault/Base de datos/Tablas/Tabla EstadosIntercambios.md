---
tipo: tabla
comunidad: "Tablas y acceso a datos"
archivos:
  - "BaseDatos/Estados.sql"
  - "BaseDatos/Estructura.sql"
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
graphify_ids:
  - "basedatos_estructura_dbo_estadosintercambios"
  - "basedatos_estados_dbo_estadosintercambios"
  - "sqlswappit_dbo_estadosintercambios"
  - "sqlswappit_cualquiercompu_dbo_estadosintercambios"
  - "basedatos_storedprocedures_sql_estadosintercambios"
tags:
  - tipo/tabla
  - comunidad/Tablas_y_acceso_a_datos
---
# Tabla EstadosIntercambios

`IdEstadosIntercambios` (PK) y `Nombre`. Datos: 1 Pendiente, 2 Aceptado, 3 Rechazado, 4 Realizado, 5 Cancelado. Aceptado y Realizado dejan los artículos "comprometidos" ([[IntercambiosBD.ArticuloComprometido()]]). Modelo: [[EstadosIntercambios]].

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)

**Desde otras notas:**
- [[Script Estructura.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[EstadosIntercambios]] es su clase en C# · `maps_to` INFERRED
- [[SP AgregarArticulos]] lee de acá · `reads_from` EXTRACTED
- [[SP ArticuloComprometido]] lee de acá · `reads_from` EXTRACTED
- [[SP CambiarEstadoIntercambio]] lee de acá · `reads_from` EXTRACTED
- [[SP CancelarCambio]] lee de acá · `reads_from` EXTRACTED
- [[SP CancelarIntercambio]] lee de acá · `reads_from` EXTRACTED
- [[SP ContarArticulosActivos]] lee de acá · `reads_from` EXTRACTED
- [[SP ContarCambiosPendientes]] lee de acá · `reads_from` EXTRACTED
- [[SP ContarIntercambiosActivos]] lee de acá · `reads_from` EXTRACTED
- [[SP ContarIntercambiosPorEstado]] lee de acá · `reads_from` EXTRACTED
- [[SP ContarPendientesDeArticulos]] lee de acá · `reads_from` EXTRACTED
- [[SP CrearPedido]] lee de acá · `reads_from` EXTRACTED
- [[SP EnviarMensaje]] lee de acá · `reads_from` EXTRACTED
- [[SP GetArticulosCatalogo]] lee de acá · `reads_from` EXTRACTED
- [[SP GetCambiosIntercambio]] lee de acá · `reads_from` EXTRACTED
- [[SP GetCategoriasDeUsuario]] lee de acá · `reads_from` EXTRACTED
- [[SP GetEstadosIntercambios]] lee de acá · `reads_from` EXTRACTED
- [[SP GetFavoritos]] lee de acá · `reads_from` EXTRACTED
- [[SP GetFiltroCategorias]] lee de acá · `reads_from` EXTRACTED
- [[SP GetFiltroEstados]] lee de acá · `reads_from` EXTRACTED
- [[SP GetIdPropuestaEnCurso]] lee de acá · `reads_from` EXTRACTED
- [[SP GetIntercambios]] lee de acá · `reads_from` EXTRACTED
- [[SP GetSenalesGustos]] lee de acá · `reads_from` EXTRACTED
- [[SP IntercambioConArticuloComprometido]] lee de acá · `reads_from` EXTRACTED
- [[SP ProponerIntercambio]] lee de acá · `reads_from` EXTRACTED
- [[SP RechazarPendientesDeArticulos]] lee de acá · `reads_from` EXTRACTED
- [[SP RegistrarIntercambio]] lee de acá · `reads_from` EXTRACTED
- [[SP ResponderCambio]] lee de acá · `reads_from` EXTRACTED
