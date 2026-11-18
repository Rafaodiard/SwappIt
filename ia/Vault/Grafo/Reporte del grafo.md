---
tipo: reporte
tags:
  - tipo/reporte
---
> Informe generado por graphify 0.9.95 (con el complemento de SQL) sobre el código de `main` (`6e0fb97`) más los cambios sin commit del 17/11 (`Models/BD/` y todo por stored procedures). Está en inglés porque lo escribe graphify. Las comunidades de antes del 08/11 tienen su nota en `Grafo/Comunidades` (con nombres en español); en las actualizaciones siguientes los nombres son los que pone graphify. Abrí `Grafo/graph.html` en el navegador para el grafo interactivo.

# Graph Report - Swappit  (2026-11-17)

## Corpus Check
- 102 files · ~140,653 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 3 file(s) not represented in the graph (top: .css 2, (none) 1)

## Summary
- 1066 nodes · 2881 edges · 56 communities (45 shown, 11 thin omitted)
- Extraction: 99% EXTRACTED · 1% INFERRED · 0% AMBIGUOUS · INFERRED: 34 edges (avg confidence: 0.9)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- externos
- RecomendacionesController
- IntercambioViewModel
- SQLSwappit_CualquierCompu
- Estructura
- IntercambioController
- SQLSwappit
- StoredProcedures
- Usuarios
- StoredProcedures (2)
- SmtpSettings
- SQLSwappit (2)
- SQLSwappit_CualquierCompu (2)
- Index
- HomeController
- AccountController
- StoredProcedures (3)
- IntercambiosBD
- SQLSwappit (3)
- StoredProcedures (4)
- SQLSwappit_CualquierCompu (3)
- SQLSwappit (4)
- ChatController
- SQLSwappit_CualquierCompu (4)
- StoredProcedures (5)
- launchSettings
- SQLSwappit_CualquierCompu (5)
- RecomendacionesBD
- SQLSwappit (5)
- PublicarController
- StoredProcedures (6)
- SQLSwappit (6)
- Articulos
- ArticulosBD
- SQLSwappit_CualquierCompu (6)
- NotificacionViewModel
- StoredProcedures (7)
- RegistroViewModel
- EditarPerfilViewModel
- Mensajes
- SQLSwappit_CualquierCompu (7)
- SQLSwappit (7)
- publicar
- PublicarArticuloViewModel
- EstadosArticulos
- Intercambios
- ConversacionViewModel
- Swappit
- NotificacionesBD
- notificaciones

## God Nodes (most connected - your core abstractions)
1. `dbo.Intercambios` - 62 edges
2. `dbo.Intercambios` - 62 edges
3. `dbo.Articulos` - 42 edges
4. `dbo.EstadosIntercambios` - 42 edges
5. `dbo.Articulos` - 42 edges
6. `dbo.EstadosIntercambios` - 42 edges
7. `Swappit.Models` - 41 edges
8. `dbo.ArticulosIntercambios` - 38 edges
9. `dbo.ArticulosIntercambios` - 38 edges
10. `Swappit.Models.ViewModels` - 34 edges

## Surprising Connections (you probably didn't know these)
- `Articulos` --maps_to--> `dbo.Articulos`  [INFERRED]
  Models/Articulos.cs → BaseDatos/Estructura.sql
- `EstadosArticulos` --maps_to--> `dbo.EstadosArticulos`  [INFERRED]
  Models/EstadosArticulos.cs → BaseDatos/Estructura.sql
- `Intercambios` --maps_to--> `dbo.Intercambios`  [INFERRED]
  Models/Intercambios.cs → BaseDatos/Estructura.sql
- `Mensajes` --maps_to--> `dbo.Mensajes`  [INFERRED]
  Models/Mensajes.cs → BaseDatos/Estructura.sql
- `Provincias` --maps_to--> `dbo.Provincias`  [INFERRED]
  Models/Provincia.cs → BaseDatos/Estructura.sql

## Import Cycles
- None detected.

## Communities (56 total, 11 thin omitted)

### Community 0 - "externos"
Cohesion: 0.06
Nodes (23): Swappit.Models.ViewModels, Swappit.Controllers, Swappit.Models, Swappit.Services, Microsoft.AspNetCore.Mvc.Rendering, ConexionBD, CantidadPorEstado, Cantidad (+15 more)

### Community 1 - "RecomendacionesController"
Cohesion: 0.06
Nodes (27): ArticuloPuntuado, Articulo, CoincideBusqueda, Gusto, InteresDelOtro, PideLoQueTenes, Popularidad, Puntaje (+19 more)

