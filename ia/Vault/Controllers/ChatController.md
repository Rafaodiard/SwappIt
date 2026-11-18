---
tipo: controller
comunidad: "Controllers, vistas y JS"
archivos:
  - "Controllers/ChatController.cs"
graphify_ids:
  - "controllers_chatcontroller_swappit_controllers_chatcontroller"
  - "controllers_chatcontroller"
tags:
  - tipo/controller
  - comunidad/Controllers_vistas_y_JS
---
# ChatController

`Controllers/ChatController.cs` · Chat para coordinar los intercambios: una conversación por intercambio, entre sus dos partes ([[Flujo Chat]]).
- `Index(id?)` → [[Vista Chat-Index]]: lista de conversaciones (intercambios en curso y los que ya tienen mensajes, la más reciente primero) y la abierta (sin `id`, la primera). Marca como vistos los mensajes de la abierta.
- `Mensajes(id)` → partial [[Vista Chat-_Mensajes]]: lo pide [[chat.js]] cada 4 segundos.
- `Enviar(id, texto)` (POST): valida el largo (`Mensajes.LargoMaximoTexto`, 500) y guarda con [[ChatBD.EnviarMensaje()]]; vuelve al chat.
- `PuedeEscribir(intercambio, elOtroYaEscribio)` (privado): Aceptado, o Pendiente si sos quien recibió la propuesta o si esa persona ya te escribió. Decide qué conversaciones aparecen en la lista y si se muestra el form; si se rechazó, se canceló o se realizó, el chat queda para leer.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Controllers]] · `contains` EXTRACTED
- importa [[Microsoft.AspNetCore.Mvc]] · `imports` EXTRACTED
- importa [[Microsoft.Data.SqlClient]] · `imports` EXTRACTED
- importa [[Namespace Swappit.Models]] · `imports` EXTRACTED
- importa [[Namespace Swappit.Models.ViewModels]] · `imports` EXTRACTED
- hereda de [[Controller (ASP.NET MVC)]] · `inherits` EXTRACTED
- tiene el método [[ChatController.Enviar()]] · `method` EXTRACTED
- tiene el método [[ChatController.Index()]] · `method` EXTRACTED
- tiene el método [[ChatController.Mensajes()]] · `method` EXTRACTED
- tiene el método [[ChatController.PuedeEscribir()]] · `method` EXTRACTED
- usa el tipo [[ILogger]] · `references` EXTRACTED
