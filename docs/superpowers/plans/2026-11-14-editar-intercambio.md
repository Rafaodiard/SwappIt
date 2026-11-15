# Agregar, sacar y pedir artículos en un intercambio: plan de implementación

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Que en Ver intercambio cada usuario pueda agregar sus artículos (al instante), pedir sacar los suyos y pedir artículos del otro (los dos con aceptación del otro), mientras el intercambio está Pendiente o Aceptado.

**Architecture:** La tabla nueva `CambiosIntercambios` guarda cada cambio, y `ArticulosIntercambios` sigue guardando solo lo confirmado. Todo el SQL va en `Models/BD.cs` con Dapper y transacciones, como `ProponerIntercambio` y `CambiarEstadoIntercambio`. El controller valida, arma los mensajes y manda los mails con `EmailService`. La vista usa ViewBag y partials que leen ViewBag (como `_FilaIntercambio`).

**Tech Stack:** ASP.NET Core MVC (.NET 9), Dapper, SQL Server, Bootstrap 5 + Bootstrap Icons, JS sin librerías.

**Spec:** `docs/superpowers/specs/2026-11-14-editar-intercambio-design.md`

## Global Constraints

- Nunca ejecutar nada sobre la base de Rafael. No hay scripts de migración. Los cambios de base van iguales en `SQLSwappit.sql` (UTF-16 LE con BOM: editar con un paso de iconv de ida y vuelta), `SQLSwappit_CualquierCompu.sql`, `BaseDatos/Estructura.sql`, `BaseDatos/Datos.sql` y `BaseDatos/StoredProcedures.sql`. No se agregan archivos a `BaseDatos/`.
- No hacer commit ni push: commitea Rafael. Se trabaja en la rama `multiples`, en `C:\Users\rafae\Proyectos\SwappIt`, sin worktree.
- Datos del controller a la vista siempre con `ViewBag`, sin `@model` ni `asp-for`. Links con `@Url.Action`. Casi sin comentarios en el código.
- No hay dependencias nuevas ni SP nuevos.
- Estados en los que se puede cambiar el intercambio: `EstadosIntercambios.Pendiente` y `EstadosIntercambios.Aceptado`. Máximo por lado: `Intercambios.MaxArticulosOfrecidos` (3). Mínimo por lado: 1.
- Textos en español rioplatense, con el mismo tono que los mensajes que ya existen.
- No hay proyecto de tests ni base para probar. La verificación es `dotnet build` sin errores ni warnings nuevos, el control de que los scripts son iguales (Task 1) y la lista de prueba manual de la spec, que corre Rafael.

## Review Focus

1. **Doble envío o dos pestañas:** se aprieta dos veces "Sí, sumarla" o se responde el mismo cambio desde dos pestañas. Esperado: el segundo intento no hace nada y muestra el error genérico, sin duplicar filas. Lo cubre el `WHERE c.IdEstado = Pendiente` del UPDATE en Task 3 (verificación 3.5).
2. **Carrera con el tope de 3:** dos pedidos pendientes sobre el mismo lado y los dos se aceptan. Esperado: el que pasaría de 3 no se acepta. Se vuelve a contar dentro de la transacción de `ResponderCambio` (verificación 3.5).
3. **Artículo comprometido mientras el pedido espera:** el artículo pedido queda en otro intercambio aceptado antes de que se responda el pedido. Esperado: aceptar falla con el error genérico. Se vuelve a revisar `ArticuloDisponible` al aceptar (verificación 3.5).
4. **Ids de otro intercambio en el form:** un POST con `idCambio` de un intercambio ajeno, o con un `idArticulo` que no es de ninguno de los dos. Esperado: no hace nada. Todas las consultas filtran por participante y dueño (verificación 3.5).
5. **Intercambio terminado con la página abierta:** se cancela o se marca realizado y el otro aprieta un botón de cambio. Esperado: el error "Este intercambio ya terminó: no se puede cambiar." Lo cubre el filtro de estado en cada método de BD (verificación 3.5).

