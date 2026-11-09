---
tipo: reporte
tags:
  - tipo/reporte
---
> Informe generado por graphify 0.9.95 (con el complemento de SQL) con `graphify update` sobre el código de `main` (fc599db) más los cambios sin commit del teléfono y del feedback de prueba, el 08/11. Está en inglés porque lo escribe graphify. Las comunidades de antes del 08/11 tienen su nota en `Grafo/Comunidades` (con nombres en español); en esta actualización los nombres son los que pone graphify. Abrí `Grafo/graph.html` en el navegador para el grafo interactivo.

# Graph Report - Swappit  (2026-11-08)

## Corpus Check
- 84 files · ~107,027 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 2 file(s) not represented in the graph (top: .css 2)

## Summary
- 663 nodes · 1508 edges · 37 communities (25 shown, 12 thin omitted)
- Extraction: 97% EXTRACTED · 3% INFERRED · 0% AMBIGUOUS · INFERRED: 49 edges (avg confidence: 0.9)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `9b026e3c`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- IActionResult
- BD
- Swappit.Models
- .Index
- SQLSwappit.sql
- Usuarios
- IntercambioViewModel
- http
- SQLSwappit_CualquierCompu.sql
- StoredProcedures.sql
- EmailService
- Swappit.Models.ViewModels
- RecomendacionesController
- Swappit.csproj
- Intercambios
- RecomendacionesController.cs
- OpcionFiltroViewModel
- Provincias
- Mensajes
- notificaciones.js
- NotificacionViewModel
- ConversacionViewModel
- PopularidadArticulo
- TipoInteracciones
- TipoNotificaciones
- Buscar.cshtml
- DateTime
- publicar.js
- _ViewImports.cshtml

## God Nodes (most connected - your core abstractions)
1. `BD` - 56 edges
2. `Swappit.Models` - 32 edges
3. `RecomendacionesController` - 26 edges
4. `dbo.Intercambios` - 25 edges
5. `Usuarios` - 24 edges
6. `Swappit.Models.ViewModels` - 24 edges
7. `IntercambioViewModel` - 24 edges
8. `ArticuloCardViewModel` - 20 edges
9. `dbo.Articulos` - 18 edges
10. `dbo.Usuarios` - 18 edges

## Surprising Connections (you probably didn't know these)
- `Articulos` --maps_to--> `dbo.Articulos`  [INFERRED]
  Models/Articulos.cs → BaseDatos/Estructura.sql
- `Intercambios` --maps_to--> `dbo.Intercambios`  [INFERRED]
  Models/Intercambios.cs → BaseDatos/Estructura.sql
- `Mensajes` --maps_to--> `dbo.Mensajes`  [INFERRED]
  Models/Mensajes.cs → BaseDatos/Estructura.sql
- `TipoNotificaciones` --maps_to--> `dbo.TipoNotificaciones`  [INFERRED]
  Models/TipoNotificaciones.cs → BaseDatos/Estructura.sql
- `Usuarios` --maps_to--> `dbo.Usuarios`  [INFERRED]
  Models/Usuarios.cs → BaseDatos/Estructura.sql

## Import Cycles
- None detected.

## Communities (37 total, 12 thin omitted)

### Community 0 - "IActionResult"
Cohesion: 0.06
Nodes (12): AccountController, ArticulosController, ChatController, FavoritosController, HomeController, IntercambioController, NotificacionesController, PerfilController (+4 more)

### Community 1 - "BD"
Cohesion: 0.07
Nodes (25): dbo.Articulos, dbo.Categorias, dbo.EstadosArticulos, dbo.EstadosIntercambios, dbo.Imagenes, dbo.Interacciones, dbo.Intercambios, dbo.Mensajes (+17 more)

### Community 3 - ".Index"
Cohesion: 0.06
Nodes (29): PublicarController, Articulos, Descripcion, FechaPublicacion, IdArticulos, IdCategoriaACambio, IdCategorias, IdEstado (+21 more)

### Community 4 - "SQLSwappit.sql"
Cohesion: 0.10
Nodes (46): dbo.ActualizarContrasena(), dbo.Articulos, dbo.BorrarFotoUsuario(), dbo.Categorias, dbo.Complejos_EstadisticasUsuario(), dbo.Complejos_Personalizado_GestionarPropuestaYNotificacion(), dbo.Complejos_RecomendarUsuariosIntercambio(), dbo.Complejos_RendimientoPlataformaPorPeriodo() (+38 more)

### Community 5 - "Usuarios"
Cohesion: 0.08
Nodes (16): Contrasenas, SesionUsuario, Telefonos, Usuarios, Apellido, Barrio, Contraseña, Descripcion (+8 more)

### Community 6 - "IntercambioViewModel"
Cohesion: 0.10
Nodes (19): IntercambioViewModel, EsRecibido, Estado, Fecha, IdIntercambios, MiArticuloEstado, MiArticuloId, MiArticuloImagen (+11 more)

### Community 7 - "http"
Cohesion: 0.13
Nodes (15): ASPNETCORE_ENVIRONMENT, applicationUrl, commandName, dotnetRunMessages, environmentVariables, launchBrowser, applicationUrl, commandName (+7 more)

### Community 8 - "SQLSwappit_CualquierCompu.sql"
Cohesion: 0.10
Nodes (46): dbo.ActualizarContrasena(), dbo.Articulos, dbo.BorrarFotoUsuario(), dbo.Categorias, dbo.Complejos_EstadisticasUsuario(), dbo.Complejos_Personalizado_GestionarPropuestaYNotificacion(), dbo.Complejos_RecomendarUsuariosIntercambio(), dbo.Complejos_RendimientoPlataformaPorPeriodo() (+38 more)

