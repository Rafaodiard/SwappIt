---
tipo: modelo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD/UsuariosBD.cs"
  - "Models/BD/ArticulosBD.cs"
  - "Models/BD/IntercambiosBD.cs"
  - "Models/BD/ChatBD.cs"
  - "Models/BD/NotificacionesBD.cs"
  - "Models/BD/FavoritosBD.cs"
  - "Models/BD/RecomendacionesBD.cs"
  - "Models/BD/ConexionBD.cs"
graphify_ids:
  - "models_bd_usuariosbd_swappit_models_usuariosbd"
  - "models_bd_articulosbd_swappit_models_articulosbd"
  - "models_bd_intercambiosbd_swappit_models_intercambiosbd"
  - "models_bd_chatbd_swappit_models_chatbd"
  - "models_bd_notificacionesbd_swappit_models_notificacionesbd"
  - "models_bd_favoritosbd_swappit_models_favoritosbd"
  - "models_bd_recomendacionesbd_swappit_models_recomendacionesbd"
  - "models_bd_conexionbd_swappit_models_conexionbd"
tags:
  - tipo/modelo
  - comunidad/Tablas_y_acceso_a_datos
---
# BD (acceso a datos)

Carpeta `Models/BD/` · Siete clases **estáticas**, una por tema, más `ConexionBD`. Desde el 17/11 **cada método que lee o escribe la base llama a un stored procedure** con Dapper y `CommandType.StoredProcedure`: en C# no queda SQL escrito, ni SQL armado con texto, ni listas filtradas con LINQ, y la app ya no cambia la estructura de la base. Están en el namespace `Swappit.Models`, como el resto de los modelos. Cada método abre y cierra su propia `SqlConnection`.

Hasta el 17/11 todo estaba en una sola clase `BD` (`Models/BD.cs`). Martina la dividió por tema (commit `6e0fb97`) y ese mismo día se pasaron las clases a esta carpeta, se juntó la connection string en un solo lugar y, por la devolución docente, todo el SQL pasó a stored procedures (ver [[Bitácora]]).

## Conexión
`ConexionBD.ConnectionString` (`Models/BD/ConexionBD.cs`) es la única cadena de conexión: `Server=localhost; Database=Base_De_Datos_Swappit`, autenticación de Windows (la predeterminada desde el 17/11, como dice el `README.md`). La versión con `.\SQLEXPRESS` está comentada al lado. Para usar otra instancia se cambia solo ese archivo. [[ConexionBD.ListaDeIds()]] arma las listas de ids que reciben los SP.

## Clases
Cada método con el SP al que llama.

### UsuariosBD
`Models/BD/UsuariosBD.cs` · Usuarios, login, registro, provincias y foto de perfil.

- [[UsuariosBD.GetUsuarioByMail()]] → [[SP GetUsuarioByMail]]
- [[UsuariosBD.ActualizarContrasena()]] → [[SP ActualizarContrasena]]
- [[UsuariosBD.UsuarioExiste()]] → [[SP UsuarioExiste]]
- [[UsuariosBD.GetUsuarioById()]] → [[SP GetUsuarioById]]
- [[UsuariosBD.GetProvinciaById()]] → [[SP GetProvinciaById]]
- [[UsuariosBD.GetProvincias()]] → [[SP GetProvincias]]
- [[UsuariosBD.Register()]] → [[SP RegistrarUsuario]]
- [[UsuariosBD.UpdateUsuario()]] → [[SP UpdateUsuario]]
- [[UsuariosBD.GetFotoUsuario()]] → [[SP GetFotoUsuario]]
- [[UsuariosBD.GuardarFotoUsuario()]] → [[SP GuardarFotoUsuario]]
- [[UsuariosBD.BorrarFotoUsuario()]] → [[SP BorrarFotoUsuario]]

### ArticulosBD
`Models/BD/ArticulosBD.cs` · Catálogo, detalle, publicar, categorías, estados de artículo y filtros de Explorar.