---

### Task 1: Base de datos en los 5 scripts

**Files:**
- Modify: `BaseDatos/Estructura.sql` (tablas nuevas después de `ArticulosIntercambios`, columna en `Notificaciones`, FKs al final con las demás)
- Modify: `BaseDatos/Datos.sql` (bloque `TipoNotificaciones` y bloque nuevo `TipoCambios`)
- Modify: `SQLSwappit_CualquierCompu.sql` y `SQLSwappit.sql`, con los mismos lotes en los mismos lugares
- `BaseDatos/StoredProcedures.sql`: no cambia

**Interfaces:**
- Produces: las tablas `TipoCambios(Id, Nombre)` y `CambiosIntercambios(Id, IdIntercambio, IdArticulo, IdUsuario, IdTipoCambio, IdEstado, Fecha, FechaRespuesta)`, la columna `Notificaciones.IdCambio int NULL` y las filas de `TipoNotificaciones` 6–10 y de `TipoCambios` 1–3.

- [ ] **1.1** En `Estructura.sql`, `CREATE TABLE [dbo].[TipoCambios]` con `[Id] int IDENTITY(1,1) NOT NULL` PK `PK_TipoCambios` y `[Nombre] varchar(50) NOT NULL`, con el mismo formato que `TipoNotificaciones`.
- [ ] **1.2** `CREATE TABLE [dbo].[CambiosIntercambios]` con las columnas de la spec (`Fecha datetime NOT NULL`, `FechaRespuesta datetime NULL`), PK `PK_CambiosIntercambios`. FKs `FK_CambiosIntercambios_Intercambios` (IdIntercambio → Intercambios.IdIntercambios), `FK_CambiosIntercambios_Articulos` (IdArticulo → Articulos.IdArticulos), `FK_CambiosIntercambios_Usuarios` (IdUsuario → Usuarios.IdUsuarios), `FK_CambiosIntercambios_TipoCambios` (IdTipoCambio → TipoCambios.Id) y `FK_CambiosIntercambios_EstadosIntercambios` (IdEstado → EstadosIntercambios.IdEstadosIntercambios). Cada una con `WITH CHECK ADD` + `CHECK CONSTRAINT`, como las demás.
- [ ] **1.3** Columna `[IdCambio] [int] NULL` en `CREATE TABLE [dbo].[Notificaciones]`, después de `[Fecha]`, y la FK `FK_Notificaciones_CambiosIntercambios`.
- [ ] **1.4** En `Datos.sql`, dentro del bloque `IDENTITY_INSERT [dbo].[TipoNotificaciones]`: (6, N'Artículo agregado'), (7, N'Pedido de artículo'), (8, N'Pedido para sacar'), (9, N'Cambio aceptado'), (10, N'Cambio rechazado'). Bloque nuevo `IDENTITY_INSERT [dbo].[TipoCambios]` con (1, N'Agregar'), (2, N'Sacar'), (3, N'Pedir'). Los INSERT de `Notificaciones` que ya existen siguen andando porque no nombran `IdCambio`. Revisá que listen sus columnas, y si alguno usa `VALUES` sin lista de columnas, agregale `NULL`.
- [ ] **1.5** Copiá los mismos lotes a `SQLSwappit_CualquierCompu.sql` y a `SQLSwappit.sql`. Este último se pasa a UTF-8 con `iconv -f UTF-16LE -t UTF-8`, se edita y se vuelve con `iconv -f UTF-8 -t UTF-16LE`, conservando el BOM `FF FE`.
- [ ] **1.6 Verificación:** con `python -I <scratchpad>/tools/cmp.py C:/Users/rafae/Proyectos/SwappIt` (compara lote por lote) tienen que aparecer solo las diferencias que había antes: encabezados, `CREATE DATABASE` y el control del usuario `alumno`. Además, `head -c 2 SQLSwappit.sql | od -c` tiene que dar `377 376`.

