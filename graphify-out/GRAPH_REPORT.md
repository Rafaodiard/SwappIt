# Graph Report - swappit  (2026-10-25)

## Corpus Check
- Corpus is ~18,427 words - fits in a single context window. You may not need a graph.

## Summary
- 287 nodes · 424 edges · 35 communities (18 shown, 17 thin omitted)
- Extraction: 95% EXTRACTED · 4% INFERRED · 1% AMBIGUOUS · INFERRED: 16 edges (avg confidence: 0.79)
- Token cost: 337,010 input · 0 output

## Community Hubs (Navigation)
- Acciones de los controladores
- Dependencias e imports
- Intercambios, mensajes y registro
- Acceso a datos y catálogo
- Formularios de perfil y publicar
- Modelos de dominio
- Configuración de arranque
- Script SQL original
- Script SQL portable
- Stored procedures
- Foto 3: living
- Estructura de tablas
- Foto 1: mudanza
- Logo e identidad visual
- Proyecto y paquetes NuGet
- Foto 2: lámpara por libros
- Foto 4: desempacando
- JS de publicar
- JS general

## God Nodes (most connected - your core abstractions)
1. `Usuarios` - 20 edges
2. `AccountController` - 18 edges
3. `BD` - 17 edges
4. `PublicarArticuloViewModel` - 12 edges
5. `HomeController` - 11 edges
6. `Swappit.Models.ViewModels` - 11 edges
7. `EditarPerfilViewModel` - 11 edges
8. `Swappit.Models` - 10 edges
9. `Intercambios` - 9 edges
10. `Mensajes` - 9 edges

## Surprising Connections (you probably didn't know these)
- `Usuarios` --references--> `DateTime`  [EXTRACTED]
  Models/Usuarios.cs →   _Bridges community 0 → community 2_
- `PublicarArticuloViewModel` --references--> `List`  [EXTRACTED]
  Models/ViewModels/PublicarArticuloViewModel.cs →   _Bridges community 4 → community 3_

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Scene elements expressing decluttering / passing on belongings** — wwwroot_img_foto1_packing_books_scene, wwwroot_img_foto1_framed_picture_carrier, wwwroot_img_foto1_household_objects, wwwroot_img_foto1_decluttering_theme [INFERRED 0.85]
- **Lamp traded for books: two offered items in one swap** — wwwroot_img_foto2_lamp_for_books_exchange, wwwroot_img_foto2_mushroom_lamp, wwwroot_img_foto2_book_stack [EXTRACTED 1.00]
- **Second-hand furniture items depicted in foto3** — wwwroot_img_foto3_rattan_armchair, wwwroot_img_foto3_sofa, wwwroot_img_foto3_coffee_table, wwwroot_img_foto3_bookshelf [INFERRED 0.85]
- **Swappable used goods depicted in foto4** — wwwroot_img_foto4_table_lamp, wwwroot_img_foto4_household_objects, wwwroot_img_foto4_object_exchange_theme [INFERRED 0.65]
- **Two-tone color split shared by mark (top/bottom arrow) and wordmark (SWAPP/IT)** — wwwroot_img_logo_s_swap_arrows_mark, wwwroot_img_logo_swappit_wordmark, wwwroot_img_logo_petrol_blue_034454, wwwroot_img_logo_burgundy_840c26 [EXTRACTED 1.00]

## Communities (35 total, 17 thin omitted)

### Community 0 - "Acciones de los controladores"
Cohesion: 0.07
Nodes (17): AccountController, HomeController, Usuarios, Apellido, Barrio, Contraseña, Edad, FechaNacimiento (+9 more)

### Community 1 - "Dependencias e imports"
Cohesion: 0.09
Nodes (12): Swappit.Models.ViewModels, Swappit.Controllers, Microsoft.AspNetCore.Mvc.Rendering, ArticuloCardViewModel, Barrio, Estado, IdArticulos, Imagen (+4 more)

