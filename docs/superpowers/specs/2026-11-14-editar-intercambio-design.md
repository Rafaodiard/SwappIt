# Agregar, sacar y pedir artículos dentro de un intercambio

Diseño del 14/11/2026. Pedido por Rafael. Rama de partida: `multiples` (`b761fb9`), donde ya se pueden ofrecer de 1 a 3 artículos al proponer (tabla `ArticulosIntercambios`).

## Para qué

Hoy, para cambiar los artículos de un intercambio, hay que cancelarlo y proponer de nuevo. Rafael quiere que sea más fácil: que desde la misma página del intercambio cada uno pueda sumar artículos suyos, sacarlos y pedirle artículos al otro. La pantalla tiene que ser simple y dejar muy claro qué está haciendo el otro.

## Reglas (las dio Rafael)

- Los dos usuarios pueden cambiar el intercambio mientras está **Pendiente o Aceptado**. Cuando terminó, no se puede cambiar nada.
- **Agregar un artículo propio:** se suma enseguida. Al otro le llega una notificación.
- **Sacar un artículo propio:** el otro lo tiene que aceptar. Hasta que acepte, el artículo sigue en el intercambio.
- **Pedir un artículo del otro:** al otro le llega una notificación, y el artículo se suma solo si lo acepta.

## Decisiones mías (Rafael no las corrigió, pero se pueden cambiar)

1. "Terminado" quiere decir Realizado, Rechazado o Cancelado.
2. Un pedido (de sacar o de agregar) se puede aceptar o rechazar, y en los dos casos se le avisa a quien lo hizo. Quien lo hizo lo puede cancelar mientras no lo respondieron ("Deshacer" / "Cancelar pedido"). Al cancelarlo no se manda aviso. Lo responde siempre el otro usuario, el que no lo hizo.
3. Cada lado tiene entre 1 y 3 artículos. Para no pasarse de 3 se cuentan los confirmados más los pedidos de agregar pendientes de ese lado. No se puede pedir sacar si eso deja al lado sin artículos, contando los pedidos de sacar que ya están pendientes.
4. No se puede sumar un artículo que ya está en otro intercambio Aceptado o Realizado (misma regla que al proponer). Se controla al agregarlo, al pedirlo y otra vez al aceptar el pedido.
5. Si el intercambio ya está **Aceptado** y se le suma un artículo (por agregarlo o por aceptar un pedido), se rechazan solas las otras propuestas pendientes que lo tengan y se avisa a quienes las hicieron. Pasa lo mismo que hoy al aceptar un intercambio (`RechazarPendientesDeArticulos`).
6. Mientras quien recibió la propuesta tenga cambios sin responder, el botón **Aceptar intercambio** queda desactivado y dice por qué. Así nadie acepta sin haber visto lo último. Los pedidos que hizo él y esperan al otro no lo frenan. Esto se controla también en el servidor, no solo en la pantalla.
   - Hay un caso que eso no cubre: que el otro **agregue** algo mientras tenés la página abierta, porque agregar no deja nada pendiente. Para eso, el formulario de Aceptar manda escondido el `Id` del último cambio que se mostró. Si al aceptar hay un cambio más nuevo, no se acepta, se vuelve a la página y aparece el mensaje "Sofía cambió el intercambio mientras lo mirabas. Revisalo y aceptá de nuevo."
7. Un artículo solo puede tener un cambio pendiente por intercambio. No se puede pedir dos veces el mismo, ni pedir sacar uno que ya tiene un pedido de sacar.
8. Cuando el intercambio termina, los cambios que quedaban pendientes dejan de valer y no se pueden responder. No se actualizan uno por uno: las consultas y las acciones solo tienen en cuenta los cambios de intercambios Pendientes o Aceptados. En el historial aparecen como "sin respuesta".
   - **Marcar como realizado** queda bloqueado, para los dos, mientras haya algún cambio pendiente. Si no, un artículo que su dueño pidió sacar quedaría registrado como intercambiado. El bloqueo se controla en el servidor (en el SQL de `CambiarEstadoIntercambio` cuando el estado nuevo es Realizado), y en la pantalla el botón aparece desactivado con el texto "Hay cambios sin responder. Respondelos o cancelalos antes de marcarlo como realizado." **Cancelar** el intercambio sigue permitido.
   - El historial **se sigue viendo** en los intercambios terminados, pero solo para leer: sin botones y sin la caja de cambios.
9. Si se agregan varios artículos de una vez, sale **una sola** notificación y un solo mail que los nombra a todos. Los pedidos son de a uno, así cada uno se responde por separado y lleva su propia notificación.
10. No se crean SP nuevos: todo va con SQL en `BD.cs`, como el resto de intercambios, chat y notificaciones.

