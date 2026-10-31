---
tipo: vista
comunidad: "Controllers, vistas y JS"
archivos:
  - "Views/Chat/Index.cshtml"
graphify_ids:
  - "views_chat_index"
  - "views_chat_index_cshtml_intercambioviewmodel"
tags:
  - tipo/vista
  - comunidad/Controllers_vistas_y_JS
---
# Vista: Chat / Index

`Views/Chat/Index.cshtml` · [[ChatController]].Index. Una conversación por intercambio, entre sus dos partes ([[Flujo Chat]]):
- Izquierda: los intercambios en curso y los que ya tienen mensajes, con el último mensaje ([[ConversacionViewModel]]) y cuántos no viste; buscador que filtra la lista.
- Derecha: el chat abierto (partial [[Vista Chat-_Mensajes]], que [[chat.js]] actualiza cada 4 segundos), link al intercambio y al perfil de la otra persona, y el form para escribir (POST a `Enviar`, hasta 500 caracteres). Si el intercambio se rechazó o ya se realizó, el chat queda para leer.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- importa [[Namespace Swappit.Models]] · `imports` EXTRACTED
- importa [[Namespace Swappit.Models.ViewModels]] · `imports` EXTRACTED
- incluye el partial [[Vista Chat-_Mensajes]] · `includes` EXTRACTED
- tiene un link a [[ArticulosController.Buscar()]] · `links_to` EXTRACTED
- tiene un link a [[ChatController.Index()]] · `links_to` EXTRACTED
- tiene un link a [[ChatController.Mensajes()]] · `links_to` EXTRACTED
- tiene un link a [[IntercambioController.Detalle()]] · `links_to` EXTRACTED
- tiene un link a [[PerfilController.Publico()]] · `links_to` EXTRACTED
- carga el script [[chat.js]] · `loads_script` EXTRACTED
- envía el formulario a [[ChatController.Enviar()]] · `posts_to` EXTRACTED

**Desde otras notas:**
- [[ChatController.Index()]] muestra esta vista · `renders` INFERRED
