---
tipo: tabla
comunidad: "Tablas y acceso a datos"
archivos:
  - "BaseDatos/Estructura.sql"
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
graphify_ids:
  - "basedatos_estructura_dbo_intercambios"
  - "sqlswappit_dbo_intercambios"
  - "sqlswappit_cualquiercompu_dbo_intercambios"
  - "intercambios"
tags:
  - tipo/tabla
  - comunidad/Tablas_y_acceso_a_datos
---
# Tabla Intercambios

| Columna | Tipo |
|---|---|
| IdIntercambios | int identity, PK |
| Fecha | date NOT NULL |
| IdEstado | int NOT NULL, FK → [[Tabla EstadosIntercambios]] |
| IdUsuarios1, IdUsuarios2 | int NOT NULL, FK → [[Tabla Usuarios]] |
| Ubicacion | varchar(50) NULL (punto de encuentro) |

Quien propone queda en `IdUsuarios1` y el dueño del artículo pedido en `IdUsuarios2` ([[Flujo Proponer intercambio]]). Desde el 11/11 los artículos están en [[Tabla ArticulosIntercambios]] (antes eran `IdArticulos1` e `IdArticulos2`). Modelo: [[Intercambios]] (le falta `Ubicacion`, que no se usa). Para la pantalla se lee con [[IntercambiosBD.GetIntercambios()]] como [[IntercambioViewModel]].

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- usa el tipo [[Tabla Usuarios]] · `references` EXTRACTED

**Desde otras notas:**
- [[Script Estructura.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Intercambios]] es su clase en C# · `maps_to` INFERRED
- [[SP AgregarArticulos]] lee de acá · `reads_from` EXTRACTED
- [[SP ArticuloComprometido]] lee de acá · `reads_from` EXTRACTED
- [[SP CancelarCambio]] lee de acá · `reads_from` EXTRACTED
- [[SP Complejos_EstadisticasUsuario]] lee de acá · `reads_from` EXTRACTED
- [[SP Complejos_Personalizado_GestionarPropuestaYNotificacion]] lee de acá · `reads_from` EXTRACTED
- [[SP Complejos_RendimientoPlataformaPorPeriodo]] lee de acá · `reads_from` EXTRACTED
- [[SP Complejos_SeguimientoIntercambiosPendientes]] lee de acá · `reads_from` EXTRACTED
- [[SP ContarArticulosActivos]] lee de acá · `reads_from` EXTRACTED
- [[SP ContarCambiosPendientes]] lee de acá · `reads_from` EXTRACTED
- [[SP ContarIntercambiosActivos]] lee de acá · `reads_from` EXTRACTED
- [[SP ContarIntercambiosPorEstado]] lee de acá · `reads_from` EXTRACTED
- [[SP ContarMensajesNoLeidos]] lee de acá · `reads_from` EXTRACTED
- [[SP ContarPendientesDeArticulos]] lee de acá · `reads_from` EXTRACTED
- [[SP CrearPedido]] lee de acá · `reads_from` EXTRACTED
- [[SP EnviarMensaje]] lee de acá · `reads_from` EXTRACTED
- [[SP GetArticulosCatalogo]] lee de acá · `reads_from` EXTRACTED
- [[SP GetArticulosDeIntercambio]] lee de acá · `reads_from` EXTRACTED
- [[SP GetCambiosIntercambio]] lee de acá · `reads_from` EXTRACTED
- [[SP GetCategoriasDeUsuario]] lee de acá · `reads_from` EXTRACTED
- [[SP GetDatosMailNotificacion]] lee de acá · `reads_from` EXTRACTED
- [[SP GetFavoritos]] lee de acá · `reads_from` EXTRACTED
- [[SP GetFiltroCategorias]] lee de acá · `reads_from` EXTRACTED
- [[SP GetFiltroEstados]] lee de acá · `reads_from` EXTRACTED
- [[SP GetIdPropuestaEnCurso]] lee de acá · `reads_from` EXTRACTED
- [[SP GetIntercambios]] lee de acá · `reads_from` EXTRACTED
- [[SP GetMensajes]] lee de acá · `reads_from` EXTRACTED
- [[SP GetNotificaciones]] lee de acá · `reads_from` EXTRACTED
- [[SP GetResumenesChat]] lee de acá · `reads_from` EXTRACTED
- [[SP GetSenalesGustos]] lee de acá · `reads_from` EXTRACTED
- [[SP IntercambioConArticuloComprometido]] lee de acá · `reads_from` EXTRACTED
- [[SP MarcarMensajesVistos]] lee de acá · `reads_from` EXTRACTED
- [[SP RegistrarMensaje]] lee de acá · `reads_from` EXTRACTED
- [[SP ResponderCambio]] lee de acá · `reads_from` EXTRACTED
- [[Tabla Notificaciones]] la usa como tipo · `references` EXTRACTED
- [[SP CambiarEstadoIntercambio]] escribe acá · `writes_to` EXTRACTED
- [[SP CancelarIntercambio]] escribe acá · `writes_to` EXTRACTED
- [[SP ProponerIntercambio]] escribe acá · `writes_to` EXTRACTED
- [[SP RechazarPendientesDeArticulos]] escribe acá · `writes_to` EXTRACTED
- [[SP RegistrarIntercambio]] escribe acá · `writes_to` EXTRACTED
