---
tipo: reporte
tags:
  - tipo/reporte
---
> Informe generado por graphify 0.9.95 sobre el código de `main` (cc3a330). Está en inglés porque lo escribe graphify. Las comunidades tienen su nota en `Grafo/Comunidades`. Abrí `Grafo/graph.html` en el navegador para el grafo interactivo.

# Graph Report - Swappit  (2026-10-28)

## Corpus Check
- Corpus is ~27,956 words - fits in a single context window. You may not need a graph.

## Summary
- 343 nodes · 683 edges · 21 communities (15 shown, 6 thin omitted)
- Extraction: 94% EXTRACTED · 6% INFERRED · 0% AMBIGUOUS · INFERRED: 43 edges (avg confidence: 0.91)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- Controllers, vistas y JS
- Tablas y acceso a datos
- Namespaces y formularios
- Publicar artículo
- SQLSwappit.sql y SPs nuevos
- Usuarios, contraseñas y sesión
- Intercambios y mensajes
- Configuración de arranque
- Script portable
- SPs originales
- Modelo Articulos
- Editar perfil
- Card de artículo
- Proyecto y paquetes NuGet
- JS de publicar
- Migración de estados

## God Nodes (most connected - your core abstractions)
1. `BD` - 24 edges
2. `Usuarios` - 24 edges
3. `Swappit.Models` - 18 edges
4. `Swappit.Models.ViewModels` - 14 edges
5. `dbo.Usuarios` - 13 edges
6. `Articulos` - 13 edges
7. `dbo.Usuarios` - 13 edges
8. `dbo.Articulos` - 12 edges
9. `PublicarController` - 12 edges
10. `EditarPerfilViewModel` - 12 edges

## Surprising Connections (you probably didn't know these)
- `Articulos` --maps_to--> `dbo.Articulos`  [INFERRED]
  Models/Articulos.cs → BaseDatos/Estructura.sql
- `EstadosIntercambios` --maps_to--> `dbo.EstadosIntercambios`  [INFERRED]
  Models/EstadosIntercambios.cs → BaseDatos/Estructura.sql
- `Intercambios` --maps_to--> `dbo.Intercambios`  [INFERRED]
  Models/Intercambios.cs → BaseDatos/Estructura.sql
- `Mensajes` --maps_to--> `dbo.Mensajes`  [INFERRED]
  Models/Mensajes.cs → BaseDatos/Estructura.sql
- `Usuarios` --maps_to--> `dbo.Usuarios`  [INFERRED]
  Models/Usuarios.cs → BaseDatos/Estructura.sql

## Import Cycles
- None detected.

## Communities (21 total, 6 thin omitted)

### Community 0 - "Controllers, vistas y JS"
Cohesion: 0.08
Nodes (6): AccountController, ArticulosController, ChatController, HomeController, PerfilController, swappit

### Community 1 - "Tablas y acceso a datos"
Cohesion: 0.08
Nodes (23): dbo.Articulos, dbo.EstadosArticulos, dbo.EstadosIntercambios, dbo.Imagenes, dbo.Intercambios, dbo.Mensajes, dbo.Provincias, dbo.Usuarios (+15 more)

### Community 2 - "Namespaces y formularios"
Cohesion: 0.09
Nodes (15): Swappit.Models.ViewModels, Swappit.Controllers, Swappit.Models, Microsoft.AspNetCore.Mvc.Rendering, EstadosIntercambios, IdEstadosIntercambios, Nombre, Telefonos (+7 more)

### Community 3 - "Publicar artículo"
Cohesion: 0.11
Nodes (14): dbo.Categorias, PublicarController, Categorias, IdCategorias, Nombre, PublicarArticuloViewModel, ACambio, Descripcion (+6 more)

### Community 4 - "SQLSwappit.sql y SPs nuevos"
Cohesion: 0.16
Nodes (28): dbo.ActualizarContrasena(), dbo.Articulos, dbo.BorrarFotoUsuario(), dbo.Categorias, dbo.EstadosArticulos, dbo.EstadosIntercambios, dbo.GetArticuloById(), dbo.GetCategoriaById() (+20 more)

### Community 5 - "Usuarios, contraseñas y sesión"
Cohesion: 0.08
Nodes (15): Contrasenas, SesionUsuario, Usuarios, Apellido, Barrio, Contraseña, Descripcion, Edad (+7 more)

### Community 6 - "Intercambios y mensajes"
Cohesion: 0.08
Nodes (23): Intercambios, Fecha, IdArticulos1, IdArticulos2, IdEstado, IdIntercambios, IdUsuarios1, IdUsuarios2 (+15 more)

### Community 7 - "Configuración de arranque"
Cohesion: 0.13
Nodes (15): ASPNETCORE_ENVIRONMENT, applicationUrl, commandName, dotnetRunMessages, environmentVariables, launchBrowser, applicationUrl, commandName (+7 more)

### Community 8 - "Script portable"
Cohesion: 0.37
Nodes (13): dbo.Articulos, dbo.Categorias, dbo.EstadosArticulos, dbo.EstadosIntercambios, dbo.Imagenes, dbo.Intercambios, dbo.Mensajes, dbo.Provincias (+5 more)

### Community 9 - "SPs originales"
Cohesion: 0.24
Nodes (4): dbo.RegistrarArticulo(), dbo.RegistrarIntercambio(), dbo.RegistrarMensaje(), dbo.RegistrarUsuario()

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

### Community 14 - "JS de publicar"
Cohesion: 0.73
Nodes (5): actualizar(), agregar(), dibujarMiniaturas(), mostrarAviso(), quitar()

## Knowledge Gaps
- **82 isolated node(s):** `IdArticulos`, `Nombre`, `Descripcion`, `IdEstado`, `IdUsuarios` (+77 more)
  These have ≤1 connection - possible missing edges. (Counts symbols only; 124 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **6 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Usuarios` connect `Usuarios, contraseñas y sesión` to `Controllers, vistas y JS`, `Tablas y acceso a datos`, `Intercambios y mensajes`?**
  _High betweenness centrality (0.093) - this node is a cross-community bridge._
- **Are the 3 inferred relationships involving `Usuarios` (e.g. with `.Registro()` and `.Publico()`) actually correct?**
  _`Usuarios` has 3 INFERRED edges - model-reasoned connections that need verification._
- **What connects `IdArticulos`, `Nombre`, `Descripcion` to the rest of the system?**
  _82 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Controllers, vistas y JS` be split into smaller, more focused modules?**
  _Cohesion score 0.07924984875983061 - nodes in this community are weakly interconnected._
- **Why does `Swappit.Models` connect `Namespaces y formularios` to `Tablas y acceso a datos`, `Publicar artículo`, `Usuarios, contraseñas y sesión`, `Intercambios y mensajes`, `Modelo Articulos`?**
  _High betweenness centrality (0.077) - this node is a cross-community bridge._
- **Should `Tablas y acceso a datos` be split into smaller, more focused modules?**
  _Cohesion score 0.08478513356562137 - nodes in this community are weakly interconnected._
- **Why does `BD` connect `Tablas y acceso a datos` to `Controllers, vistas y JS`, `Namespaces y formularios`, `Publicar artículo`, `Usuarios, contraseñas y sesión`, `Modelo Articulos`?**
  _High betweenness centrality (0.067) - this node is a cross-community bridge._