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
| IdArticulos1, IdArticulos2 | int NOT NULL, FK → [[Tabla Articulos]] |
| Ubicacion | varchar(50) NULL (punto de encuentro) |

Quien propone queda en `IdUsuarios1`/`IdArticulos1` (lo que ofrece) y el dueño del artículo pedido en `IdUsuarios2`/`IdArticulos2` ([[Flujo Proponer intercambio]]). Sin datos de prueba. Modelo: [[Intercambios]] (le falta `Ubicacion`, que no se usa). Para la pantalla se lee con [[BD.GetIntercambios()]] como [[IntercambioViewModel]].

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- usa el tipo [[Tabla Articulos]] · `references` EXTRACTED
- usa el tipo [[Tabla EstadosIntercambios]] · `references` EXTRACTED
- usa el tipo [[Tabla Usuarios]] · `references` EXTRACTED

**Desde otras notas:**
- [[Script Estructura.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Intercambios]] es su clase en C# · `maps_to` INFERRED
- [[BD.ArticuloComprometido()]] lee de acá · `reads_from` EXTRACTED
- [[BD.CambiarEstadoIntercambio()]] lee de acá · `reads_from` EXTRACTED
- [[BD.ContarPendientesDeArticulos()]] lee de acá · `reads_from` EXTRACTED
- [[BD.EnviarMensaje()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetArticulosCatalogo()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetFiltroCategorias()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetFiltroEstados()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetIdPropuestaEnCurso()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetIntercambio()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetIntercambios()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetMensajes()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetNotificaciones()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetResumenesChat()]] lee de acá · `reads_from` EXTRACTED
- [[BD.MarcarMensajesVistos()]] lee de acá · `reads_from` EXTRACTED
- [[BD.ProponerIntercambio()]] lee de acá · `reads_from` EXTRACTED
- [[BD.RechazarPendientesDeArticulos()]] lee de acá · `reads_from` EXTRACTED
- [[SP RegistrarMensaje]] lee de acá · `reads_from` EXTRACTED
- [[Tabla Mensajes]] la usa como tipo · `references` EXTRACTED
- [[BD.CambiarEstadoIntercambio()]] escribe acá · `writes_to` EXTRACTED
- [[BD.CancelarIntercambio()]] escribe acá · `writes_to` EXTRACTED
- [[BD.ProponerIntercambio()]] escribe acá · `writes_to` EXTRACTED
- [[BD.RechazarPendientesDeArticulos()]] escribe acá · `writes_to` EXTRACTED
- [[SP RegistrarIntercambio]] escribe acá · `writes_to` EXTRACTED