- [[ArticulosBD.GetArticulosCatalogo()]] → [[SP GetArticulosCatalogo]]
- [[ArticulosBD.GetArticuloById()]] → [[SP GetArticuloById]]
- [[ArticulosBD.PublicarArticulo()]] → [[SP PublicarArticulo]]
- [[ArticulosBD.ContarArticulosActivos()]] → [[SP ContarArticulosActivos]]
- [[ArticulosBD.GetCategoriasDeUsuario()]] → [[SP GetCategoriasDeUsuario]]
- [[ArticulosBD.GetImagenesArticulo()]] → [[SP GetImagenesArticulo]]
- [[ArticulosBD.GetCategoriaById()]] → [[SP GetCategoriaById]]
- [[ArticulosBD.GetCategorias()]] → [[SP GetCategorias]]
- [[ArticulosBD.GetEstadosArticulos()]] → [[SP GetEstadosArticulos]]
- [[ArticulosBD.GetEstadoArticuloById()]] → [[SP GetEstadoArticuloById]]
- [[ArticulosBD.GetFiltroCategorias()]] → [[SP GetFiltroCategorias]]
- [[ArticulosBD.GetFiltroEstados()]] → [[SP GetFiltroEstados]]
- [[ArticulosBD.TextoBusqueda()]] (privado)

### IntercambiosBD
`Models/BD/IntercambiosBD.cs` · Proponer, aceptar, rechazar, cancelar y marcar realizado; artículos de cada intercambio y cambios (agregar, pedir, sacar).

- [[IntercambiosBD.ContarIntercambiosActivos()]] → [[SP ContarIntercambiosActivos]]
- [[IntercambiosBD.GetIntercambios()]] → [[SP GetIntercambios]]
- [[IntercambiosBD.GetIntercambio()]] → [[SP GetIntercambios]]
- [[IntercambiosBD.ContarIntercambiosPorEstado()]] → [[SP ContarIntercambiosPorEstado]]
- [[IntercambiosBD.GetIdPropuestaEnCurso()]] → [[SP GetIdPropuestaEnCurso]]
- [[IntercambiosBD.ArticuloComprometido()]] → [[SP ArticuloComprometido]]
- [[IntercambiosBD.IntercambioConArticuloComprometido()]] → [[SP IntercambioConArticuloComprometido]]
- [[IntercambiosBD.GetArticulosDeIntercambio()]] → [[SP GetArticulosDeIntercambio]]
- [[IntercambiosBD.ProponerIntercambio()]] → [[SP ProponerIntercambio]]
- [[IntercambiosBD.CambiarEstadoIntercambio()]] → [[SP CambiarEstadoIntercambio]]
- [[IntercambiosBD.CancelarIntercambio()]] → [[SP CancelarIntercambio]]
- [[IntercambiosBD.ContarPendientesDeArticulos()]] → [[SP ContarPendientesDeArticulos]]
- [[IntercambiosBD.GetCambiosIntercambio()]] → [[SP GetCambiosIntercambio]]
- [[IntercambiosBD.ContarCambiosPendientes()]] → [[SP ContarCambiosPendientes]]
- [[IntercambiosBD.GetUltimoCambio()]] → [[SP GetUltimoCambio]]
- [[IntercambiosBD.AgregarArticulos()]] → [[SP AgregarArticulos]]
- [[IntercambiosBD.PedirArticulo()]]
- [[IntercambiosBD.PedirSacarArticulo()]]
- [[IntercambiosBD.CrearPedido()]] (privado) → [[SP CrearPedido]]
- [[IntercambiosBD.ResponderCambio()]] → [[SP ResponderCambio]]
- [[IntercambiosBD.CancelarCambio()]] → [[SP CancelarCambio]]
- [[IntercambiosBD.GetEstadosIntercambios()]] → [[SP GetEstadosIntercambios]]