### Community 2 - "IntercambioViewModel"
Cohesion: 0.05
Nodes (39): ContextoCambio, CambioIntercambioViewModel, ArticuloEstado, ArticuloImagen, ArticuloNombre, EsPendiente, Estado, Fecha (+31 more)

### Community 3 - "SQLSwappit_CualquierCompu"
Cohesion: 0.07
Nodes (30): Creadas, dbo.ActualizarContrasena(), dbo.Categorias, dbo.Complejos_EstadisticasUsuario(), dbo.Complejos_RecomendarUsuariosIntercambio(), dbo.Complejos_RendimientoPlataformaPorPeriodo(), dbo.GetCategoriaById(), dbo.GetCategoriaById]
	@id int() (+22 more)

### Community 4 - "Estructura"
Cohesion: 0.08
Nodes (33): dbo.Articulos, dbo.ArticulosIntercambios, dbo.CambiosIntercambios, dbo.Categorias, dbo.EstadosArticulos, dbo.EstadosIntercambios, dbo.Imagenes, dbo.Interacciones (+25 more)

### Community 6 - "SQLSwappit"
Cohesion: 0.09
Nodes (25): Creadas, dbo.ActualizarContrasena(), dbo.Complejos_Ejecucion(), dbo.Complejos_EstadisticasUsuario(), dbo.Complejos_Personalizado_GestionarPropuestaYNotificacion(), dbo.Complejos_RecomendarUsuariosIntercambio(), dbo.Complejos_RendimientoPlataformaPorPeriodo(), dbo.GetDatosMailNotificacion]
	@idUsuario int,
	@idIntercambio int,
	@idCambio() (+17 more)

### Community 7 - "StoredProcedures"
Cohesion: 0.08
Nodes (20): Creadas, dbo.ActualizarContrasena(), dbo.GetCategoriaById(), dbo.GetCategoriaById]
	@id int(), dbo.GetCategorias(), dbo.GetDatosMailNotificacion]
	@idUsuario int,
	@idIntercambio int,
	@idCambio(), dbo.GetFiltroCategorias(), dbo.GetUsuarioById() (+12 more)

### Community 8 - "Usuarios"
Cohesion: 0.09
Nodes (18): PerfilController, UsuariosBD, Provincias, IdProvincia, Nombre, Usuarios, Apellido, Barrio (+10 more)

### Community 9 - "StoredProcedures (2)"
Cohesion: 0.13
Nodes (31): @cantidad(), dbo.ArticuloComprometido(), dbo.ArticuloComprometido]
	@idArticulo int(), dbo.CancelarIntercambio(), dbo.ContarArticulosActivos(), dbo.ContarArticulosActivos]
	@idUsuario int(), dbo.ContarIntercambiosActivos(), dbo.ContarIntercambiosActivos]
	@idUsuario int() (+23 more)

### Community 10 - "SmtpSettings"
Cohesion: 0.07
Nodes (21): DatosMailNotificacion, CambioArticulos, CambioTipo, Mail, MisArticulos, Nombre, OtroNombre, SusArticulos (+13 more)

### Community 11 - "SQLSwappit (2)"
Cohesion: 0.14
Nodes (34): dbo.AgregarArticulos(), dbo.ArticuloComprometido(), dbo.ArticuloComprometido]
	@idArticulo int(), dbo.Articulos, dbo.ArticulosIntercambios, dbo.CambiarEstadoIntercambio(), dbo.CancelarIntercambio(), dbo.ContarArticulosActivos() (+26 more)

### Community 12 - "SQLSwappit_CualquierCompu (2)"
Cohesion: 0.14
Nodes (31): dbo.AgregarArticulos(), dbo.ArticuloComprometido(), dbo.ArticuloComprometido]
	@idArticulo int(), dbo.Articulos, dbo.ArticulosIntercambios, dbo.CancelarIntercambio(), dbo.ContarArticulosActivos(), dbo.ContarArticulosActivos]
	@idUsuario int() (+23 more)

### Community 13 - "Index"
Cohesion: 0.11
Nodes (4): NotificacionesController, RequiredAttribute, System.Reflection, swappit

### Community 14 - "HomeController"
Cohesion: 0.12
Nodes (5): ArticulosController, FavoritosController, HomeController, ArticuloCardViewModel, OpcionFiltroViewModel

### Community 15 - "AccountController"
Cohesion: 0.13
Nodes (4): AccountController, Contrasenas, SesionUsuario, Telefonos

