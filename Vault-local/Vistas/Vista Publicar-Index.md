---
tipo: vista
comunidad: "Namespaces y formularios"
archivos:
  - "Views/Publicar/Index.cshtml"
graphify_ids:
  - "views_publicar_index"
tags:
  - tipo/vista
  - comunidad/Namespaces_y_formularios
---
# Vista: Publicar / Index

`Views/Publicar/Index.cshtml` · Form `multipart/form-data` POST a [[PublicarController]].Index. Columna izquierda: zona de carga de fotos (clic o arrastrar), 4 miniaturas, aviso de límites. Columna derecha: Título, Categoría (select), Ubicación, Estado del objeto (radios con forma de chip, de [[Tabla EstadosArticulos]]), Descripción con contador, "¿Qué te gustaría recibir a cambio?". Botones Cancelar / Publicar objeto. Scripts: jQuery, [[Vista _ValidationScriptsPartial]], [[publicar.js]]. Modelo: [[PublicarArticuloViewModel]].

Comunidad del grafo: [[Comunidad - Namespaces y formularios]]

## Conexiones en el grafo (graphify)
- llama a [[SelectListItem]] · `calls` EXTRACTED
- importa [[Microsoft.AspNetCore.Mvc.Rendering]] · `imports` EXTRACTED
- importa [[Namespace Swappit.Models.ViewModels]] · `imports` EXTRACTED
- incluye el partial [[Vista _ValidationScriptsPartial]] · `includes` EXTRACTED
- tiene un link a [[HomeController.Index()]] · `links_to` EXTRACTED
- carga el script [[publicar.js]] · `loads_script` EXTRACTED
- envía el formulario a [[PublicarController.Index() POST]] · `posts_to` EXTRACTED

**Desde otras notas:**
- [[PublicarController.Index() GET]] muestra esta vista · `renders` INFERRED