### Task 2: Modelos

**Files:**
- Create: `Models/TipoCambios.cs`, `Models/ViewModels/CambioIntercambioViewModel.cs`
- Modify: `Models/TipoNotificaciones.cs`, `Models/NotificacionCreada.cs`, `Models/ViewModels/NotificacionViewModel.cs`, `Models/DatosMailNotificacion.cs`

**Interfaces:**
- Produces:
  - `TipoCambios`: constantes `Agregar = "Agregar"`, `Sacar = "Sacar"` y `Pedir = "Pedir"`; propiedades `Id` y `Nombre`.
  - `TipoNotificaciones`: `ArticuloAgregado = "Artículo agregado"`, `PedidoArticulo = "Pedido de artículo"`, `PedidoSacar = "Pedido para sacar"`, `CambioAceptado = "Cambio aceptado"` y `CambioRechazado = "Cambio rechazado"`.
  - `record NotificacionCreada(int IdUsuario, int IdIntercambio, string Tipo, int? IdCambio = null)`.
  - `CambioIntercambioViewModel`: `int Id`, `int IdArticulo`, `string ArticuloNombre`, `string? ArticuloImagen`, `string ArticuloEstado`, `int IdDuenoArticulo`, `int IdUsuario` (quién lo hizo), `string? UsuarioNombre`, `string Tipo`, `string Estado`, `DateTime Fecha`, `DateTime? FechaRespuesta`, y `bool Vigente` (si el intercambio está Pendiente o Aceptado).
  - `NotificacionViewModel` suma `string? CambioTipo` y `string? CambioArticulos` (uno o varios nombres, separados por ", ").
  - `DatosMailNotificacion` suma las mismas dos propiedades, `CambioTipo` y `CambioArticulos`.

- [ ] **2.1** Creá y modificá los archivos con exactamente esas firmas.
- [ ] **2.2 Verificación:** `dotnet build` da 0 errores. `NotificacionCreada` se crea en 3 lugares con 3 argumentos y tiene que seguir compilando sin cambios gracias al valor por defecto.

### Task 3: BD.cs

**Files:**
- Modify: `Models/BD.cs` (cerca de `ProponerIntercambio` / `CambiarEstadoIntercambio` / `CrearNotificacion` / `GetNotificaciones` / `GetDatosMailNotificacion`)

**Interfaces:**
- Consumes: Task 1 (tablas) y Task 2 (tipos).
- Produces:
  - `List<CambioIntercambioViewModel> GetCambiosIntercambio(int idIntercambio, int idUsuario)`: todos los cambios del intercambio, si el usuario es parte, ordenados por `Fecha DESC, Id DESC`.
  - `int GetUltimoCambio(int idIntercambio)`: el `MAX(Id)`, o 0.
  - `int AgregarArticulos(int idIntercambio, int idUsuario, IReadOnlyCollection<int> idsArticulos, List<NotificacionCreada>? creadas = null)`: devuelve cuántos agregó.
  - `bool PedirArticulo(int idIntercambio, int idUsuario, int idArticulo, List<NotificacionCreada>? creadas = null)`
  - `bool PedirSacarArticulo(int idIntercambio, int idUsuario, int idArticulo, List<NotificacionCreada>? creadas = null)`
  - `bool ResponderCambio(int idCambio, int idUsuario, bool aceptar, List<NotificacionCreada>? creadas = null)`
  - `bool CancelarCambio(int idCambio, int idUsuario)`
  - `CambiarEstadoIntercambio(...)` suma al final `int? ultimoCambioVisto = null`.
  - `GetDatosMailNotificacion(int idUsuario, int idIntercambio, int? idCambio = null)`

