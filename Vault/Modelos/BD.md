---
tipo: modelo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD.cs"
graphify_ids:
  - "models_bd_swappit_models_bd"
  - "models_bd"
tags:
  - tipo/modelo
  - comunidad/Tablas_y_acceso_a_datos
---
# BD (acceso a datos)

`Models/BD.cs` · Clase **estática** con todas las consultas a SQL Server, usando **Dapper**. Cada método abre y cierra su propia `SqlConnection`. El SQL está escrito en el código (no llama a stored procedures).

Connection string fija: `Server=localhost; DataBase=Base_De_Datos_Swappit; Integrated Security=True; TrustServerCertificate=True;` (comentada, la versión `.\SQLEXPRESS`).

## Métodos
| Método | Tabla(s) | Lo usa |
|---|---|---|
| `GetUsuarioByMail(mail)` | [[Tabla Usuarios]] | Login, Registro |
| `GetUsuarioById(id)` | Usuarios | Perfil, Detalle, Publicar, CambiarContrasena |
| `UsuarioExiste(mail)` | Usuarios | Registro |
| `Register(u)` | INSERT Usuarios | Registro |
| `UpdateUsuario(u)` | UPDATE Usuarios (todas las columnas) | Editar perfil |
| `ActualizarContrasena(id, hash)` | UPDATE Usuarios | Login (re-hash), CambiarContrasena |
| `GetProvinciaById` / `GetProvincias` | [[Tabla Provincias]] | Perfil, Detalle |
| `GetFotoUsuario(id)` | [[Tabla Imagenes]] (IdArticulos NULL, la más nueva) | Perfil, Detalle, [[SesionUsuario]] |
| `GuardarFotoUsuario` / `BorrarFotoUsuario` | Imagenes | Editar perfil |
| `GetArticulosCatalogo(busqueda, cantidad, categorias, estados, idUsuario)` | [[Tabla Articulos]] + Usuarios + [[Tabla EstadosArticulos]] + Imagenes | Home, Buscar, Detalle, Perfil |
| `GetArticuloById(id)` | Articulos | Detalle |
| `PublicarArticulo(a, rutasFotos)` | INSERT Articulos + Imagenes en **transacción**; devuelve el id nuevo (`OUTPUT INSERTED`) | Publicar |
| `GetImagenesArticulo(id)` | Imagenes | Detalle |
| `GetCategoriaById` / `GetCategorias` | [[Tabla Categorias]] | Detalle, Publicar |
| `GetEstadosArticulos` / `GetEstadoArticuloById` | EstadosArticulos | Publicar, Detalle |
| `GetFiltroCategorias(busqueda)` / `GetFiltroEstados(busqueda)` | Categorias / EstadosArticulos con `LEFT JOIN` y `COUNT` | Buscar |
| `ArticuloComprometido(id)` | [[Tabla Intercambios]] + [[Tabla EstadosIntercambios]] | Proponer, Ver intercambio |
| `GetIntercambios(idUsuario, cantidad)` / `GetIntercambio(id, idUsuario)` | Intercambios + Articulos + Usuarios + estados + Imagenes, como [[IntercambioViewModel]] | Mis intercambios, Ver intercambio, Chat, Perfil, Inicio |
| `GetIdPropuestaEnCurso(idUsuario, idArticulo)` | Intercambios | Detalle de artículo ("Propuesta enviada") |
| `ProponerIntercambio(...)` | INSERT Intercambios (Pendiente) + notificación, en **transacción** | Proponer |
| `CambiarEstadoIntercambio(...)` | UPDATE Intercambios + notificación; al aceptar rechaza las otras pendientes (`RechazarPendientesDeArticulos`, privado) | Aceptar, Rechazar, Marcar realizado |
| `CancelarIntercambio(id, idUsuario)` | UPDATE Intercambios a Cancelado + notificación | Cancelar |
| `ContarPendientesDeArticulos(id)` | Intercambios | Ver intercambio, Aceptar (aviso de cuántas se rechazan solas) |
| `GetEstadosIntercambios()` | EstadosIntercambios | Filtros de Mis intercambios |
| `CrearNotificacion(...)` (privado) | INSERT [[Tabla Notificaciones]] (busca el tipo por nombre en [[Tabla TipoNotificaciones]]) | Dentro de las transacciones de intercambios y chat |
| `GetNotificaciones` / `GetCantidadNotificacionesNoLeidas` | Notificaciones + TipoNotificaciones + Intercambios | Pop up y contador de la campana |
| `MarcarNotificacionLeida` / `MarcarNotificacionesLeidas` | UPDATE Notificaciones | Ver notificación, Marcar todas |
| `GetResumenesChat(idUsuario)` | [[Tabla Mensajes]] | Lista del chat, mensajes sin leer del inicio |
| `GetMensajes(idIntercambio, idUsuario)` | Mensajes | Chat |
| `EnviarMensaje(...)` | INSERT Mensajes + notificación "Mensaje nuevo", en **transacción** | Chat |
| `MarcarMensajesVistos(...)` | UPDATE Mensajes y Notificaciones | Chat |
| `PatronBusqueda` / `EscaparLike` | — | Escapan `[`, `%` y `_` del texto buscado |

