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
- Derecha: el chat abierto (partial [[Vista Chat-_Mensajes]], que [[chat.js]] actualiza cada 4 segundos), link al intercambio y al perfil de la otra persona, y el form para escribir (POST a `Enviar`, hasta 500 caracteres). Se puede escribir con el intercambio Aceptado, o Pendiente si sos quien recibió la propuesta (o esa persona ya te escribió); si no, abajo dice "Cuando X te escriba, vas a poder responderle". Si se rechazó, se canceló o ya se realizó, el chat queda para leer. El avatar del encabezado tiene `data-iniciales` para que [[imagenes.js]] muestre las iniciales si la foto no está.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- importa [[Namespace Swappit.Models]] · `imports` EXTRACTED
- importa [[Namespace Swappit.Models.ViewModels]] · `imports` EXTRACTED
- tiene un link a [[ArticulosController.Buscar()]] · `links_to` EXTRACTED
- tiene un link a [[ChatController.Enviar()]] · `links_to` EXTRACTED
- tiene un link a [[ChatController.Index()]] · `links_to` EXTRACTED
- tiene un link a [[ChatController.Mensajes()]] · `links_to` EXTRACTED
- tiene un link a [[IntercambioController.Detalle()]] · `links_to` EXTRACTED
- tiene un link a [[PerfilController.Publico()]] · `links_to` EXTRACTED
- carga el script [[chat.js]] · `loads_script` EXTRACTED
