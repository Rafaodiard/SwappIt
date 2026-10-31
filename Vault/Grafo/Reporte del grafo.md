---
tipo: reporte
tags:
  - tipo/reporte
---
> Informe generado por graphify 0.9.95 (con el complemento de SQL) sobre el código de `main` (f639baa) más el rediseño del inicio sin commitear, el 30/10. Está en inglés porque lo escribe graphify. Las comunidades tienen su nota en `Grafo/Comunidades` (los nombres en español se los pusimos a mano). Abrí `Grafo/graph.html` en el navegador para el grafo interactivo.

# Graph Report - Swappit  (2026-10-30)

## Corpus Check
- cluster-only mode — file stats not available

## Summary
- 492 nodes · 1119 edges · 31 communities (21 shown, 10 thin omitted)
- Extraction: 96% EXTRACTED · 4% INFERRED · 0% AMBIGUOUS · INFERRED: 44 edges (avg confidence: 0.91)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `f639baa` (+ uncommitted home page redesign)
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- Controllers, vistas y JS
- Tablas y acceso a datos
- Namespaces y formularios
- Publicar artículo
- SQLSwappit.sql y SPs nuevos
- Usuarios, contraseñas y sesión
- Intercambios del usuario
- Configuración de arranque
- Script portable
- SPs originales
- Modelo Articulos
- Editar perfil
- Card de artículo
- Proyecto y paquetes NuGet
- Modelo Intercambios
- Migración de estados
- Modelo Mensajes
- JS de notificaciones
- Notificaciones
- Resumen del chat
- Script de notificaciones
- Categorías
- Registro

## God Nodes (most connected - your core abstractions)
1. `BD` - 43 edges
2. `dbo.Intercambios` - 25 edges
3. `Usuarios` - 24 edges
4. `Swappit.Models` - 24 edges
5. `IntercambioViewModel` - 23 edges
6. `Swappit.Models.ViewModels` - 22 edges
7. `dbo.EstadosIntercambios` - 17 edges
8. `dbo.Usuarios` - 17 edges
9. `dbo.Articulos` - 16 edges
10. `dbo.Usuarios` - 16 edges

## Surprising Connections (you probably didn't know these)
- `Articulos` --maps_to--> `dbo.Articulos`  [INFERRED]
  Models/Articulos.cs → BaseDatos/Estructura.sql
- `Intercambios` --maps_to--> `dbo.Intercambios`  [INFERRED]
  Models/Intercambios.cs → BaseDatos/Estructura.sql
- `Provincias` --maps_to--> `dbo.Provincias`  [INFERRED]
  Models/Provincia.cs → BaseDatos/Estructura.sql
- `TipoNotificaciones` --maps_to--> `dbo.TipoNotificaciones`  [INFERRED]
  Models/TipoNotificaciones.cs → BaseDatos/Estructura.sql
- `Mensajes` --maps_to--> `dbo.Mensajes`  [INFERRED]
  Models/Mensajes.cs → BaseDatos/Estructura.sql

## Import Cycles
- None detected.

## Communities (31 total, 10 thin omitted)

### Community 0 - "Controllers, vistas y JS"
Cohesion: 0.07
Nodes (9): AccountController, ArticulosController, ChatController, HomeController, IntercambioController, NotificacionesController, PerfilController, IntercambioViewModel (+1 more)

### Community 1 - "Tablas y acceso a datos"
Cohesion: 0.10
Nodes (17): dbo.Articulos, dbo.EstadosArticulos, dbo.EstadosIntercambios, dbo.Imagenes, dbo.Intercambios, dbo.Mensajes, dbo.Notificaciones, dbo.Provincias (+9 more)

### Community 2 - "Namespaces y formularios"
Cohesion: 0.07
Nodes (22): Swappit.Models.ViewModels, Swappit.Controllers, Swappit.Models, Provincias, IdProvincia, Nombre, Telefonos, TipoNotificaciones (+14 more)

### Community 3 - "Publicar artículo"
Cohesion: 0.11
Nodes (16): PublicarController, Microsoft.AspNetCore.Mvc.Rendering, PublicarArticuloViewModel, ACambio, Descripcion, Fotos, IdCategorias, IdEstado (+8 more)

### Community 4 - "SQLSwappit.sql y SPs nuevos"
Cohesion: 0.13
Nodes (35): dbo.ActualizarContrasena(), dbo.Articulos, dbo.BorrarFotoUsuario(), dbo.Categorias, dbo.EstadosArticulos, dbo.EstadosIntercambios, dbo.GetArticuloById(), dbo.GetArticulosCatalogo() (+27 more)

### Community 5 - "Usuarios, contraseñas y sesión"
Cohesion: 0.09
Nodes (15): Contrasenas, SesionUsuario, Usuarios, Apellido, Barrio, Contraseña, Descripcion, Edad (+7 more)

### Community 6 - "Intercambios del usuario"
Cohesion: 0.10
Nodes (19): IntercambioViewModel, EsRecibido, Estado, Fecha, IdIntercambios, MiArticuloEstado, MiArticuloId, MiArticuloImagen (+11 more)