### Community 9 - "StoredProcedures.sql"
Cohesion: 0.08
Nodes (32): dbo.ActualizarContrasena(), dbo.BorrarFotoUsuario(), dbo.Complejos_EstadisticasUsuario(), dbo.Complejos_Personalizado_GestionarPropuestaYNotificacion(), dbo.Complejos_RecomendarUsuariosIntercambio(), dbo.Complejos_RendimientoPlataformaPorPeriodo(), dbo.Complejos_SeguimientoIntercambiosPendientes(), dbo.GetArticuloById() (+24 more)

### Community 10 - "EmailService"
Cohesion: 0.10
Nodes (18): DatosMailNotificacion, Mail, MiArticulo, Nombre, OtroNombre, SuArticulo, EmailService, SmtpSettings (+10 more)

### Community 11 - "Swappit.Models.ViewModels"
Cohesion: 0.19
Nodes (9): Swappit.Models.ViewModels, Microsoft.AspNetCore.Mvc.Rendering, LoginViewModel, Contrasena, Mail, RequiredAttribute, System.ComponentModel.DataAnnotations, System.Reflection (+1 more)

### Community 12 - "RecomendacionesController"
Cohesion: 0.07
Nodes (26): ArticuloPuntuado, Articulo, CoincideBusqueda, Gusto, InteresDelOtro, PideLoQueTenes, Popularidad, Puntaje (+18 more)

### Community 13 - "Swappit.csproj"
Cohesion: 0.33
Nodes (5): net9.0, Dapper (2.1.89), Microsoft.AspNetCore.Session (2.3.13), Microsoft.Data.SqlClient (7.1.1), Microsoft.NET.Sdk.Web

### Community 14 - "Intercambios"
Cohesion: 0.22
Nodes (8): Intercambios, Fecha, IdArticulos1, IdArticulos2, IdEstado, IdIntercambios, IdUsuarios1, IdUsuarios2

### Community 18 - "OpcionFiltroViewModel"
Cohesion: 0.40
Nodes (4): OpcionFiltroViewModel, Cantidad, Texto, Valor

### Community 19 - "Provincias"
Cohesion: 0.50
Nodes (3): Provincias, IdProvincia, Nombre

### Community 21 - "Mensajes"
Cohesion: 0.22
Nodes (8): Mensajes, FechaEnviado, FechaRecibido, fueVisto, IdIntercambio, IdMensajes, IdUsuariosManda, Texto

### Community 22 - "notificaciones.js"
Cohesion: 0.70
Nodes (4): abrir(), cargarCantidad(), cargarLista(), mostrarCantidad()

### Community 23 - "NotificacionViewModel"
Cohesion: 0.22
Nodes (8): NotificacionViewModel, ArticuloNombre, Fecha, Id, IdIntercambio, Leida, OtroNombre, Tipo

### Community 24 - "ConversacionViewModel"
Cohesion: 0.22
Nodes (6): ConversacionViewModel, IdIntercambio, NoLeidos, UltimaFecha, UltimoEsMio, UltimoTexto

### Community 25 - "PopularidadArticulo"
Cohesion: 0.40
Nodes (4): PopularidadArticulo, Favoritos, IdArticulo, Vistas

### Community 26 - "TipoInteracciones"
Cohesion: 0.50
Nodes (3): TipoInteracciones, Id, Nombre

### Community 27 - "TipoNotificaciones"
Cohesion: 0.50
Nodes (3): TipoNotificaciones, Id, Nombre

### Community 29 - "DateTime"
Cohesion: 0.14
Nodes (9): RegistroViewModel, Apellido, Barrio, Contrasena, FechaNacimiento, IdProvincias, Mail, Nombre (+1 more)

### Community 30 - "publicar.js"
Cohesion: 0.39
Nodes (7): swappitFavoritos, actualizar(), agregar(), dibujarMiniaturas(), marcar(), mostrarAviso(), quitar()

## Knowledge Gaps
- **158 isolated node(s):** `Articulo`, `Gusto`, `CoincideBusqueda`, `InteresDelOtro`, `PideLoQueTenes` (+153 more)
  These have ≤1 connection - possible missing edges. (Counts symbols only; 217 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **12 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `BD` connect `BD` to `IActionResult`, `EmailService`, `Usuarios`, `BD.cs`?**
  _High betweenness centrality (0.101) - this node is a cross-community bridge._
- **What connects `Articulo`, `Gusto`, `CoincideBusqueda` to the rest of the system?**
  _158 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `IActionResult` be split into smaller, more focused modules?**
  _Cohesion score 0.061142217245240764 - nodes in this community are weakly interconnected._
- **Why does `Swappit.Models` connect `Swappit.Models` to `IActionResult`, `BD`, `.Index`, `_ViewImports.cshtml`, `Usuarios`, `EmailService`, `RecomendacionesController`, `Intercambios`, `RecomendacionesController.cs`, `Provincias`, `Mensajes`, `PopularidadArticulo`, `TipoInteracciones`, `TipoNotificaciones`, `BD.cs`?**
  _High betweenness centrality (0.076) - this node is a cross-community bridge._
- **Should `BD` be split into smaller, more focused modules?**
  _Cohesion score 0.0691358024691358 - nodes in this community are weakly interconnected._
- **Why does `Swappit.Models.ViewModels` connect `Swappit.Models.ViewModels` to `IActionResult`, `Swappit.Models`, `IntercambioViewModel`, `RecomendacionesController`, `RecomendacionesController.cs`, `OpcionFiltroViewModel`, `NotificacionViewModel`, `ConversacionViewModel`, `Buscar.cshtml`, `BD.cs`?**
  _High betweenness centrality (0.052) - this node is a cross-community bridge._
- **Should `.Index` be split into smaller, more focused modules?**
  _Cohesion score 0.06153846153846154 - nodes in this community are weakly interconnected._