## Detalles
- `SelectUsuarios`: constante con el SELECT de usuarios; renombra `[Fecha nacimiento]` a `FechaNacimiento` para que Dapper llene [[Usuarios]].
- `GetArticulosCatalogo` arma el `WHERE` según los filtros que vengan y siempre ordena `IdArticulos DESC`. El campo `Barrio` de la card es `COALESCE(NULLIF(a.Ubicacion,''), u.Barrio)`.
- Las fotos de perfil y de artículo están en la misma tabla: las de perfil tienen `IdUsuarios` y `IdArticulos` NULL; las de artículo, `IdArticulos`.
- Los métodos de usuarios, artículos, categorías y filtros tienen un SP con el mismo nombre en [[Script SQLSwappit.sql]], pero no se usa (ver [[Pendientes y problemas]]). Los de intercambios, notificaciones y chat (29/10) no tienen SP.
- Un artículo con un intercambio Aceptado o Realizado está **comprometido** (constante `ArticuloDisponible`): no aparece en el catálogo, los filtros, los perfiles ni el inicio, y no se puede pedir ni ofrecer. No se le cambia nada al artículo: se calcula desde Intercambios.
- Las consultas de chat chequean que el usuario sea parte del intercambio (`ParteDelIntercambio`).

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Models]] · `contains` EXTRACTED
- importa [[Dapper]] · `imports` EXTRACTED
- importa [[Microsoft.Data.SqlClient]] · `imports` EXTRACTED
- importa [[Namespace Swappit.Models.ViewModels]] · `imports` EXTRACTED
- tiene el método [[BD.ActualizarContrasena()]] · `method` EXTRACTED
- tiene el método [[BD.ArticuloComprometido()]] · `method` EXTRACTED
- tiene el método [[BD.BorrarFotoUsuario()]] · `method` EXTRACTED
- tiene el método [[BD.CambiarEstadoIntercambio()]] · `method` EXTRACTED
- tiene el método [[BD.CancelarIntercambio()]] · `method` EXTRACTED
- tiene el método [[BD.ContarPendientesDeArticulos()]] · `method` EXTRACTED
- tiene el método [[BD.CrearNotificacion()]] · `method` EXTRACTED
- tiene el método [[BD.EnviarMensaje()]] · `method` EXTRACTED
- tiene el método [[BD.EscaparLike()]] · `method` EXTRACTED
- tiene el método [[BD.GetArticuloById()]] · `method` EXTRACTED
- tiene el método [[BD.GetArticulosCatalogo()]] · `method` EXTRACTED
- tiene el método [[BD.GetCantidadNotificacionesNoLeidas()]] · `method` EXTRACTED
- tiene el método [[BD.GetCategoriaById()]] · `method` EXTRACTED
- tiene el método [[BD.GetCategorias()]] · `method` EXTRACTED
- tiene el método [[BD.GetEstadoArticuloById()]] · `method` EXTRACTED
- tiene el método [[BD.GetEstadosArticulos()]] · `method` EXTRACTED
- tiene el método [[BD.GetEstadosIntercambios()]] · `method` EXTRACTED
- tiene el método [[BD.GetFiltroCategorias()]] · `method` EXTRACTED
- tiene el método [[BD.GetFiltroEstados()]] · `method` EXTRACTED
- tiene el método [[BD.GetFotoUsuario()]] · `method` EXTRACTED
- tiene el método [[BD.GetIdPropuestaEnCurso()]] · `method` EXTRACTED
- tiene el método [[BD.GetImagenesArticulo()]] · `method` EXTRACTED
- tiene el método [[BD.GetIntercambio()]] · `method` EXTRACTED
- tiene el método [[BD.GetIntercambios()]] · `method` EXTRACTED
- tiene el método [[BD.GetMensajes()]] · `method` EXTRACTED
- tiene el método [[BD.GetNotificaciones()]] · `method` EXTRACTED
- tiene el método [[BD.GetProvinciaById()]] · `method` EXTRACTED
- tiene el método [[BD.GetProvincias()]] · `method` EXTRACTED
- tiene el método [[BD.GetResumenesChat()]] · `method` EXTRACTED
- tiene el método [[BD.GetUsuarioById()]] · `method` EXTRACTED
- tiene el método [[BD.GetUsuarioByMail()]] · `method` EXTRACTED
- tiene el método [[BD.GuardarFotoUsuario()]] · `method` EXTRACTED
- tiene el método [[BD.MarcarMensajesVistos()]] · `method` EXTRACTED
- tiene el método [[BD.MarcarNotificacionesLeidas()]] · `method` EXTRACTED
- tiene el método [[BD.MarcarNotificacionLeida()]] · `method` EXTRACTED
- tiene el método [[BD.PatronBusqueda()]] · `method` EXTRACTED
- tiene el método [[BD.ProponerIntercambio()]] · `method` EXTRACTED
- tiene el método [[BD.PublicarArticulo()]] · `method` EXTRACTED
- tiene el método [[BD.RechazarPendientesDeArticulos()]] · `method` EXTRACTED
- tiene el método [[BD.Register()]] · `method` EXTRACTED
- tiene el método [[BD.UpdateUsuario()]] · `method` EXTRACTED
- tiene el método [[BD.UsuarioExiste()]] · `method` EXTRACTED
