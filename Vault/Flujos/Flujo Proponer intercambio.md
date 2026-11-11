---
tipo: flujo
tags:
  - tipo/flujo
---
# Flujo: Proponer intercambio

**Estado:** funciona (proponer, aceptar, rechazar, cancelar y marcar como realizado), con notificaciones.

1. En [[Vista Articulos-Detalle]], un usuario logueado que no es el dueño abre el pop up "Proponer intercambio" y elige **de 1 a 3** de sus artículos (checkbox; [[articulo.js]] no deja marcar más y habilita "Enviar propuesta" cuando hay al menos uno). Si tiene uno solo, viene marcado. Si no tiene artículos, se le ofrece publicar uno ([[Flujo Publicar artículo]]).
2. POST a [[IntercambioController]].Proponer (`idsArticulosOfrecidos`): valida que el artículo no sea propio, que se ofrezcan entre 1 y `Intercambios.MaxArticulosOfrecidos` (3), que todos sean suyos y que ninguno esté comprometido. [[BD.ProponerIntercambio()]] inserta en [[Tabla Intercambios]] con estado Pendiente (quien propone en `IdUsuarios1`), guarda los ofrecidos y el pedido en [[Tabla ArticulosIntercambios]] y avisa al dueño ("Propuesta recibida"). No deja repetir una propuesta en curso por el mismo artículo.
3. El dueño ve la propuesta en [[Vista Intercambio-Detalle]] (o desde la campana, Mis intercambios o el inicio) y la **acepta** o la **rechaza** entera (no puede quedarse con una parte). Al aceptar, las otras propuestas pendientes que comparten algún artículo se rechazan solas ([[BD.CambiarEstadoIntercambio()]]) y todos los artículos del intercambio quedan comprometidos (dejan de mostrarse en el catálogo).
4. Una vez aceptado, cualquiera de los dos lo **marca como realizado** (sin notificación) o lo **cancela**. Quien propuso también puede cancelar mientras está Pendiente ([[BD.CancelarIntercambio()]], avisa "Intercambio cancelado").
5. Con la propuesta Pendiente, el chat lo empieza quien la recibió; una vez aceptada, las dos partes coordinan por el chat ([[Flujo Chat]]). Todos los intercambios están en [[Vista Intercambio-Index]].

No usa [[SP RegistrarIntercambio]] (busca por nombre y exige fecha pasada, ver [[Pendientes y problemas]]).
