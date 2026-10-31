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

`IdEstadosIntercambios` (PK) y `Nombre`. Datos: 1 Pendiente, 2 Aceptado, 3 Rechazado, 4 Realizado, 5 Cancelado (en bases viejas lo agrega [[Script Cancelado.sql]]). Aceptado y Realizado dejan los artículos "comprometidos" ([[BD.ArticuloComprometido()]]). Modelo: [[EstadosIntercambios]].

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)

**Desde otras notas:**
- [[Script Estados.sql]] la contiene · `contains` EXTRACTED
- [[Script Estructura.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[EstadosIntercambios]] es su clase en C# · `maps_to` INFERRED
- [[BD.ArticuloComprometido()]] lee de acá · `reads_from` EXTRACTED
- [[BD.CambiarEstadoIntercambio()]] lee de acá · `reads_from` EXTRACTED
- [[BD.CancelarIntercambio()]] lee de acá · `reads_from` EXTRACTED
- [[BD.ContarPendientesDeArticulos()]] lee de acá · `reads_from` EXTRACTED
- [[BD.EnviarMensaje()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetArticulosCatalogo()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetEstadosIntercambios()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetFiltroCategorias()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetFiltroEstados()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetIdPropuestaEnCurso()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetIntercambio()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetIntercambios()]] lee de acá · `reads_from` EXTRACTED
- [[BD.ProponerIntercambio()]] lee de acá · `reads_from` EXTRACTED
- [[BD.RechazarPendientesDeArticulos()]] lee de acá · `reads_from` EXTRACTED
- [[SP RegistrarIntercambio]] lee de acá · `reads_from` EXTRACTED
- [[Tabla Intercambios]] la usa como tipo · `references` EXTRACTED
