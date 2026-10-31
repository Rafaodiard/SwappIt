---
tipo: controller
comunidad: "Controllers, vistas y JS"
archivos:
  - "Controllers/IntercambioController.cs"
graphify_ids:
  - "controllers_intercambiocontroller_swappit_controllers_intercambiocontroller"
  - "controllers_intercambiocontroller"
tags:
  - tipo/controller
  - comunidad/Controllers_vistas_y_JS
---
# IntercambioController

`Controllers/IntercambioController.cs` · Intercambios entre usuarios ([[Flujo Proponer intercambio]]):
- `Index(estado)` → [[Vista Intercambio-Index]]: Mis intercambios (enviados y recibidos), con filtro por estado (`?estado=Pendiente`) y la cantidad de cada estado.
- `Detalle(id)` → [[Vista Intercambio-Detalle]]: solo para las dos partes (si no, 404). Calcula si alguno de los artículos ya está comprometido y cuántas propuestas se rechazarían solas al aceptar.
- `Proponer` (POST, desde el pop up de [[Vista Articulos-Detalle]]): valida que el artículo no sea propio, que el ofrecido sea del usuario y que ninguno esté comprometido; guarda con [[BD.ProponerIntercambio()]].
- `Aceptar` / `Rechazar` (solo quien recibió la propuesta, mientras está Pendiente), `MarcarRealizado` (cualquiera, una vez aceptado) y `Cancelar`. Los tres primeros pasan por el privado `CambiarEstado` → [[BD.CambiarEstadoIntercambio()]].

Al proponer, aceptar, rechazar o cancelar se le avisa a la otra persona con una notificación. Marcar como realizado no avisa. Los mensajes al usuario van en `TempData`.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Controllers]] · `contains` EXTRACTED
- importa [[Microsoft.AspNetCore.Mvc]] · `imports` EXTRACTED
- importa [[Microsoft.Data.SqlClient]] · `imports` EXTRACTED
- importa [[Namespace Swappit.Models]] · `imports` EXTRACTED
- importa [[Namespace Swappit.Models.ViewModels]] · `imports` EXTRACTED
- hereda de [[Controller (ASP.NET MVC)]] · `inherits` EXTRACTED
- tiene el método [[IntercambioController.Aceptar()]] · `method` EXTRACTED
- tiene el método [[IntercambioController.CambiarEstado()]] · `method` EXTRACTED
- tiene el método [[IntercambioController.Cancelar()]] · `method` EXTRACTED
- tiene el método [[IntercambioController.Detalle()]] · `method` EXTRACTED
- tiene el método [[IntercambioController.Index()]] · `method` EXTRACTED
- tiene el método [[IntercambioController.MarcarRealizado()]] · `method` EXTRACTED
- tiene el método [[IntercambioController.Proponer()]] · `method` EXTRACTED
- tiene el método [[IntercambioController.Rechazar()]] · `method` EXTRACTED
- usa el tipo [[ILogger]] · `references` EXTRACTED