### Community 16 - "StoredProcedures (3)"
Cohesion: 0.11
Nodes (19): dbo.BorrarFotoUsuario(), dbo.GetArticulosDeIntercambio(), dbo.GetArticulosDeIntercambio]
	@idIntercambio int,
	@idUsuario int(), dbo.GetEstadoArticuloById(), dbo.GetEstadoArticuloById]
	@id int(), dbo.GetEstadosArticulos(), dbo.GetFavoritos(), dbo.GetFavoritos]
	@idUsuario int() (+11 more)

### Community 18 - "SQLSwappit (3)"
Cohesion: 0.17
Nodes (20): datetime(), dbo.AlternarFavorito(), dbo.AlternarFavorito]
	@idUsuario int,
	@idArticulo int(), dbo.GetArticulosCatalogo(), dbo.GetFavoritos(), dbo.GetFavoritos]
	@idUsuario int(), dbo.GetIdsFavoritos(), dbo.GetIdsFavoritos]
	@idUsuario int() (+12 more)

### Community 19 - "StoredProcedures (4)"
Cohesion: 0.18
Nodes (16): dbo.AgregarArticulos(), dbo.CambiarEstadoIntercambio(), dbo.CancelarCambio(), dbo.CancelarCambio]
	@idCambio int,
	@idUsuario int(), dbo.ContarCambiosPendientes(), dbo.ContarCambiosPendientes]
	@idIntercambio int,
	@idUsuario int,
	@soloDelOtro(), dbo.CrearPedido(), dbo.GetArticuloById() (+8 more)

### Community 20 - "SQLSwappit_CualquierCompu (3)"
Cohesion: 0.17
Nodes (18): datetime(), dbo.AlternarFavorito(), dbo.AlternarFavorito]
	@idUsuario int,
	@idArticulo int(), dbo.GetFavoritos(), dbo.GetIdsFavoritos(), dbo.GetIdsFavoritos]
	@idUsuario int(), dbo.GetPopularidad(), dbo.GetSenalesGustos() (+10 more)

### Community 21 - "SQLSwappit (4)"
Cohesion: 0.14
Nodes (19): dbo.CambiosIntercambios, dbo.CancelarCambio(), dbo.CancelarCambio]
	@idCambio int,
	@idUsuario int(), dbo.ContarCambiosPendientes(), dbo.ContarCambiosPendientes]
	@idIntercambio int,
	@idUsuario int,
	@soloDelOtro(), dbo.GetCantidadNotificacionesNoLeidas(), dbo.GetCantidadNotificacionesNoLeidas]
	@idUsuario int(), dbo.GetNotificaciones() (+11 more)

### Community 22 - "ChatController"
Cohesion: 0.18
Nodes (3): ChatController, ChatBD, IntercambioViewModel

### Community 23 - "SQLSwappit_CualquierCompu (4)"
Cohesion: 0.14
Nodes (18): dbo.BorrarFotoUsuario(), dbo.EstadosArticulos, dbo.GetArticulosCatalogo(), dbo.GetArticulosDeIntercambio(), dbo.GetArticulosDeIntercambio]
	@idIntercambio int,
	@idUsuario int(), dbo.GetCambiosIntercambio]
	@idIntercambio int,
	@idUsuario int,
	@soloPendientes(), dbo.GetEstadoArticuloById(), dbo.GetEstadoArticuloById]
	@id int() (+10 more)

### Community 24 - "StoredProcedures (5)"
Cohesion: 0.20
Nodes (15): datetime(), dbo.AlternarFavorito(), dbo.AlternarFavorito]
	@idUsuario int,
	@idArticulo int(), dbo.GetArticulosCatalogo(), dbo.GetIdsFavoritos(), dbo.GetIdsFavoritos]
	@idUsuario int(), dbo.GetPopularidad(), dbo.GetSenalesGustos() (+7 more)

### Community 25 - "launchSettings"
Cohesion: 0.13
Nodes (15): ASPNETCORE_ENVIRONMENT, applicationUrl, commandName, dotnetRunMessages, environmentVariables, launchBrowser, applicationUrl, commandName (+7 more)

### Community 26 - "SQLSwappit_CualquierCompu (5)"
Cohesion: 0.22
Nodes (16): @cantidad(), dbo.Complejos_Personalizado_GestionarPropuestaYNotificacion]
    @IdIntercambio INT(), dbo.Complejos_RendimientoPlataformaPorPeriodo]
    @FechaDesde DATE,
    @FechaHasta DATE(), dbo.Complejos_SeguimientoIntercambiosPendientes(), dbo.ContarMensajesNoLeidos(), dbo.ContarMensajesNoLeidos]
	@idUsuario int(), dbo.EnviarMensaje(), dbo.GetMensajes() (+8 more)

