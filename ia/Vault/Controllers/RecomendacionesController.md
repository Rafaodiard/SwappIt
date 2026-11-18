---
tipo: controller
comunidad: "Controllers, vistas y JS"
archivos:
  - "Controllers/RecomendacionesController.cs"
graphify_ids:
  - "controllers_recomendacionescontroller_swappit_controllers_recomendacionescontroller"
  - "controllers_recomendacionescontroller"
  - "controllers_recomendacionescontroller_swappit_controllers_articulopuntuado"
  - "controllers_recomendacionescontroller_swappit_controllers_articulopuntuado_articulo"
  - "controllers_recomendacionescontroller_swappit_controllers_articulopuntuado_coincidebusqueda"
  - "controllers_recomendacionescontroller_swappit_controllers_articulopuntuado_gusto"
  - "controllers_recomendacionescontroller_swappit_controllers_articulopuntuado_interesdelotro"
  - "controllers_recomendacionescontroller_swappit_controllers_articulopuntuado_pideloquetenes"
  - "controllers_recomendacionescontroller_swappit_controllers_articulopuntuado_popularidad"
  - "controllers_recomendacionescontroller_swappit_controllers_articulopuntuado_puntaje"
  - "controllers_recomendacionescontroller_swappit_controllers_recomendacionescontroller_armargustos"
  - "controllers_recomendacionescontroller_swappit_controllers_recomendacionescontroller_busqueda"
  - "controllers_recomendacionescontroller_swappit_controllers_recomendacionescontroller_calcularpopularidad"
  - "controllers_recomendacionescontroller_swappit_controllers_recomendacionescontroller_coincideconbusqueda"
  - "controllers_recomendacionescontroller_swappit_controllers_recomendacionescontroller_compararporpuntaje"
  - "controllers_recomendacionescontroller_swappit_controllers_recomendacionescontroller_conmotivo"
  - "controllers_recomendacionescontroller_swappit_controllers_recomendacionescontroller_destacados"
  - "controllers_recomendacionescontroller_swappit_controllers_recomendacionescontroller_esdetusgustos"
  - "controllers_recomendacionescontroller_swappit_controllers_recomendacionescontroller_interesdeldueno"
  - "controllers_recomendacionescontroller_swappit_controllers_recomendacionescontroller_mezclar"
  - "controllers_recomendacionescontroller_swappit_controllers_recomendacionescontroller_normalizar"
  - "controllers_recomendacionescontroller_swappit_controllers_recomendacionescontroller_opcionesorden"
  - "controllers_recomendacionescontroller_swappit_controllers_recomendacionescontroller_ordenar"
  - "controllers_recomendacionescontroller_swappit_controllers_recomendacionescontroller_ordenvalido"
  - "controllers_recomendacionescontroller_swappit_controllers_recomendacionescontroller_palabrasbuscadas"
  - "controllers_recomendacionescontroller_swappit_controllers_recomendacionescontroller_pesosegunantiguedad"
  - "controllers_recomendacionescontroller_swappit_controllers_recomendacionescontroller_puntosseguntipo"
  - "controllers_recomendacionescontroller_swappit_controllers_recomendacionescontroller_puntuar"
  - "controllers_recomendacionescontroller_swappit_controllers_recomendacionescontroller_semilladeldia"
  - "controllers_recomendacionescontroller_swappit_controllers_recomendacionescontroller_sortear"
  - "controllers_recomendacionescontroller_swappit_controllers_recomendacionescontroller_tiempo"
  - "controllers_recomendacionescontroller_swappit_controllers_recomendacionescontroller_vista"
tags:
  - tipo/controller
  - comunidad/Controllers_vistas_y_JS
---
# RecomendacionesController

`Controllers/RecomendacionesController.cs` · El algoritmo de recomendaciones (05/11).
- `Vista(idArticulo)`, `Tiempo(idInteraccion, segundos)` y `Busqueda(texto, categorias)` (POST, los llama `recomendaciones.js`): guardan vistas, segundos y búsquedas como Interacciones ([[SP RegistrarVista]], [[SP GuardarSegundosVista]], [[SP RegistrarBusqueda]]).
- `OpcionesOrden`, `OrdenValido` y `Ordenar`: el select de orden de Explorar. Más recientes, A - Z y Más populares ya vienen ordenados de [[SP GetArticulosCatalogo]]; acá solo se calcula "Para vos".
- `Destacados(idUsuario, cantidad)`: los recomendados del inicio (sin usuario logueado, los más populares).
- "Para vos" (`Puntuar` y `Mezclar`): puntúa cada artículo por tus gustos (vistas, favoritos, propuestas y filtros de los últimos 90 días, de [[SP GetSenalesGustos]]), tus búsquedas recientes, el interés del dueño en tus categorías ([[SP GetCategoriasDeUsuario]]) y la popularidad ([[SP GetPopularidad]]); cada 5 mete uno para descubrir. Desde el 17/11 está escrito con bucles y `List.Sort`, sin LINQ.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- llama a [[ArticulosBD.GetArticuloById()]] · `calls` EXTRACTED
- llama a [[ArticulosBD.GetArticulosCatalogo()]] · `calls` EXTRACTED
- llama a [[ArticulosBD.GetCategoriasDeUsuario()]] · `calls` EXTRACTED
- llama a [[Listas]] · `calls` EXTRACTED
- llama a [[RecomendacionesBD.GetPopularidad()]] · `calls` EXTRACTED
- llama a [[RecomendacionesBD.GetSenalesGustos()]] · `calls` EXTRACTED
- llama a [[RecomendacionesBD.GuardarSegundosVista()]] · `calls` EXTRACTED
- llama a [[RecomendacionesBD.RegistrarBusqueda()]] · `calls` EXTRACTED
- llama a [[RecomendacionesBD.RegistrarVista()]] · `calls` EXTRACTED
- contiene [[Namespace Swappit.Controllers]] · `contains` EXTRACTED
- importa [[Microsoft.AspNetCore.Mvc]] · `imports` EXTRACTED
- importa [[Microsoft.AspNetCore.Mvc.Rendering]] · `imports` EXTRACTED
- importa [[Microsoft.Data.SqlClient]] · `imports` EXTRACTED
- importa [[Namespace Swappit.Models]] · `imports` EXTRACTED
- importa [[Namespace Swappit.Models.ViewModels]] · `imports` EXTRACTED
- hereda de [[Controller (ASP.NET MVC)]] · `inherits` EXTRACTED
- usa el tipo [[ArticuloCardViewModel]] · `references` EXTRACTED
- usa el tipo [[DateTime]] · `references` EXTRACTED
- usa el tipo [[HttpPost]] · `references` EXTRACTED
- usa el tipo [[IActionResult]] · `references` EXTRACTED
- usa el tipo [[ILogger]] · `references` EXTRACTED
- usa el tipo [[List]] · `references` EXTRACTED
- usa el tipo [[SelectListItem]] · `references` EXTRACTED
- usa el tipo [[ValidateAntiForgeryToken]] · `references` EXTRACTED

**Desde otras notas:**
- [[ArticulosController.Buscar()]] la llama · `calls` EXTRACTED
- [[HomeController.Index()]] la llama · `calls` EXTRACTED
- [[HomeController.Inicio()]] la llama · `calls` EXTRACTED
- [[Vista Articulos-Buscar]] tiene un link acá · `links_to` EXTRACTED
- [[Vista Articulos-Detalle]] tiene un link acá · `links_to` EXTRACTED
