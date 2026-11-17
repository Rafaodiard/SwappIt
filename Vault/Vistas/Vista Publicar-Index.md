---
tipo: vista
comunidad: "Publicar artículo"
archivos:
  - "Views/Publicar/Index.cshtml"
graphify_ids:
  - "views_publicar_index"
tags:
  - tipo/vista
  - comunidad/Publicar_artículo
---
# Vista: Publicar / Index

`Views/Publicar/Index.cshtml` · Form `multipart/form-data` POST a [[PublicarController]].Index. Columna izquierda: zona de carga de fotos (clic o arrastrar), 4 miniaturas, aviso de límites. Columna derecha: Título, Categoría (select), Ubicación, Estado del objeto (radios con forma de chip, de [[Tabla EstadosArticulos]]), Descripción con contador, "¿Qué te gustaría recibir a cambio?". Botones Cancelar / Publicar objeto. Los campos obligatorios llevan `data-requerido` con el mensaje del `[Required]` de [[PublicarArticuloViewModel]] (helper `Requerido`) para [[publicar.js]]. Con `ViewBag.limiteAlcanzado` muestra el aviso del máximo de 5 con link a Mis intercambios y deshabilita el botón. Scripts: jQuery, [[Vista _ValidationScriptsPartial]], [[publicar.js]]. Modelo: [[PublicarArticuloViewModel]].

Comunidad del grafo: [[Comunidad - Publicar artículo]]

## Conexiones en el grafo (graphify)
- llama a [[SelectListItem]] · `calls` EXTRACTED
- importa [[Microsoft.AspNetCore.Mvc.Rendering]] · `imports` EXTRACTED
- importa [[Namespace Swappit.Models.ViewModels]] · `imports` EXTRACTED
- importa [[System.ComponentModel.DataAnnotations]] · `imports` EXTRACTED
- incluye el partial [[Vista _ValidationScriptsPartial]] · `includes` EXTRACTED
- tiene un link a [[HomeController.Index()]] · `links_to` EXTRACTED
- tiene un link a [[IntercambioController.Index()]] · `links_to` EXTRACTED
- tiene un link a [[PublicarController.Index() GET]] · `links_to` EXTRACTED
- carga el script [[publicar.js]] · `loads_script` EXTRACTED

**Desde otras notas:**
- [[PublicarController.Index() POST]] muestra esta vista · `renders` INFERRED