## Fuera de alcance

- Cambiar el artículo pedido al proponer: la propuesta se arma igual que ahora.
- Contraofertas por turnos, o aceptar solo parte de un pedido.
- Editar o borrar artículos publicados (sigue sin existir).

## Enfoque elegido

Se consideraron dos formas de guardar los cambios:

1. **Tabla nueva `CambiosIntercambios` (elegida por Rafael, recomendada).** Guarda cada vez que alguien agrega, saca o pide un artículo: quién, qué artículo, de qué tipo, en qué estado y cuándo. `ArticulosIntercambios` sigue guardando solo lo confirmado, así que las 16 consultas que ya la usan no cambian. El historial de "Últimos cambios" sale de esta tabla.
2. Una columna de estado en `ArticulosIntercambios` (confirmado, pedido, por sacar). Es una tabla menos, pero había que agregarle un filtro a las 16 consultas, con el riesgo de contar algo como confirmado sin serlo, y no quedaba registro de quién hizo qué. Se descartó.

## Base de datos

Va en los dos scripts principales (`SQLSwappit.sql`, que es UTF-16, y `SQLSwappit_CualquierCompu.sql`) y en los tres de `BaseDatos/` (`Estructura.sql`, `Datos.sql` y `StoredProcedures.sql`). No hay script de migración: Rafael actualiza su base por su cuenta.

**Tabla nueva `TipoCambios`** (como `TipoNotificaciones`): `Id` int identity PK y `Nombre` varchar(50). Datos: 1 Agregar, 2 Sacar, 3 Pedir.

**Tabla nueva `CambiosIntercambios`:**

| Columna | Tipo |
|---|---|
| `Id` | int identity, PK |
| `IdIntercambio` | int NOT NULL, FK → `Intercambios` |
| `IdArticulo` | int NOT NULL, FK → `Articulos` |
| `IdUsuario` | int NOT NULL, FK → `Usuarios` (quién hizo el cambio) |
| `IdTipoCambio` | int NOT NULL, FK → `TipoCambios` |
| `IdEstado` | int NOT NULL, FK → `EstadosIntercambios` (se usan Pendiente, Aceptado, Rechazado y Cancelado) |
| `Fecha` | datetime NOT NULL |
| `FechaRespuesta` | datetime NULL |

- **Agregar** se guarda directamente como Aceptado, porque se aplica enseguida.
- **Sacar** y **Pedir** se guardan como Pendiente. Al aceptarlos pasan a Aceptado, y en la misma transacción se borra o se inserta la fila de `ArticulosIntercambios`. Al rechazarlos pasan a Rechazado, y si quien los hizo los cancela, a Cancelado.
- `IdEstado` reusa `EstadosIntercambios` para no sumar otra tabla con casi los mismos nombres (decisión mía). Realizado no se usa para los cambios.

**`Notificaciones`:** columna nueva `IdCambio` int NULL, FK → `CambiosIntercambios`. Antes había propuesto `IdArticulo`, pero con `IdCambio` la notificación sabe también si fue agregar, sacar o pedir, y si lo aceptaron o lo rechazaron. Las notificaciones de siempre la dejan en NULL.

**`TipoNotificaciones`:** filas nuevas.

| Id | Nombre | A quién le llega | Texto en la lista |
|---|---|---|---|
| 6 | Artículo agregado | al otro | "Sofía agregó Bicicleta al intercambio" |
| 7 | Pedido de artículo | al dueño del artículo | "Sofía te pidió tu Lámpara de pie" |
| 8 | Pedido para sacar | al otro | "Sofía quiere sacar su Silla del intercambio" |
| 9 | Cambio aceptado | a quien hizo el pedido | "Sofía aceptó sumar Cafetera" / "Sofía aceptó que saques Espejo" |
| 10 | Cambio rechazado | a quien hizo el pedido | "Sofía no aceptó sumar Cafetera" / "Sofía no aceptó que saques Espejo" |

Los datos de prueba (`Datos.sql` y los dos principales) no traen filas en `CambiosIntercambios`.

## Pantalla (Ver intercambio)

Se basa en el boceto que se mandó en el hilo el 14/11, y esta descripción es la definitiva. Usa los colores y componentes que ya tiene Swappit (`sw-card`, `sw-intercambio-panel`, `sw-modal` y los botones `btn-sw-*`). Los controles para cambiar el intercambio aparecen en las dos versiones de `Views/Intercambio/Detalle.cshtml`, "Recibiste una propuesta" y la de seguimiento, siempre que el intercambio esté Pendiente o Aceptado. El historial aparece en todos los estados.