### Community 28 - "SQLSwappit (5)"
Cohesion: 0.23
Nodes (15): @cantidad(), dbo.Complejos_Personalizado_GestionarPropuestaYNotificacion]
    @IdIntercambio INT(), dbo.Complejos_RendimientoPlataformaPorPeriodo]
    @FechaDesde DATE,
    @FechaHasta DATE(), dbo.Complejos_SeguimientoIntercambiosPendientes(), dbo.ContarMensajesNoLeidos(), dbo.ContarMensajesNoLeidos]
	@idUsuario int(), dbo.EnviarMensaje(), dbo.GetMensajes() (+7 more)

### Community 30 - "StoredProcedures (6)"
Cohesion: 0.21
Nodes (7): dbo.Complejos_EstadisticasUsuario(), dbo.Complejos_Personalizado_GestionarPropuestaYNotificacion(), dbo.Complejos_Personalizado_GestionarPropuestaYNotificacion]
    @IdIntercambio INT(), dbo.Complejos_RecomendarUsuariosIntercambio(), dbo.Complejos_RendimientoPlataformaPorPeriodo(), dbo.Complejos_RendimientoPlataformaPorPeriodo]
    @FechaDesde DATE,
    @FechaHasta DATE(), dbo.Complejos_SeguimientoIntercambiosPendientes()

### Community 31 - "SQLSwappit (6)"
Cohesion: 0.17
Nodes (13): dbo.Categorias, dbo.EstadosArticulos, dbo.GetArticulosDeIntercambio(), dbo.GetCategoriaById(), dbo.GetCategoriaById]
	@id int(), dbo.GetCategorias(), dbo.GetEstadoArticuloById(), dbo.GetEstadoArticuloById]
	@id int() (+5 more)

### Community 32 - "Articulos"
Cohesion: 0.17
Nodes (10): Articulos, Descripcion, FechaPublicacion, IdArticulos, IdCategoriaACambio, IdCategorias, IdEstado, IdUsuarios (+2 more)

### Community 33 - "ArticulosBD"
Cohesion: 0.21
Nodes (5): ArticulosBD, OpcionFiltroViewModel, Cantidad, Texto, Valor

### Community 34 - "SQLSwappit_CualquierCompu (6)"
Cohesion: 0.24
Nodes (12): dbo.Complejos_Personalizado_GestionarPropuestaYNotificacion(), dbo.CrearNotificacion(), dbo.GetCantidadNotificacionesNoLeidas(), dbo.GetCantidadNotificacionesNoLeidas]
	@idUsuario int(), dbo.GetNotificaciones(), dbo.GetNotificaciones]
	@idUsuario int,
	@cantidad int(), dbo.MarcarNotificacionesLeidas(), dbo.MarcarNotificacionLeida() (+4 more)

### Community 35 - "NotificacionViewModel"
Cohesion: 0.18
Nodes (10): NotificacionViewModel, ArticuloNombre, CambioArticulos, CambioTipo, Fecha, Id, IdIntercambio, Leida (+2 more)

### Community 36 - "StoredProcedures (7)"
Cohesion: 0.29
Nodes (8): dbo.CrearNotificacion(), dbo.GetCantidadNotificacionesNoLeidas(), dbo.GetCantidadNotificacionesNoLeidas]
	@idUsuario int(), dbo.GetNotificaciones]
	@idUsuario int,
	@cantidad int(), dbo.MarcarNotificacionesLeidas(), dbo.MarcarNotificacionLeida(), dbo.MarcarNotificacionLeida]
	@idNotificacion int,
	@idUsuario int(), @idCambio()

### Community 37 - "RegistroViewModel"
Cohesion: 0.20
Nodes (9): RegistroViewModel, Apellido, Barrio, Contrasena, FechaNacimiento, IdProvincias, Mail, Nombre (+1 more)

### Community 38 - "EditarPerfilViewModel"
Cohesion: 0.20
Nodes (10): EditarPerfilViewModel, Apellido, Barrio, Descripcion, Foto, IdProvincias, Nombre, QuitarFoto (+2 more)

