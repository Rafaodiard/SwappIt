---
tipo: script
comunidad: "SPs originales"
archivos:
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "basedatos_storedprocedures"
tags:
  - tipo/script
  - comunidad/SPs_originales
---
# Script StoredProcedures.sql

`BaseDatos/StoredProcedures.sql` · 3 de 3. Los 72 SP (17/11), los mismos que en [[Script SQLSwappit.sql]] y [[Script SQLSwappit_CualquierCompu.sql]]: los 4 originales, los del 28/10 de usuarios y artículos, los 6 `Complejos_*` y los del 17/11 que reemplazan todo el SQL que había en C# (ver [[Base de datos]]). Van en orden alfabético, salvo [[SP CrearNotificacion]] y [[SP RechazarPendientesDeArticulos]], que van antes de los SP que los llaman.

Comunidad del grafo: [[Comunidad - SPs originales]]

## Conexiones en el grafo (graphify)
- contiene [[SP ActualizarContrasena]] · `contains` EXTRACTED
- contiene [[SP AgregarArticulos]] · `contains` EXTRACTED
- contiene [[SP AlternarFavorito]] · `contains` EXTRACTED
- contiene [[SP ArticuloComprometido]] · `contains` EXTRACTED
- contiene [[SP BorrarFotoUsuario]] · `contains` EXTRACTED
- contiene [[SP CambiarEstadoIntercambio]] · `contains` EXTRACTED
- contiene [[SP CancelarCambio]] · `contains` EXTRACTED
- contiene [[SP CancelarIntercambio]] · `contains` EXTRACTED
- contiene [[SP Complejos_Ejecucion]] · `contains` EXTRACTED
- contiene [[SP Complejos_EstadisticasUsuario]] · `contains` EXTRACTED
- contiene [[SP Complejos_Personalizado_GestionarPropuestaYNotificacion]] · `contains` EXTRACTED
- contiene [[SP Complejos_RecomendarUsuariosIntercambio]] · `contains` EXTRACTED
- contiene [[SP Complejos_RendimientoPlataformaPorPeriodo]] · `contains` EXTRACTED
- contiene [[SP Complejos_SeguimientoIntercambiosPendientes]] · `contains` EXTRACTED
- contiene [[SP ContarArticulosActivos]] · `contains` EXTRACTED
- contiene [[SP ContarCambiosPendientes]] · `contains` EXTRACTED
- contiene [[SP ContarIntercambiosActivos]] · `contains` EXTRACTED
- contiene [[SP ContarIntercambiosPorEstado]] · `contains` EXTRACTED
- contiene [[SP ContarMensajesNoLeidos]] · `contains` EXTRACTED
- contiene [[SP ContarPendientesDeArticulos]] · `contains` EXTRACTED
- contiene [[SP CrearNotificacion]] · `contains` EXTRACTED
- contiene [[SP CrearPedido]] · `contains` EXTRACTED
- contiene [[SP EnviarMensaje]] · `contains` EXTRACTED
- contiene [[SP GetArticuloById]] · `contains` EXTRACTED
- contiene [[SP GetArticulosCatalogo]] · `contains` EXTRACTED
- contiene [[SP GetArticulosDeIntercambio]] · `contains` EXTRACTED
- contiene [[SP GetCambiosIntercambio]] · `contains` EXTRACTED
- contiene [[SP GetCantidadNotificacionesNoLeidas]] · `contains` EXTRACTED
- contiene [[SP GetCategoriaById]] · `contains` EXTRACTED
- contiene [[SP GetCategorias]] · `contains` EXTRACTED
- contiene [[SP GetCategoriasDeUsuario]] · `contains` EXTRACTED
- contiene [[SP GetDatosMailNotificacion]] · `contains` EXTRACTED
- contiene [[SP GetEstadoArticuloById]] · `contains` EXTRACTED
- contiene [[SP GetEstadosArticulos]] · `contains` EXTRACTED
- contiene [[SP GetEstadosIntercambios]] · `contains` EXTRACTED
- contiene [[SP GetFavoritos]] · `contains` EXTRACTED
- contiene [[SP GetFiltroCategorias]] · `contains` EXTRACTED
- contiene [[SP GetFiltroEstados]] · `contains` EXTRACTED
- contiene [[SP GetFotoUsuario]] · `contains` EXTRACTED
- contiene [[SP GetIdPropuestaEnCurso]] · `contains` EXTRACTED
- contiene [[SP GetIdsFavoritos]] · `contains` EXTRACTED
- contiene [[SP GetImagenesArticulo]] · `contains` EXTRACTED
- contiene [[SP GetIntercambios]] · `contains` EXTRACTED
- contiene [[SP GetMensajes]] · `contains` EXTRACTED
- contiene [[SP GetNotificaciones]] · `contains` EXTRACTED
- contiene [[SP GetPopularidad]] · `contains` EXTRACTED
- contiene [[SP GetProvinciaById]] · `contains` EXTRACTED
- contiene [[SP GetProvincias]] · `contains` EXTRACTED
- contiene [[SP GetResumenesChat]] · `contains` EXTRACTED
- contiene [[SP GetSenalesGustos]] · `contains` EXTRACTED
- contiene [[SP GetUltimoCambio]] · `contains` EXTRACTED
- contiene [[SP GetUsuarioById]] · `contains` EXTRACTED
- contiene [[SP GetUsuarioByMail]] · `contains` EXTRACTED
- contiene [[SP GuardarFotoUsuario]] · `contains` EXTRACTED
- contiene [[SP GuardarSegundosVista]] · `contains` EXTRACTED
- contiene [[SP ImportarFavoritos]] · `contains` EXTRACTED
- contiene [[SP IntercambioConArticuloComprometido]] · `contains` EXTRACTED
- contiene [[SP MarcarMensajesVistos]] · `contains` EXTRACTED
- contiene [[SP MarcarNotificacionLeida]] · `contains` EXTRACTED
- contiene [[SP MarcarNotificacionesLeidas]] · `contains` EXTRACTED
- contiene [[SP ProponerIntercambio]] · `contains` EXTRACTED
- contiene [[SP PublicarArticulo]] · `contains` EXTRACTED
- contiene [[SP RechazarPendientesDeArticulos]] · `contains` EXTRACTED
- contiene [[SP RegistrarArticulo]] · `contains` EXTRACTED
- contiene [[SP RegistrarBusqueda]] · `contains` EXTRACTED
- contiene [[SP RegistrarIntercambio]] · `contains` EXTRACTED
- contiene [[SP RegistrarMensaje]] · `contains` EXTRACTED
- contiene [[SP RegistrarUsuario]] · `contains` EXTRACTED
- contiene [[SP RegistrarVista]] · `contains` EXTRACTED
- contiene [[SP ResponderCambio]] · `contains` EXTRACTED
- contiene [[SP UpdateUsuario]] · `contains` EXTRACTED
- contiene [[SP UsuarioExiste]] · `contains` EXTRACTED