### Community 2 - "Intercambios, mensajes y registro"
Cohesion: 0.08
Nodes (23): Intercambios, Fecha, fueRealizado, IdArticulos1, IdArticulos2, IdIntercambios, IdUsuarios1, IdUsuarios2 (+15 more)

### Community 3 - "Acceso a datos y catálogo"
Cohesion: 0.14
Nodes (8): BD, Provincias, IdProvincia, Nombre, OpcionFiltroViewModel, Cantidad, Texto, Valor

### Community 4 - "Formularios de perfil y publicar"
Cohesion: 0.11
Nodes (17): EditarPerfilViewModel, Apellido, Barrio, Foto, IdProvincias, Nombre, QuitarFoto, Telefono (+9 more)

### Community 5 - "Modelos de dominio"
Cohesion: 0.11
Nodes (12): Swappit.Models, Articulos, Descripcion, Estado, IdArticulos, IdCategorias, IdUsuarios, Nombre (+4 more)

### Community 6 - "Configuración de arranque"
Cohesion: 0.13
Nodes (15): ASPNETCORE_ENVIRONMENT, applicationUrl, commandName, dotnetRunMessages, environmentVariables, launchBrowser, applicationUrl, commandName (+7 more)

### Community 7 - "Script SQL original"
Cohesion: 0.42
Nodes (11): dbo.Articulos, dbo.Categorias, dbo.Imagenes, dbo.Intercambios, dbo.Mensajes, dbo.Provincias, dbo.RegistrarArticulo(), dbo.RegistrarIntercambio() (+3 more)

### Community 8 - "Script SQL portable"
Cohesion: 0.42
Nodes (11): dbo.Articulos, dbo.Categorias, dbo.Imagenes, dbo.Intercambios, dbo.Mensajes, dbo.Provincias, dbo.RegistrarArticulo(), dbo.RegistrarIntercambio() (+3 more)

### Community 9 - "Stored procedures"
Cohesion: 0.31
Nodes (4): dbo.RegistrarArticulo(), dbo.RegistrarIntercambio(), dbo.RegistrarMensaje(), dbo.RegistrarUsuario()

### Community 10 - "Foto 3: living"
Cohesion: 0.22
Nodes (8): Low White Bookshelf with Books and Toys, Round Wooden Coffee Table, Used Furniture and Home Decor (swappable goods theme), Bright Lived-In Living Room Scene (warm neutral palette, natural light), Potted Monstera Plant, foto3.jpg - Cozy Living Room Interior Photo, Rattan Armchair with Sheepskin Throw, Beige Sofa with Mustard Throw Pillows

### Community 11 - "Estructura de tablas"
Cohesion: 0.50
Nodes (7): dbo.Articulos, dbo.Categorias, dbo.Imagenes, dbo.Intercambios, dbo.Mensajes, dbo.Provincias, dbo.Usuarios

### Community 12 - "Foto 1: mudanza"
Cohesion: 0.39
Nodes (8): Decluttering / Moving Home Theme, Man Carrying Framed Picture, Used Household Objects (books, mugs, lamps, rug, chair, framed art), Moneyless Swapping of Used Objects (Swappit core idea), Woman Packing Books into Cardboard Box, foto1.png - Home Decluttering / Moving Lifestyle Photo, Probable Use as Landing/Hero or Item-Card Image, Warm Natural-Light Photographic Style

