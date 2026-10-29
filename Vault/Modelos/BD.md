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
| `PatronBusqueda` / `EscaparLike` | — | Escapan `[`, `%` y `_` del texto buscado |

## Detalles
- `SelectUsuarios`: constante con el SELECT de usuarios; renombra `[Fecha nacimiento]` a `FechaNacimiento` para que Dapper llene [[Usuarios]].
- `GetArticulosCatalogo` arma el `WHERE` según los filtros que vengan y siempre ordena `IdArticulos DESC`. El campo `Barrio` de la card es `COALESCE(NULLIF(a.Ubicacion,''), u.Barrio)`.
- Las fotos de perfil y de artículo están en la misma tabla: las de perfil tienen `IdUsuarios` y `IdArticulos` NULL; las de artículo, `IdArticulos`.
- Cada método tiene un SP con el mismo nombre en [[Script SQLSwappit.sql]], pero no se usa (ver [[Pendientes y problemas]]).

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Models]] · `contains` EXTRACTED
- importa [[Dapper]] · `imports` EXTRACTED
- importa [[Microsoft.Data.SqlClient]] · `imports` EXTRACTED
- importa [[Namespace Swappit.Models.ViewModels]] · `imports` EXTRACTED
- tiene el método [[BD.ActualizarContrasena()]] · `method` EXTRACTED
- tiene el método [[BD.BorrarFotoUsuario()]] · `method` EXTRACTED
- tiene el método [[BD.EscaparLike()]] · `method` EXTRACTED
- tiene el método [[BD.GetArticuloById()]] · `method` EXTRACTED
- tiene el método [[BD.GetArticulosCatalogo()]] · `method` EXTRACTED
- tiene el método [[BD.GetCategoriaById()]] · `method` EXTRACTED
- tiene el método [[BD.GetCategorias()]] · `method` EXTRACTED
- tiene el método [[BD.GetEstadoArticuloById()]] · `method` EXTRACTED
- tiene el método [[BD.GetEstadosArticulos()]] · `method` EXTRACTED
- tiene el método [[BD.GetFiltroCategorias()]] · `method` EXTRACTED
- tiene el método [[BD.GetFiltroEstados()]] · `method` EXTRACTED
- tiene el método [[BD.GetFotoUsuario()]] · `method` EXTRACTED
- tiene el método [[BD.GetImagenesArticulo()]] · `method` EXTRACTED
- tiene el método [[BD.GetProvinciaById()]] · `method` EXTRACTED
- tiene el método [[BD.GetProvincias()]] · `method` EXTRACTED
- tiene el método [[BD.GetUsuarioById()]] · `method` EXTRACTED
- tiene el método [[BD.GetUsuarioByMail()]] · `method` EXTRACTED
- tiene el método [[BD.GuardarFotoUsuario()]] · `method` EXTRACTED
- tiene el método [[BD.PatronBusqueda()]] · `method` EXTRACTED
- tiene el método [[BD.PublicarArticulo()]] · `method` EXTRACTED
- tiene el método [[BD.Register()]] · `method` EXTRACTED
- tiene el método [[BD.UpdateUsuario()]] · `method` EXTRACTED
- tiene el método [[BD.UsuarioExiste()]] · `method` EXTRACTED