Reglas que tiene que cumplir el SQL de cada método, adentro de su transacción. Repiten lo que controla el controller, para cubrir las carreras.
- [ ] **3.1** Los cuatro métodos que escriben solo actúan si el intercambio está en Pendiente o Aceptado y el usuario es `IdUsuarios1` o `IdUsuarios2`. "Pendientes del lado X" = cambios `Pendiente` de tipo `Pedir` sobre artículos de X.
  - `AgregarArticulos`: inserta en `ArticulosIntercambios` los artículos del usuario que no están en el intercambio, que no tienen un cambio pendiente ahí y que cumplen `ArticuloDisponible`. Lo hace solo si `confirmados del lado + pedidos pendientes del lado + nuevos <= 3`. Por cada uno inserta un cambio `Agregar` / `Aceptado` con la **misma** `Fecha` (una variable `@ahora` de C#). Crea **una** notificación `ArticuloAgregado` para el otro, con `IdCambio` = el primero. Si el intercambio está Aceptado, llama a `RechazarPendientesDeArticulos`.
  - `PedirArticulo`: el artículo es del otro, no está en el intercambio, no tiene un cambio pendiente, cumple `ArticuloDisponible`, y `confirmados + pendientes del lado del otro < 3`. Inserta `Pedir` / `Pendiente` y notifica `PedidoArticulo` al dueño con `IdCambio`.
  - `PedirSacarArticulo`: el artículo está en el intercambio, es del usuario y no tiene un cambio pendiente, y `confirmados del lado − pedidos de sacar pendientes del lado >= 2`. Inserta `Sacar` / `Pendiente` y notifica `PedidoSacar` al otro.
  - `ResponderCambio`: el cambio está `Pendiente`, su intercambio está vigente y `IdUsuario` del cambio es distinto del usuario que responde, que es parte del intercambio. Si se acepta un `Pedir`, se vuelven a revisar el tope y `ArticuloDisponible`, se inserta en `ArticulosIntercambios`, y si el intercambio está Aceptado, se llama a `RechazarPendientesDeArticulos`. Si se acepta un `Sacar`, se vuelve a revisar que quede al menos 1 y se borra la fila. Después, el `UPDATE ... SET IdEstado, FechaRespuesta = GETDATE() WHERE Id = @pId AND IdEstado = (Pendiente)`, y si afectó 0 filas, rollback y `false`. Notifica `CambioAceptado` o `CambioRechazado` a quien hizo el cambio, con `IdCambio`.
  - `CancelarCambio`: solo quien lo hizo, el cambio en `Pendiente` y el intercambio vigente. Pasa a `Cancelado` sin notificación.
- [ ] **3.2** `CambiarEstadoIntercambio`, agregando al `WHERE` del UPDATE:
  - Si `@pNuevo = Realizado`: `NOT EXISTS` de cambios `Pendiente` en el intercambio.
  - Si `@pNuevo = Aceptado`: `NOT EXISTS` de cambios `Pendiente` hechos por el otro (los que le toca responder a `@pIdUsuario`), y `NOT EXISTS` de cambios con `Id > ISNULL(@pUltimoCambio, 0)`.
- [ ] **3.3** `CrearNotificacion` suma el parámetro `int? idCambio = null`: lo guarda en `Notificaciones.IdCambio` y lo pasa a `NotificacionCreada`.
- [ ] **3.4** `GetNotificaciones` y `GetDatosMailNotificacion` suman `LEFT JOIN` a `CambiosIntercambios` / `TipoCambios` y devuelven `CambioTipo` y `CambioArticulos`. Para `ArticuloAgregado`, `CambioArticulos` es `STRING_AGG` de los nombres de los cambios con el mismo `IdIntercambio`, `IdUsuario` y `Fecha` que el cambio de la notificación. El nivel de compatibilidad 140 ya tiene `STRING_AGG`.
- [ ] **3.5 Verificación:** `dotnet build` con 0 errores. Después hay que leer cada método nuevo contra los 5 puntos de Review Focus y anotar al lado de cada uno qué condición del SQL lo cubre. Si alguno no está cubierto, se corrige antes de seguir.

### Task 4: IntercambioController

**Files:**
- Modify: `Controllers/IntercambioController.cs`

**Interfaces:**
- Consumes: los métodos de Task 3.
- Produces, para la vista:
  - `ViewBag.cambios` (`List<CambioIntercambioViewModel>`)
  - `ViewBag.paraAgregar` y `ViewBag.paraPedir` (`List<ArticuloCardViewModel>`)
  - `ViewBag.ultimoCambio` (int)
  - `ViewBag.puedeCambiar` (bool)
  - `ViewBag.lugarMio` y `ViewBag.lugarSuyo` (int, lugares libres hasta 3)
  - `ViewBag.tengoPorResponder` (bool)
  - `ViewBag.hayPendientes` (bool)
- Acciones POST con `[ValidateAntiForgeryToken]`, todas con `RedirectToAction("Detalle", new { id })`: `AgregarArticulos(int id, int[]? idsArticulos)`, `PedirArticulo(int id, int idArticulo)`, `SacarArticulo(int id, int idArticulo)`, `ResponderCambio(int id, int idCambio, bool aceptar)`, `CancelarCambio(int id, int idCambio)`. `Aceptar(int id)` pasa a `Aceptar(int id, int ultimoCambio)`.

- [ ] **4.1** En `Detalle`, si el intercambio está vigente:
  - `paraAgregar` = `BD.GetArticulosCatalogo(idUsuario: usuarioId)`, sin los que ya están en el intercambio ni los que tienen un cambio pendiente.
  - `paraPedir` = lo mismo, con `OtroIdUsuario`.
  - `lugarMio` = 3 − confirmados míos − pedidos pendientes sobre los míos, y `lugarSuyo` se calcula igual.

  `cambios` y `ultimoCambio` se cargan en todos los estados.
- [ ] **4.2** Antes de llamar a BD, las acciones validan con estos textos exactos y los ponen en `TempData["ErrorIntercambio"]`:
  - "Este intercambio ya terminó: no se puede cambiar."
  - "Elegí al menos uno de tus artículos para agregar."
  - "Cada lado puede tener hasta 3 artículos."
  - "Solo podés agregar artículos tuyos."
  - "Uno de los artículos ya tiene un intercambio aceptado. Elegí otro."
  - "Ese artículo ya está en el intercambio o tiene un cambio pendiente."
  - "No podés sacar tu único artículo del intercambio."

  Si BD devuelve `false` o `0`: "No se pudo hacer el cambio. Puede que el intercambio haya cambiado: revisalo y probá de nuevo." Si hay una `SqlException`: log + "No pudimos guardar el cambio. Probá de nuevo en un rato."
- [ ] **4.3** Mensajes de éxito en `TempData["MensajeIntercambio"]`:
  - "Sumaste {nombres}. A {OtroNombre} le llegó un aviso."
  - "Le pediste {nombre} a {OtroNombre}. Se suma cuando lo acepte."
  - "Le pediste a {OtroNombre} sacar {nombre}. Se saca cuando lo acepte."
  - "Aceptaste el cambio."
  - "Rechazaste el cambio. Le avisamos a {OtroNombre}."
  - "Cancelaste el pedido."

  Después de cada acción con notificaciones: `_emailService.EnviarNotificaciones(creadas, Url)`.
- [ ] **4.4** `Aceptar`: si `BD.GetUltimoCambio(id) > ultimoCambio`, pone "{OtroNombre} cambió el intercambio mientras lo mirabas. Revisalo y aceptá de nuevo." y vuelve a la página. Si no, sigue con `CambiarEstado` pasando `ultimoCambio`. `CambiarEstado` y `BD.CambiarEstadoIntercambio` reciben el parámetro opcional, y `MarcarRealizado` no cambia de firma.
- [ ] **4.5 Verificación:** `dotnet build` con 0 errores.

### Task 5: Notificaciones y mails

**Files:**
- Modify: `Views/Notificaciones/_Lista.cshtml`, `Services/EmailService.cs`

**Interfaces:**
- Consumes: `NotificacionViewModel.CambioTipo`/`CambioArticulos`, `DatosMailNotificacion.CambioTipo`/`CambioArticulos` y `NotificacionCreada.IdCambio`.

- [ ] **5.1** `_Lista.cshtml`:
  - Íconos: `bi-plus-circle` (agregado), `bi-question-circle` (pedido de artículo), `bi-dash-circle` (pedido para sacar), `bi-check-lg` (aceptado) y `bi-x-lg` (rechazado, con el mismo estilo de rechazo que `PropuestaRechazada`).
  - Textos de la tabla de la spec. En aceptado y rechazado se usa `CambioTipo` para elegir "aceptó sumar X" o "aceptó que saques X".
  - El link es "Ver intercambio".
- [ ] **5.2** `EmailService`: `EnviarAsync` le pasa `notificacion.IdCambio` a `GetDatosMailNotificacion`, y `Textos` suma los 5 casos con el mismo formato (asunto, título, texto y botón). El botón es "Responder" para los dos pedidos y "Ver intercambio" para el resto.
- [ ] **5.3 Verificación:** `dotnet build` con 0 errores. Con SMTP sin configurar los mails quedan como `.eml` en `MailsPrueba/`, y eso lo revisa Rafael en la prueba manual.

### Task 6: Pantalla de Ver intercambio

**Files:**
- Create: `Views/Intercambio/_CajaCambios.cshtml`, `Views/Intercambio/_HistorialCambios.cshtml`, `Views/Intercambio/_ModalesCambios.cshtml` (los pop ups de agregar y de pedir)
- Modify: `Views/Intercambio/Detalle.cshtml`, `wwwroot/css/site.css`, `wwwroot/js/articulo.js` (se renombra a un módulo compartido solo si hace falta, ver 6.4)

**Interfaces:**
- Consumes: el ViewBag de Task 4 y las acciones POST de Task 4.

- [ ] **6.1** `_CajaCambios`: solo aparece si `tengoPorResponder`. El título es "{OtroNombre} te pide N cambio(s)". Cada fila tiene la foto chica, la frase ("{Otro} te pidió tu X." / "{Otro} quiere sacar su X del intercambio."), la aclaración ("Si aceptás, se suma a lo que das." / "Si aceptás, ya no lo recibís.") y dos forms POST a `ResponderCambio` con `aceptar=false` (**No**) y `aceptar=true` (**Sí, sumarla** / **Sí, sacarla**). Va entre el `header` y la tarjeta principal, en las dos versiones de la página.
- [ ] **6.2** `PanelArticulos` en `Detalle.cshtml` recibe también los cambios y muestra por artículo:
  - "Lo agregó {Otro} · dd/MM" o "Lo agregaste vos" (cambio `Agregar` aceptado).
  - Si está esperando al otro: borde punteado, la etiqueta "Esperando a {Otro}" y un form a `CancelarCambio` (**Deshacer** para sacar, **Cancelar pedido** para pedir).
  - Si está esperando tu respuesta: borde punteado y la etiqueta "Te toca responder".
  - El botón **Sacar** (form POST a `SacarArticulo`) va en los míos confirmados sin cambio pendiente, si sacarlo no deja el lado vacío.

  Los artículos pedidos y todavía no aceptados se muestran como filas punteadas en el lado del dueño. Si `puedeCambiar`: al final del lado mío va "+ Agregar de tus artículos" (si `lugarMio > 0` y `paraAgregar` tiene algo), y al final del suyo, "+ Pedirle un artículo a {Otro}" (si `lugarSuyo > 0` y `paraPedir` tiene algo). Hoy el panel tiene una versión de 1 artículo y otra de varios. Si hay cambios o botones, se usa siempre la de varios, para que todo entre en la misma lista.
- [ ] **6.3** `_ModalesCambios`:
  - Pop up "Agregar de tus artículos": casillas `name="idsArticulos"`, `data-max-ofrecidos="@lugarMio"`, el contador y el texto "Se suman enseguida. A {Otro} le llega un aviso."
  - Pop up "Pedirle un artículo a {Otro}": radios `name="idArticulo"` y el texto "{Otro} tiene que aceptarlo para que se sume."

  Los dos reusan las clases de las opciones del pop up de Proponer (`sw-opcion-articulo`).
- [ ] **6.4** El contador: el bloque de `articulo.js` que maneja `[data-proponer]` pasa a buscar todos los `form[data-proponer]` de la página (un `forEach` en vez de `querySelector`), y su texto usa `data-max-ofrecidos`. El pop up de agregar lleva `data-proponer`, y `Detalle.cshtml` de Intercambio suma `<script src="~/js/articulo.js" asp-append-version="true">`. Si el bloque de la galería de fotos sale enseguida cuando no encuentra la foto principal (ya lo hace), no molesta.
- [ ] **6.5** `_HistorialCambios`: aparece si `cambios` tiene algo. Lista "{Vos|Otro} agregó/pediste/quiere sacar/aceptó/rechazó X · hoy HH:mm | ayer HH:mm | dd/MM". Un pendiente de un intercambio terminado dice "sin respuesta". En la versión de seguimiento va en la columna derecha (`col-lg-4`, después de "Con quién"), y en "Recibiste una propuesta", debajo de la tarjeta.
- [ ] **6.6** Botones:
  - "Aceptar intercambio" queda `disabled` si `tengoPorResponder`, con el texto "Respondé los cambios de {Otro} antes de aceptar." Los dos forms de Aceptar (el directo y el del pop up de confirmar) mandan `<input type="hidden" name="ultimoCambio" value="@ultimoCambio">`.
  - "Marcar como realizado" queda `disabled` si `hayPendientes`, con el texto "Hay cambios sin responder. Respondelos o cancelalos antes de marcarlo como realizado."
- [ ] **6.7** `site.css`: los estilos `sw-cambio-pendiente` (borde `dashed`), `sw-cambio-etiqueta` (chip, con una variante de aviso en bordó `#6e2c3a` y otra informativa en azul petróleo `#0d596a`), `sw-caja-cambios` (borde izquierdo de aviso) y `sw-agregar-articulo` (botón punteado a todo el ancho). Usá las variables de color que ya tiene `site.css` si existen.
- [ ] **6.8 Verificación:** `dotnet build` con 0 errores. Después hay que copiar el HTML de la caja, de un panel con los 4 estados y del pop up de agregar a una página estática en el scratchpad, con `site.css` y `articulo.js`, y abrirla en el navegador integrado. Ahí se revisa: que el contador no deje marcar más de `lugarMio`, que en 375 px los paneles queden uno abajo del otro sin scroll horizontal, y que los botones desactivados muestren su texto.

### Task 7: Vault y cierre

**Files:**
- Modify: `Vault/Flujos/Flujo Proponer intercambio.md`, `Vault/Base de datos.md`, `Vault/Base de datos/Tablas/Tabla Notificaciones.md`, `Vault/Base de datos/Tablas/Tabla TipoNotificaciones.md`, `Vault/Pendientes y problemas.md`, `Vault/Memoria/Bitácora.md`
- Create: `Vault/Base de datos/Tablas/Tabla CambiosIntercambios.md`, `Vault/Base de datos/Tablas/Tabla TipoCambios.md`

- [ ] **7.1** Las notas siguen el formato de `Tabla ArticulosIntercambios.md`. El flujo suma la sección "Cambiar un intercambio" con las reglas de la spec. La Bitácora del 14/11 dice qué se hizo, que no se probó contra la base y que el grafo no se regeneró.
- [ ] **7.2 Verificación final:** `dotnet build` con 0 errores y 0 warnings nuevos, `git status` muestra solo los archivos de este plan (más los cambios de vault y BaseDatos que ya estaban), el control de scripts de 1.6 da igual y la lista de prueba manual de la spec queda para que la corra Rafael.
