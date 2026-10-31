---
tipo: flujo
tags:
  - tipo/flujo
---
# Flujo: Proponer intercambio

**Estado:** funciona (proponer, aceptar, rechazar, cancelar y marcar como realizado), con notificaciones.

1. En [[Vista Articulos-Detalle]], un usuario logueado que no es el dueño abre el pop up "Proponer intercambio" y elige uno de sus artículos. Si no tiene artículos, se le ofrece publicar uno ([[Flujo Publicar artículo]]).
2. POST a [[IntercambioController]].Proponer: valida que el artículo no sea propio, que el ofrecido sea suyo y que ninguno esté comprometido. [[BD.ProponerIntercambio()]] inserta en [[Tabla Intercambios]] con estado Pendiente (quien propone en `IdUsuarios1`/`IdArticulos1`) y avisa al dueño ("Propuesta recibida"). No deja repetir una propuesta en curso por el mismo artículo.
3. El dueño ve la propuesta en [[Vista Intercambio-Detalle]] (o desde la campana, Mis intercambios o el inicio) y la **acepta** o la **rechaza**. Al aceptar, las otras propuestas pendientes con esos artículos se rechazan solas ([[BD.CambiarEstadoIntercambio()]]) y los dos artículos quedan comprometidos (dejan de mostrarse en el catálogo).
4. Una vez aceptado, cualquiera de los dos lo **marca como realizado** (sin notificación) o lo **cancela**. Quien propuso también puede cancelar mientras está Pendiente ([[BD.CancelarIntercambio()]], avisa "Intercambio cancelado").
5. Mientras está en curso, las dos partes coordinan por el chat ([[Flujo Chat]]). Todos los intercambios están en [[Vista Intercambio-Index]].

No usa [[SP RegistrarIntercambio]] (busca por nombre y exige fecha pasada, ver [[Pendientes y problemas]]).