### ChatBD
`Models/BD/ChatBD.cs` · Conversaciones y mensajes de cada intercambio.

- [[ChatBD.GetResumenesChat()]] → [[SP GetResumenesChat]]
- [[ChatBD.ContarMensajesNoLeidos()]] → [[SP ContarMensajesNoLeidos]]
- [[ChatBD.GetMensajes()]] → [[SP GetMensajes]]
- [[ChatBD.EnviarMensaje()]] → [[SP EnviarMensaje]]
- [[ChatBD.MarcarMensajesVistos()]] → [[SP MarcarMensajesVistos]]

### NotificacionesBD
`Models/BD/NotificacionesBD.cs` · Notificaciones de la campana y datos para los mails.

- [[NotificacionesBD.GetDatosMailNotificacion()]] → [[SP GetDatosMailNotificacion]]
- [[NotificacionesBD.GetNotificaciones()]] → [[SP GetNotificaciones]]
- [[NotificacionesBD.GetCantidadNotificacionesNoLeidas()]] → [[SP GetCantidadNotificacionesNoLeidas]]
- [[NotificacionesBD.MarcarNotificacionLeida()]] → [[SP MarcarNotificacionLeida]]
- [[NotificacionesBD.MarcarNotificacionesLeidas()]] → [[SP MarcarNotificacionesLeidas]]
- [[NotificacionesBD.LeerCreadas()]] (lo usan otras clases de BD)

### FavoritosBD
`Models/BD/FavoritosBD.cs` · Favoritos (Interacciones de tipo Favorito).

- [[FavoritosBD.GetIdsFavoritos()]] → [[SP GetIdsFavoritos]]
- [[FavoritosBD.GetFavoritos()]] → [[SP GetFavoritos]]
- [[FavoritosBD.AlternarFavorito()]] → [[SP AlternarFavorito]]
- [[FavoritosBD.ImportarFavoritos()]] → [[SP ImportarFavoritos]]

### RecomendacionesBD
`Models/BD/RecomendacionesBD.cs` · Vistas, búsquedas, señales de gustos y popularidad para las recomendaciones.

- [[RecomendacionesBD.RegistrarVista()]] → [[SP RegistrarVista]]
- [[RecomendacionesBD.GuardarSegundosVista()]] → [[SP GuardarSegundosVista]]
- [[RecomendacionesBD.RegistrarBusqueda()]] → [[SP RegistrarBusqueda]]
- [[RecomendacionesBD.GetSenalesGustos()]] → [[SP GetSenalesGustos]]
- [[RecomendacionesBD.GetPopularidad()]] → [[SP GetPopularidad]]

## Cómo se pasan los datos a los SP
- **Listas de ids**: texto separado por coma ([[ConexionBD.ListaDeIds()]]); el SP lo lee con `STRING_SPLIT`. Las rutas de las fotos de [[SP PublicarArticulo]] van separadas por `|`.
- **Transacciones**: están adentro de los SP (`SET XACT_ABORT ON` y `BEGIN TRAN`), no en C#.
- **Notificaciones**: los SP que cambian un intercambio o mandan un mensaje crean la tabla temporal `#Creadas`, crean las notificaciones con [[SP CrearNotificacion]] y devuelven un segundo resultado con las que crearon. [[NotificacionesBD.LeerCreadas()]] lo lee para que [[EmailService]] mande los mails.
- **Nombres fijos**: los SP buscan estados y tipos por nombre ('Pendiente', 'Aceptado', 'Vista', 'Favorito', 'Mensaje nuevo'...). Si se cambia un nombre en las tablas de estados o tipos, hay que cambiarlo también en los SP.
- **Filtros y orden**: [[SP GetArticulosCatalogo]] tiene todos los filtros de catálogo y el orden (más recientes, A - Z y populares). Solo "Para vos" se calcula en C# ([[RecomendacionesController]]), con bucles y sin LINQ.