Cada versión mantiene su estructura y sus títulos: "Recibiste una propuesta" sigue con "Te ofrece / Por tu", y la de seguimiento, con "Vos das / Recibís". En las dos, la caja de cambios va entre el encabezado (el `h1` y su texto) y la tarjeta principal, a todo el ancho de esa tarjeta. Los botones "+ Agregar" y "+ Pedir" van al final del panel del lado que corresponde.

1. **Caja "Sofía te pide N cambios"**: va arriba de todo y solo aparece si hay cambios que te toca responder. Cada uno es una frase con la foto chica del artículo, una aclaración de qué pasa si aceptás ("Si aceptás, se suma a lo que das") y los botones **No** y **Sí, sumarla** o **Sí, sacarla**.
2. **Vos das / Recibís**: son las listas de artículos de cada lado, con su estado:
   - Confirmado: se ve como ahora. Tus artículos tienen un botón **Sacar** si sacarlo no deja tu lado vacío.
   - Agregado después de la propuesta: "Lo agregó Sofía · 14/11", o "Lo agregaste vos".
   - Esperando al otro: borde punteado y la etiqueta "Esperando a Sofía", con **Deshacer** (si pediste sacarlo) o **Cancelar pedido** (si lo pediste).
   - Esperando tu respuesta: borde punteado y la etiqueta "Te toca responder". La respuesta se da en la caja de arriba.
3. **"+ Agregar de tus artículos"** va al final de Vos das, si te queda lugar. Abre un pop up con casillas, igual que el de Proponer: tus artículos disponibles que no están en el intercambio y el contador "Podés sumar 2 más". Aclara: "Se suman enseguida. A Sofía le llega un aviso."
4. **"+ Pedirle un artículo a Sofía"** va al final de Recibís, si queda lugar. Abre un pop up con los artículos disponibles de Sofía que no están en el intercambio, y se elige uno. Aclara: "Sofía tiene que aceptarlo para que se sume."
5. **Últimos cambios**: es una lista con quién hizo qué y cuándo, de lo más nuevo a lo más viejo ("Sofía agregó Bicicleta · hoy 14:20", "Vos pediste Cafetera · ayer 19:02", "Sofía aceptó sacar Espejo"). En la versión de seguimiento va en la columna derecha, y en "Recibiste una propuesta", debajo de la propuesta. Solo aparece si hubo algún cambio.
6. **Aceptar intercambio** queda desactivado mientras tengas cambios sin responder, con el texto "Respondé los cambios de Sofía antes de aceptar."
7. Cada acción vuelve a la misma página con un mensaje arriba, como hoy (`TempData["MensajeIntercambio"]` / `TempData["ErrorIntercambio"]`): "Sumaste Bicicleta. A Sofía le llegó un aviso." o "Le pediste la Cafetera a Sofía."

En celular, Vos das y Recibís van uno abajo del otro, y la caja de cambios queda arriba de todo.

## Código que cambia

- **`Models/BD.cs`**: hay métodos nuevos, cada uno con su transacción y su notificación, como los de ahora:
  - `AgregarArticulos(idIntercambio, idUsuario, ids)`
  - `PedirArticulo(idIntercambio, idUsuario, idArticulo)`
  - `PedirSacarArticulo(idIntercambio, idUsuario, idArticulo)`
  - `ResponderCambio(idCambio, idUsuario, aceptar)`
  - `CancelarCambio(idCambio, idUsuario)`
  - `GetCambiosIntercambio(idIntercambio, idUsuario)`, que trae los pendientes y el historial.

  Cada uno vuelve a revisar adentro del SQL el estado del intercambio, que el usuario sea parte, el dueño del artículo, el límite de 1 a 3 y que el artículo esté disponible, igual que hoy `ProponerIntercambio` y `CambiarEstadoIntercambio`. `CrearNotificacion` recibe un `idCambio` opcional. `GetNotificaciones` y `GetDatosMailNotificacion` traen el cambio cuando hay uno.
