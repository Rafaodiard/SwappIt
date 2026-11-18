---
tipo: tabla
archivos:
  - "BaseDatos/Estructura.sql"
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
tags:
  - tipo/tabla
---
# Tabla CambiosIntercambios

| Columna | Tipo |
|---|---|
| Id | int identity, PK |
| IdIntercambio | int NOT NULL, FK → [[Tabla Intercambios]] |
| IdArticulo | int NOT NULL, FK → [[Tabla Articulos]] |
| IdUsuario | int NOT NULL, FK → [[Tabla Usuarios]] (quién hizo el cambio) |
| IdTipoCambio | int NOT NULL, FK → [[Tabla TipoCambios]] (Agregar, Sacar, Pedir) |
| IdEstado | int NOT NULL, FK → [[Tabla EstadosIntercambios]] (Pendiente, Aceptado, Rechazado, Cancelado) |
| Fecha | datetime NOT NULL |
| FechaRespuesta | datetime NULL |

Guarda cada cambio que se hace a un intercambio Pendiente o Aceptado desde [[Vista Intercambio-Detalle]] (14/11, pedido de Rafael; ver [[Flujo Proponer intercambio]]). [[Tabla ArticulosIntercambios]] sigue guardando solo lo confirmado.

- **Agregar** (un artículo propio): se guarda directamente como Aceptado y el artículo entra enseguida en `ArticulosIntercambios`. Si se agregan varios de una vez, comparten la misma `Fecha` y salen en una sola notificación.
- **Sacar** (un artículo propio) y **Pedir** (un artículo del otro): quedan Pendiente hasta que el otro los acepta o los rechaza. Quien los hizo los puede cancelar mientras tanto.
- Un artículo tiene como máximo un cambio pendiente por intercambio. Cada lado queda entre 1 y 3 artículos (`Intercambios.MaxArticulosOfrecidos`).
- Cuando el intercambio termina, los pendientes dejan de valer: no se actualizan, las consultas solo miran intercambios Pendientes o Aceptados.

La usan los métodos de cambios de [[BD]] (`AgregarArticulos`, `PedirArticulo`, `PedirSacarArticulo`, `ResponderCambio`, `CancelarCambio`, `GetCambiosIntercambio`), `CambiarEstadoIntercambio` (no deja aceptar con cambios sin responder ni marcar realizado con pendientes) y las notificaciones (`Notificaciones.IdCambio`). Índice `IX_CambiosIntercambios_IdIntercambio` (IdIntercambio, IdEstado). Datos de prueba: ninguno.