### Community 7 - "Configuración de arranque"
Cohesion: 0.13
Nodes (15): ASPNETCORE_ENVIRONMENT, applicationUrl, commandName, dotnetRunMessages, environmentVariables, launchBrowser, applicationUrl, commandName (+7 more)

### Community 8 - "Script portable"
Cohesion: 0.13
Nodes (35): dbo.ActualizarContrasena(), dbo.Articulos, dbo.BorrarFotoUsuario(), dbo.Categorias, dbo.EstadosArticulos, dbo.EstadosIntercambios, dbo.GetArticuloById(), dbo.GetArticulosCatalogo() (+27 more)

### Community 9 - "SPs originales"
Cohesion: 0.11
Nodes (24): dbo.ActualizarContrasena(), dbo.BorrarFotoUsuario(), dbo.GetArticuloById(), dbo.GetArticulosCatalogo(), dbo.GetCategoriaById(), dbo.GetCategorias(), dbo.GetEstadoArticuloById(), dbo.GetEstadosArticulos() (+16 more)

### Community 10 - "Modelo Articulos"
Cohesion: 0.18
Nodes (9): Articulos, ACambio, Descripcion, IdArticulos, IdCategorias, IdEstado, IdUsuarios, Nombre (+1 more)

### Community 11 - "Editar perfil"
Cohesion: 0.20
Nodes (10): EditarPerfilViewModel, Apellido, Barrio, Descripcion, Foto, IdProvincias, Nombre, QuitarFoto (+2 more)

### Community 12 - "Card de artículo"
Cohesion: 0.29
Nodes (6): ArticuloCardViewModel, Barrio, Estado, IdArticulos, Imagen, Nombre

### Community 13 - "Proyecto y paquetes NuGet"
Cohesion: 0.33
Nodes (5): net9.0, Dapper (2.1.89), Microsoft.AspNetCore.Session (2.3.13), Microsoft.Data.SqlClient (7.1.1), Microsoft.NET.Sdk.Web

### Community 14 - "Modelo Intercambios"
Cohesion: 0.22
Nodes (8): Intercambios, Fecha, IdArticulos1, IdArticulos2, IdEstado, IdIntercambios, IdUsuarios1, IdUsuarios2

### Community 21 - "Modelo Mensajes"
Cohesion: 0.22
Nodes (8): Mensajes, FechaEnviado, FechaRecibido, fueVisto, IdIntercambio, IdMensajes, IdUsuariosManda, Texto

### Community 22 - "JS de notificaciones"
Cohesion: 0.70
Nodes (4): abrir(), cargarCantidad(), cargarLista(), mostrarCantidad()

### Community 23 - "Notificaciones"
Cohesion: 0.22
Nodes (8): NotificacionViewModel, ArticuloNombre, Fecha, Id, IdIntercambio, Leida, OtroNombre, Tipo

### Community 24 - "Resumen del chat"
Cohesion: 0.25
Nodes (6): ConversacionViewModel, IdIntercambio, NoLeidos, UltimaFecha, UltimoEsMio, UltimoTexto

### Community 26 - "Categorías"
Cohesion: 0.38
Nodes (4): dbo.Categorias, Categorias, IdCategorias, Nombre

### Community 29 - "Registro"
Cohesion: 0.29
Nodes (7): RegistroViewModel, Apellido, Contrasena, FechaNacimiento, Mail, Nombre, Telefono

## Knowledge Gaps
- **116 isolated node(s):** `IntercambioViewModel`, `IdEstadosArticulos`, `Nombre`, `IdEstadosIntercambios`, `Nombre` (+111 more)
  These have ≤1 connection - possible missing edges. (Counts symbols only; 158 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **10 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `BD` connect `Tablas y acceso a datos` to `Controllers, vistas y JS`, `Namespaces y formularios`, `Usuarios, contraseñas y sesión`, `Modelo Articulos`, `Categorías`?**
  _High betweenness centrality (0.088) - this node is a cross-community bridge._
- **Are the 3 inferred relationships involving `Usuarios` (e.g. with `.Registro()` and `.Publico()`) actually correct?**
  _`Usuarios` has 3 INFERRED edges - model-reasoned connections that need verification._
- **What connects `IntercambioViewModel`, `IdEstadosArticulos`, `Nombre` to the rest of the system?**
  _116 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Controllers, vistas y JS` be split into smaller, more focused modules?**
  _Cohesion score 0.07199529826623567 - nodes in this community are weakly interconnected._
- **Why does `IntercambioViewModel` connect `Intercambios del usuario` to `Resumen del chat`, `Tablas y acceso a datos`?**
  _High betweenness centrality (0.060) - this node is a cross-community bridge._
- **Should `Tablas y acceso a datos` be split into smaller, more focused modules?**
  _Cohesion score 0.09994155464640561 - nodes in this community are weakly interconnected._
- **Why does `Swappit.Models.ViewModels` connect `Namespaces y formularios` to `Controllers, vistas y JS`, `Publicar artículo`, `Intercambios del usuario`, `Card de artículo`, `Notificaciones`, `Resumen del chat`?**
  _High betweenness centrality (0.059) - this node is a cross-community bridge._