## Lo que comparten las clases
- `ArticulosBD.EstadosComprometidos`: los estados que comprometen un artículo (Aceptado y Realizado), que se pasan a [[SP GetFiltroCategorias]] y [[SP GetFiltroEstados]]. Un artículo comprometido no aparece en el catálogo, los filtros, los perfiles, el inicio, favoritos ni recomendaciones, y no se puede pedir ni ofrecer; los demás SP ya lo resuelven adentro con [[Tabla ArticulosIntercambios]].
- [[NotificacionesBD.LeerCreadas()]]: la usan IntercambiosBD y ChatBD.

## Detalles
- Las fotos de perfil y de artículo están en la misma tabla: las de perfil tienen `IdUsuarios` y `IdArticulos` NULL; las de artículo, `IdArticulos`.
- Los SP de chat chequean que el usuario sea parte del intercambio.
- Tres SP viejos no los usa nadie: [[SP RegistrarArticulo]], [[SP RegistrarIntercambio]] y [[SP RegistrarMensaje]].

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- tiene el método [[ArticulosBD.ContarArticulosActivos()]] · `method` EXTRACTED
- tiene el método [[ArticulosBD.GetArticuloById()]] · `method` EXTRACTED
- tiene el método [[ArticulosBD.GetArticulosCatalogo()]] · `method` EXTRACTED
- tiene el método [[ArticulosBD.GetCategoriaById()]] · `method` EXTRACTED
- tiene el método [[ArticulosBD.GetCategorias()]] · `method` EXTRACTED
- tiene el método [[ArticulosBD.GetCategoriasDeUsuario()]] · `method` EXTRACTED
- tiene el método [[ArticulosBD.GetEstadoArticuloById()]] · `method` EXTRACTED
- tiene el método [[ArticulosBD.GetEstadosArticulos()]] · `method` EXTRACTED
- tiene el método [[ArticulosBD.GetFiltroCategorias()]] · `method` EXTRACTED
- tiene el método [[ArticulosBD.GetFiltroEstados()]] · `method` EXTRACTED
- tiene el método [[ArticulosBD.GetImagenesArticulo()]] · `method` EXTRACTED
- tiene el método [[ArticulosBD.PublicarArticulo()]] · `method` EXTRACTED
- tiene el método [[ArticulosBD.TextoBusqueda()]] · `method` EXTRACTED
- tiene el método [[ChatBD.ContarMensajesNoLeidos()]] · `method` EXTRACTED
- tiene el método [[ChatBD.EnviarMensaje()]] · `method` EXTRACTED
- tiene el método [[ChatBD.GetMensajes()]] · `method` EXTRACTED
- tiene el método [[ChatBD.GetResumenesChat()]] · `method` EXTRACTED
- tiene el método [[ChatBD.MarcarMensajesVistos()]] · `method` EXTRACTED
- tiene el método [[ConexionBD.ListaDeIds()]] · `method` EXTRACTED
- tiene el método [[FavoritosBD.AlternarFavorito()]] · `method` EXTRACTED
- tiene el método [[FavoritosBD.GetFavoritos()]] · `method` EXTRACTED
- tiene el método [[FavoritosBD.GetIdsFavoritos()]] · `method` EXTRACTED
- tiene el método [[FavoritosBD.ImportarFavoritos()]] · `method` EXTRACTED
- tiene el método [[IntercambiosBD.AgregarArticulos()]] · `method` EXTRACTED
- tiene el método [[IntercambiosBD.ArticuloComprometido()]] · `method` EXTRACTED
- tiene el método [[IntercambiosBD.CambiarEstadoIntercambio()]] · `method` EXTRACTED
- tiene el método [[IntercambiosBD.CancelarCambio()]] · `method` EXTRACTED
- tiene el método [[IntercambiosBD.CancelarIntercambio()]] · `method` EXTRACTED
- tiene el método [[IntercambiosBD.ContarCambiosPendientes()]] · `method` EXTRACTED
- tiene el método [[IntercambiosBD.ContarIntercambiosActivos()]] · `method` EXTRACTED
- tiene el método [[IntercambiosBD.ContarIntercambiosPorEstado()]] · `method` EXTRACTED
- tiene el método [[IntercambiosBD.ContarPendientesDeArticulos()]] · `method` EXTRACTED
- tiene el método [[IntercambiosBD.CrearPedido()]] · `method` EXTRACTED
- tiene el método [[IntercambiosBD.GetArticulosDeIntercambio()]] · `method` EXTRACTED
- tiene el método [[IntercambiosBD.GetCambiosIntercambio()]] · `method` EXTRACTED
- tiene el método [[IntercambiosBD.GetEstadosIntercambios()]] · `method` EXTRACTED
- tiene el método [[IntercambiosBD.GetIdPropuestaEnCurso()]] · `method` EXTRACTED
- tiene el método [[IntercambiosBD.GetIntercambio()]] · `method` EXTRACTED
- tiene el método [[IntercambiosBD.GetIntercambios()]] · `method` EXTRACTED
- tiene el método [[IntercambiosBD.GetUltimoCambio()]] · `method` EXTRACTED
- tiene el método [[IntercambiosBD.IntercambioConArticuloComprometido()]] · `method` EXTRACTED
- tiene el método [[IntercambiosBD.PedirArticulo()]] · `method` EXTRACTED
- tiene el método [[IntercambiosBD.PedirSacarArticulo()]] · `method` EXTRACTED
- tiene el método [[IntercambiosBD.ProponerIntercambio()]] · `method` EXTRACTED
- tiene el método [[IntercambiosBD.ResponderCambio()]] · `method` EXTRACTED
- tiene el método [[NotificacionesBD.GetCantidadNotificacionesNoLeidas()]] · `method` EXTRACTED
- tiene el método [[NotificacionesBD.GetDatosMailNotificacion()]] · `method` EXTRACTED
- tiene el método [[NotificacionesBD.GetNotificaciones()]] · `method` EXTRACTED
- tiene el método [[NotificacionesBD.LeerCreadas()]] · `method` EXTRACTED
- tiene el método [[NotificacionesBD.MarcarNotificacionLeida()]] · `method` EXTRACTED
- tiene el método [[NotificacionesBD.MarcarNotificacionesLeidas()]] · `method` EXTRACTED
- tiene el método [[RecomendacionesBD.GetPopularidad()]] · `method` EXTRACTED
- tiene el método [[RecomendacionesBD.GetSenalesGustos()]] · `method` EXTRACTED
- tiene el método [[RecomendacionesBD.GuardarSegundosVista()]] · `method` EXTRACTED
- tiene el método [[RecomendacionesBD.RegistrarBusqueda()]] · `method` EXTRACTED
- tiene el método [[RecomendacionesBD.RegistrarVista()]] · `method` EXTRACTED
- tiene el método [[UsuariosBD.ActualizarContrasena()]] · `method` EXTRACTED
- tiene el método [[UsuariosBD.BorrarFotoUsuario()]] · `method` EXTRACTED
- tiene el método [[UsuariosBD.GetFotoUsuario()]] · `method` EXTRACTED
- tiene el método [[UsuariosBD.GetProvinciaById()]] · `method` EXTRACTED
- tiene el método [[UsuariosBD.GetProvincias()]] · `method` EXTRACTED
- tiene el método [[UsuariosBD.GetUsuarioById()]] · `method` EXTRACTED
- tiene el método [[UsuariosBD.GetUsuarioByMail()]] · `method` EXTRACTED
- tiene el método [[UsuariosBD.GuardarFotoUsuario()]] · `method` EXTRACTED
- tiene el método [[UsuariosBD.Register()]] · `method` EXTRACTED
- tiene el método [[UsuariosBD.UpdateUsuario()]] · `method` EXTRACTED
- tiene el método [[UsuariosBD.UsuarioExiste()]] · `method` EXTRACTED