### Community 39 - "Mensajes"
Cohesion: 0.22
Nodes (8): Mensajes, FechaEnviado, FechaRecibido, fueVisto, IdIntercambio, IdMensajes, IdUsuariosManda, Texto

### Community 40 - "SQLSwappit_CualquierCompu (7)"
Cohesion: 0.22
Nodes (9): dbo.CambiarEstadoIntercambio(), dbo.CambiosIntercambios, dbo.CancelarCambio(), dbo.CancelarCambio]
	@idCambio int,
	@idUsuario int(), dbo.ContarCambiosPendientes(), dbo.ContarCambiosPendientes]
	@idIntercambio int,
	@idUsuario int,
	@soloDelOtro(), dbo.GetUltimoCambio(), dbo.GetUltimoCambio]
	@idIntercambio int() (+1 more)

### Community 41 - "SQLSwappit (7)"
Cohesion: 0.22
Nodes (9): dbo.BorrarFotoUsuario(), dbo.GetArticulosDeIntercambio]
	@idIntercambio int,
	@idUsuario int(), dbo.GetFotoUsuario(), dbo.GetFotoUsuario]
	@idUsuario int(), dbo.GetImagenesArticulo(), dbo.GetImagenesArticulo]
	@idArticulo int(), dbo.GuardarFotoUsuario(), dbo.Imagenes (+1 more)

### Community 42 - "publicar"
Cohesion: 0.39
Nodes (7): swappitFavoritos, actualizar(), agregar(), dibujarMiniaturas(), marcar(), mostrarAviso(), quitar()

### Community 43 - "PublicarArticuloViewModel"
Cohesion: 0.25
Nodes (8): PublicarArticuloViewModel, Descripcion, Fotos, IdCategoriaACambio, IdCategorias, IdEstado, Titulo, Ubicacion

### Community 44 - "EstadosArticulos"
Cohesion: 0.33
Nodes (3): EstadosArticulos, IdEstadosArticulos, Nombre

### Community 45 - "Intercambios"
Cohesion: 0.29
Nodes (6): Intercambios, Fecha, IdEstado, IdIntercambios, IdUsuarios1, IdUsuarios2

### Community 46 - "ConversacionViewModel"
Cohesion: 0.29
Nodes (6): ConversacionViewModel, IdIntercambio, NoLeidos, UltimaFecha, UltimoEsMio, UltimoTexto

### Community 48 - "Swappit"
Cohesion: 0.33
Nodes (5): net9.0, Dapper (2.1.89), Microsoft.AspNetCore.Session (2.3.13), Microsoft.Data.SqlClient (7.1.1), Microsoft.NET.Sdk.Web

### Community 50 - "notificaciones"
Cohesion: 0.70
Nodes (4): abrir(), cargarCantidad(), cargarLista(), mostrarCantidad()

## Knowledge Gaps
- **186 isolated node(s):** `Articulo`, `Gusto`, `CoincideBusqueda`, `InteresDelOtro`, `PideLoQueTenes` (+181 more)
  These have ≤1 connection - possible missing edges. (Counts symbols only; 285 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **11 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `datetime()` connect `SQLSwappit (3)` to `SQLSwappit (2)`, `SQLSwappit_CualquierCompu (3)`, `SQLSwappit (5)`, `SQLSwappit`?**
  _High betweenness centrality (0.180) - this node is a cross-community bridge._
- **What connects `Articulo`, `Gusto`, `CoincideBusqueda` to the rest of the system?**
  _186 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `externos` be split into smaller, more focused modules?**
  _Cohesion score 0.05926251097453907 - nodes in this community are weakly interconnected._
- **Why does `datetime()` connect `SQLSwappit_CualquierCompu (3)` to `SQLSwappit_CualquierCompu (5)`, `SQLSwappit_CualquierCompu`, `SQLSwappit_CualquierCompu (2)`?**
  _High betweenness centrality (0.179) - this node is a cross-community bridge._
- **Should `RecomendacionesController` be split into smaller, more focused modules?**
  _Cohesion score 0.06458635703918723 - nodes in this community are weakly interconnected._
- **Why does `Swappit.Models` connect `externos` to `Articulos`, `RecomendacionesController`, `Estructura`, `Mensajes`, `Usuarios`, `SmtpSettings`, `EstadosArticulos`, `Intercambios`, `AccountController`, `ChatController`?**
  _High betweenness centrality (0.058) - this node is a cross-community bridge._
- **Should `IntercambioViewModel` be split into smaller, more focused modules?**
  _Cohesion score 0.04591836734693878 - nodes in this community are weakly interconnected._