### Community 13 - "Logo e identidad visual"
Cohesion: 0.48
Nodes (7): Swappit Stated Brand Palette (#0d596a, #a5babe, #6e2c3a, #ece6d8), Logo Burgundy #840c26, Swappit Logo (horizontal lockup, transparent PNG 2967x1222), Logo Petrol Blue #034454, S-shaped Swap Arrows Mark (two curved arrows: petrol top, burgundy bottom), SWAPPIT Wordmark (bold sans caps, SWAPP petrol + IT burgundy), Two-way Exchange / Circular Reuse Concept

### Community 14 - "Proyecto y paquetes NuGet"
Cohesion: 0.33
Nodes (5): net9.0, Dapper (2.1.89), Microsoft.AspNetCore.Session (2.3.13), Microsoft.Data.SqlClient (7.1.1), Microsoft.NET.Sdk.Web

### Community 15 - "Foto 2: lámpara por libros"
Cohesion: 0.40
Nodes (6): Stack of Hardcover Books (Offered Item), Lamp-for-Books Hand-to-Hand Exchange Scene, Moneyless Peer-to-Peer Swap of Used Objects, Sunlit City Apartment with Moving Boxes, White Mushroom Table Lamp (Offered Item), foto2.png - Item Swap Photo

### Community 16 - "Foto 4: desempacando"
Cohesion: 0.60
Nodes (5): Pre-owned Household Objects (straw hat, acoustic guitar, floral cushions, plant), Marketing Imagery Theme: Sharing / Exchanging Used Objects, foto4.jpg - Two people unpacking household items from a box, White Table Lamp with Wooden Tripod Base, Lifestyle Scene: Friends Unpacking a Cardboard Box at Home

### Community 17 - "JS de publicar"
Cohesion: 0.80
Nodes (4): actualizar(), agregar(), dibujarMiniaturas(), quitar()

## Ambiguous Edges - Review These
- `foto1.png - Home Decluttering / Moving Lifestyle Photo` → `Probable Use as Landing/Hero or Item-Card Image`  [AMBIGUOUS]
  wwwroot/img/foto1.png · relation: conceptually_related_to
- `foto3.jpg - Cozy Living Room Interior Photo` → `Sample Imagery for Item Cards or Landing Page`  [AMBIGUOUS]
  wwwroot/img/foto3.jpg · relation: rationale_for
- `foto4.jpg - Two people unpacking household items from a box` → `Marketing Imagery Theme: Sharing / Exchanging Used Objects`  [AMBIGUOUS]
  wwwroot/img/foto4.jpg · relation: rationale_for
- `Logo Petrol Blue #034454` → `Swappit Stated Brand Palette (#0d596a, #a5babe, #6e2c3a, #ece6d8)`  [AMBIGUOUS]
  wwwroot/img/logo.png · relation: conceptually_related_to
- `Logo Burgundy #840c26` → `Swappit Stated Brand Palette (#0d596a, #a5babe, #6e2c3a, #ece6d8)`  [AMBIGUOUS]
  wwwroot/img/logo.png · relation: conceptually_related_to

## Knowledge Gaps
- **84 isolated node(s):** `IdArticulos`, `Nombre`, `Descripcion`, `Estado`, `IdUsuarios` (+79 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 124 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **17 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Swappit.Models` connect `Modelos de dominio` to `Dependencias e imports`, `Acceso a datos y catálogo`?**
  _High betweenness centrality (0.070) - this node is a cross-community bridge._
- **What connects `IdArticulos`, `Nombre`, `Descripcion` to the rest of the system?**
  _84 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Acciones de los controladores` be split into smaller, more focused modules?**
  _Cohesion score 0.0700354609929078 - nodes in this community are weakly interconnected._
- **Why does `Usuarios` connect `Acciones de los controladores` to `Intercambios, mensajes y registro`, `Acceso a datos y catálogo`, `Modelos de dominio`?**
  _High betweenness centrality (0.064) - this node is a cross-community bridge._
- **Should `Dependencias e imports` be split into smaller, more focused modules?**
  _Cohesion score 0.09401709401709402 - nodes in this community are weakly interconnected._

### Low-confidence Hints
_AMBIGUOUS edges — the extractor was unsure. Verify before acting on these._

- **What is the exact relationship between `foto1.png - Home Decluttering / Moving Lifestyle Photo` and `Probable Use as Landing/Hero or Item-Card Image`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **What is the exact relationship between `foto3.jpg - Cozy Living Room Interior Photo` and `Sample Imagery for Item Cards or Landing Page`?**
  _Edge tagged AMBIGUOUS (relation: rationale_for) - confidence is low._