---
tipo: general
tags:
  - tipo/general
---
# Pendientes y problemas

Lo que encontré leyendo el código de `main` (revisado el 30/10 sobre `f639baa`). Nada de esto se cambió: es para decidir qué hacer.

## Funcionalidades que todavía no existen
- **Favoritos**: no hay tabla y el corazón se sacó de la card y del header; [[favoritos.js]] quedó sin usar.
- **Reputación / calificaciones**: no hay tabla ni código.
- **Editar o borrar un artículo**: el botón "Editar artículo" está deshabilitado.
- **Artículos recomendados** del inicio ([[Vista Home-Inicio]]): por ahora son los últimos disponibles de los demás; no hay datos de gustos ni búsquedas para recomendar de verdad.
- **Select de orden en Buscar**: funciona (Para vos, Más populares, Más recientes y A - Z). Desde el 17/11 A - Z, populares y recientes los ordena [[SP GetArticulosCatalogo]]. El filtro de distancia y "Más cercanos" se sacaron el 30/10 porque no hay coordenadas en la base.
- **Ubicación del header** ("Palermo, CABA") es un texto fijo.
- **¿Olvidaste tu contraseña?** apunta a `#`.
- **Cambiar contraseña** existe (`/Account/CambiarContrasena`) pero ninguna vista tiene un link a esa pantalla.
- **Términos y privacidad** ([[Vista Home-Privacy]]) sigue con el texto en inglés de la plantilla.
- Marcar un intercambio como realizado no avisa a la otra persona (no hay tipo de notificación para eso).

Ya funcionan desde el 29/10: proponer, aceptar, rechazar, cancelar y marcar intercambios ([[Flujo Proponer intercambio]]), historial en Mi perfil, chat ([[Flujo Chat]]) y notificaciones ([[Flujo Notificaciones y favoritos]]).

## Stored procedures
- Desde el 17/11 todo el acceso a datos pasa por SP (devolución docente): no queda SQL en C#, ni SQL armado con texto, ni filtros con LINQ, y la app ya no cambia la estructura de la base (se sacó el `ALTER TABLE` que agregaba `FechaPublicacion`). Para probarlo hay que recrear la base desde los scripts.
- Sin uso desde la app: [[SP RegistrarArticulo]], [[SP RegistrarIntercambio]], [[SP RegistrarMensaje]] y los `Complejos_*` de la materia.
- [[SP RegistrarIntercambio]] solo inserta si `@fecha < GETDATE()` y busca artículos **por nombre** (puede haber nombres repetidos).
- [[SP RegistrarArticulo]] recibe `@descripcion varchar(50)` (la columna es 500) y no carga `Ubicacion` ni `IdCategoriaACambio`.
- "Para vos" se sigue calculando en C# ([[RecomendacionesController]], con bucles y sin LINQ) con las señales de [[SP GetSenalesGustos]], [[SP GetCategoriasDeUsuario]] y [[SP GetPopularidad]].

## Base de datos y datos
- Rafael actualiza su base por su cuenta con los scripts de creación (14/11, sin scripts de migración). Una base creada antes del 14/11 puede no tener: `Usuarios.Telefono` como `varchar(20)` (08/11, [[Telefonos]]), las 24 provincias sin repetir (08/11) y [[Tabla ArticulosIntercambios]] en lugar de `Intercambios.IdArticulos1` e `IdArticulos2` (11/11). Desde el 14/11 también hacen falta [[Tabla CambiosIntercambios]], [[Tabla TipoCambios]], `Notificaciones.IdCambio` y los tipos de notificación 6 a 10. La base de cada compu es aparte.
- Cambiar un intercambio (14/11) compila y la pantalla se probó en una página aparte, pero todavía no se probó contra una base de verdad: falta la lista de prueba de `ia/superpowers/specs/2026-11-14-editar-intercambio-design.md`.
- Desde el 08/11 el registro pide provincia y barrio (Figma no los tiene). Los usuarios que ya se registraron quedaron en Buenos Aires con el barrio vacío: lo corrigen en Editar perfil.
- `wwwroot/img/perfiles/` está en `.gitignore`, pero las filas de [[Tabla Imagenes]] con la foto de perfil viajan en los scripts: en otra compu la foto no existe y se ven las iniciales (ej. usuario 2).
- El comentario de [[PublicarController]] y [[PerfilController]] dice que `Imagenes.Ruta` es `varchar(50)`, pero ya es `varchar(100)`.

## Código
- Para decidir (08/11): elegir el barrio de una lista (tabla Barrios). Proponer varios artículos ya está hecho (11/11, [[Tabla ArticulosIntercambios]]).
- La connection string está fija en `ConexionBD.ConnectionString` ([[BD]]), con `localhost` y autenticación de Windows (Rafael eligió `localhost` como predeterminada el 17/11, igual que el `README.md`); con SQL Express hay que cambiarla a mano en ese único archivo (la de `.\SQLEXPRESS` está comentada).
- [[Intercambios]] (modelo) no tiene la columna `Ubicacion` que sí tiene la tabla.
- [[Usuarios]] ([[BD]].UpdateUsuario) actualiza también `Mail`, `Contraseña` y fecha de nacimiento con lo que traía el objeto: funciona porque [[PerfilController]] primero lee el usuario completo.
- `bin/` y `obj/` están en git aunque el `.gitignore` los excluye (152 archivos): conviene `git rm -r --cached bin obj`.
- El guardado de fotos está repetido en [[PerfilController]] y [[PublicarController]].
- `_Layout.cshtml.css` es el CSS de la plantilla de Visual Studio y no se usa.

## Mails (revisado el 08/11)
- La contraseña de aplicación de Gmail está commiteada en `appsettings.Development.json` (y en el historial). Conviene generar una nueva y pasarla a `dotnet user-secrets` en cada compu ([[EmailService]]).
- Si el envío sale bien, la consola no muestra nada; si el mail del usuario está mal escrito, Gmail acepta el envío y el rebote llega a swappit9@gmail.com, así que desde la app no se nota.
- El perfil no deja cambiar el mail: una cuenta registrada con un mail mal escrito no recibe ningún aviso.

## Carpeta local vs GitHub
El 30/10 la carpeta `C:\Users\rafae\Proyectos\swappit` estaba en `cc3a330`, 12 commits atrás de GitHub; se hizo `git pull` y quedó en `f639baa` ("pantalla incio"). Diferencias locales sin commit: el rediseño del inicio ([[Vista Home-Inicio]], [[HomeController]], [[site.css]]), esta vault actualizada, la copia `ia/Vault-local/` (la vault vieja de la compu, sin nada que no esté acá) y archivos de `bin/` y `obj/` de compilar. Los archivos generados de antes del pull quedaron en un `git stash`.
