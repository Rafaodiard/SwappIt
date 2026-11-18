---
tipo: flujo
tags:
  - tipo/flujo
---
# Flujo: Proponer intercambio

**Estado:** funciona (proponer, aceptar, rechazar, cancelar y marcar como realizado), con notificaciones.

1. En [[Vista Articulos-Detalle]], un usuario logueado que no es el dueño abre el pop up "Proponer intercambio" y elige **de 1 a 3** de sus artículos (checkbox; [[articulo.js]] no deja marcar más y habilita "Enviar propuesta" cuando hay al menos uno). Si tiene uno solo, viene marcado. Si no tiene artículos, se le ofrece publicar uno ([[Flujo Publicar artículo]]).
2. POST a [[IntercambioController]].Proponer (`idsArticulosOfrecidos`): valida que el artículo no sea propio, que se ofrezcan entre 1 y `Intercambios.MaxArticulosOfrecidos` (3), que todos sean suyos y que ninguno esté comprometido. [[IntercambiosBD.ProponerIntercambio()]] inserta en [[Tabla Intercambios]] con estado Pendiente (quien propone en `IdUsuarios1`), guarda los ofrecidos y el pedido en [[Tabla ArticulosIntercambios]] y avisa al dueño ("Propuesta recibida"). No deja repetir una propuesta en curso por el mismo artículo.
3. El dueño ve la propuesta en [[Vista Intercambio-Detalle]] (o desde la campana, Mis intercambios o el inicio) y la **acepta** o la **rechaza** entera (no puede quedarse con una parte). Al aceptar, las otras propuestas pendientes que comparten algún artículo se rechazan solas ([[IntercambiosBD.CambiarEstadoIntercambio()]]) y todos los artículos del intercambio quedan comprometidos (dejan de mostrarse en el catálogo).
4. Una vez aceptado, cualquiera de los dos lo **marca como realizado** (sin notificación) o lo **cancela**. Quien propuso también puede cancelar mientras está Pendiente ([[IntercambiosBD.CancelarIntercambio()]], avisa "Intercambio cancelado").
5. Con la propuesta Pendiente, el chat lo empieza quien la recibió; una vez aceptada, las dos partes coordinan por el chat ([[Flujo Chat]]). Todos los intercambios están en [[Vista Intercambio-Index]].

## Cambiar un intercambio (14/11)

Mientras el intercambio está Pendiente o Aceptado, en [[Vista Intercambio-Detalle]] cualquiera de los dos puede:
- **Agregar** artículos suyos ("+ Agregar de tus artículos", pop up con casillas). Se suman enseguida y al otro le llega "Artículo agregado".
- **Sacar** un artículo suyo (botón Sacar). Queda esperando hasta que el otro lo acepte ("Pedido para sacar"). Se puede deshacer.
- **Pedir** un artículo del otro ("+ Pedirle un artículo"). Queda esperando hasta que el dueño lo acepte ("Pedido de artículo"). Se puede cancelar.

Lo que te toca responder aparece arriba de todo ("Sofía te pide N cambios", con No y Sí). Cada artículo muestra si está esperando, si te toca responder o quién lo agregó, y "Últimos cambios" lista quién hizo qué y cuándo (también en intercambios terminados, solo para leer). Cada lado queda entre 1 y 3 artículos. Mientras tengas cambios sin responder no podés aceptar el intercambio, y con cambios pendientes nadie puede marcarlo como realizado. Si mientras mirabas la página el otro agregó algo, Aceptar no pasa y te pide revisarlo. Si se suma un artículo a un intercambio Aceptado, se rechazan solas las otras propuestas pendientes que lo tengan. Se guarda en [[Tabla CambiosIntercambios]]. Diseño completo en `ia/superpowers/specs/2026-11-14-editar-intercambio-design.md`.

No usa [[SP RegistrarIntercambio]] (busca por nombre y exige fecha pasada, ver [[Pendientes y problemas]]).