- **`Controllers/IntercambioController.cs`** tiene acciones POST nuevas con `[ValidateAntiForgeryToken]`: `AgregarArticulos(int id, int[]? idsArticulos)`, `PedirArticulo(int id, int idArticulo)`, `SacarArticulo(int id, int idArticulo)`, `ResponderCambio(int idCambio, bool aceptar)` y `CancelarCambio(int idCambio)`. Validan, llaman a `BD` y a `EmailService.EnviarNotificaciones`, y redirigen a `Detalle`. `Detalle` pasa por `ViewBag` los cambios pendientes, el historial, tus artículos para agregar y los de él para pedir.
- **Modelos**: `TipoCambios` tiene constantes como `TipoNotificaciones`. `TipoNotificaciones` suma las 5 nuevas. Hay un `CambioIntercambioViewModel`. `NotificacionCreada` y `NotificacionViewModel` suman los datos del cambio, y `Intercambios.MaxArticulosOfrecidos` pasa a usarse como máximo por lado.
- **Vistas**: `Views/Intercambio/Detalle.cshtml` (la caja de cambios, las etiquetas, los botones y dos pop ups) y `Views/Notificaciones/_Lista.cshtml` (íconos y textos de los tipos nuevos).
- **`Services/EmailService.cs`**: textos de mail para los 5 tipos nuevos.
- **`wwwroot/js`**: el contador del pop up de agregar reusa la lógica del de Proponer de `articulo.js`, sin duplicarla.
- **`wwwroot/css/site.css`**: estilos para el borde punteado, las etiquetas y la caja de cambios.
- **Vault**: Flujo Proponer intercambio (o un flujo nuevo), las notas de las tablas nuevas, Pendientes y la Bitácora.

## Cómo se prueba

Claude compila y prueba las pantallas con datos de muestra en una página aparte, sin tocar la base de Rafael. La prueba de punta a punta con la base la hace Rafael después de actualizar la suya, siguiendo esta lista:
- Agregar 1 y 2 artículos y ver el aviso que le llega al otro.
- Pedir un artículo, aceptarlo y rechazarlo.
- Pedir sacar un artículo, aceptarlo y rechazarlo.
- Cancelar un pedido.
- Tope de 3 artículos y mínimo de 1.
- Hacer cambios en un intercambio Aceptado y ver que se rechacen las otras propuestas pendientes.
- Ver que no deje cambiar nada en un intercambio terminado.
- Ver que Aceptar intercambio esté desactivado mientras haya cambios sin responder.

## Lo que queda para quien programa

Los nombres internos de métodos, clases CSS y ViewBag, el orden exacto de los elementos dentro de cada tarjeta y el texto final de los mails, siempre que sigan el tono de los que ya existen.

## Decisiones al programar (14/11)

- No hay worktree ni commits: todo quedó sin commitear en la rama `multiples`, para que lo commitee Rafael.
- No hay tests automáticos porque el proyecto no tiene proyecto de tests ni base de prueba. Se verificó con `dotnet build`, comparando los scripts lote por lote y probando la pantalla en una página aparte, en compu y en celular.
- Cada operación bloquea primero la fila del intercambio (`UPDLOCK, HOLDLOCK`) y vuelve a revisar todo adentro del SQL. Así, dos cambios al mismo tiempo no pasan el tope de 3 y no hay deadlocks entre ellos. También hay un índice `IX_CambiosIntercambios_IdIntercambio (IdIntercambio, IdEstado)`.
- Agregar varios artículos es todo o nada: si alguno ya no se puede agregar, no se agrega ninguno.
- Los textos que no estaban en el plan:
  - "Solo podés pedir artículos de {Otro}."
  - "Solo podés sacar artículos tuyos que estén en el intercambio."
  - "Ese artículo ya tiene un intercambio aceptado. Elegí otro."
  - "Ese cambio ya no está pendiente."
  - "Ese pedido ya no está pendiente."
  - "{Artículo} ya tiene otro intercambio aceptado, así que no se puede sumar. Tocá No para cerrar el pedido."
- Aceptar y Marcar como realizado revisan antes los cambios pendientes, así el mensaje dice el motivo. El SQL igual lo vuelve a controlar.
- En la pantalla:
  - Las acciones (Sacar, Deshacer, Cancelar pedido) van debajo del texto de cada artículo.
  - Con menos de 1200 px de ancho, los dos paneles se ponen uno abajo del otro.
  - En la versión de seguimiento, la caja de cambios va dentro de la columna de la tarjeta.
- `articulo.js` maneja el contador de cualquier pop up con `data-proponer`, tanto el de Proponer como el de Agregar.
- Los formularios de Sacar y Deshacer usan `<!form>` + `@Html.AntiForgeryToken()`, porque dentro de las funciones locales de Razor no andan los tag helpers.

## Detalles que quedaron sin hacer

- Si agregar un artículo a un intercambio Aceptado rechaza otras propuestas, a quien lo agregó no se le avisa cuántas fueron. A quienes las habían hecho sí les llega la notificación.
- "{Otro} cambió el intercambio mientras lo mirabas" nombra al otro aunque el cambio nuevo lo hayas hecho vos en otra pestaña.
- Cuando se agregan varios artículos, la notificación los une como "A, B", sin "y", y en el mail van sin comillas.
- `Fecha` sale del reloj de la app y `FechaRespuesta` del de la base. En la misma compu coinciden.

