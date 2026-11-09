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
- **Select de orden en Buscar** ("Más recientes / A - Z"): no cambia nada, el orden siempre es `ORDER BY IdArticulos DESC` (coincide con "Más recientes"; "A - Z" no hace nada). El filtro de distancia y "Más cercanos" se sacaron el 30/10 porque no hay coordenadas en la base.
- **Ubicación del header** ("Palermo, CABA") es un texto fijo.
- **¿Olvidaste tu contraseña?** apunta a `#`.
- **Cambiar contraseña** existe (`/Account/CambiarContrasena`) pero ninguna vista tiene un link a esa pantalla.
- **Términos y privacidad** ([[Vista Home-Privacy]]) sigue con el texto en inglés de la plantilla.
- Marcar un intercambio como realizado no avisa a la otra persona (no hay tipo de notificación para eso).

Ya funcionan desde el 29/10: proponer, aceptar, rechazar, cancelar y marcar intercambios ([[Flujo Proponer intercambio]]), historial en Mi perfil, chat ([[Flujo Chat]]) y notificaciones ([[Flujo Notificaciones y favoritos]]).

## Stored procedures
- [[BD]] no llama a ningún SP: todo es SQL inline. Los SP de [[Script SQLSwappit.sql]] son duplicados sin uso, y los de intercambios, notificaciones y chat ni siquiera existen como SP.
- El 29/10 ("scripts y sp arreglados") se completaron los SP vacíos y se corrigieron [[SP ActualizarContrasena]] y [[SP GuardarFotoUsuario]] (varchar(100)). Ahora los SP nuevos también están en [[Script StoredProcedures.sql]] y [[Script SQLSwappit_CualquierCompu.sql]].
- [[SP GetArticulosCatalogo]], [[SP GetFiltroCategorias]] y [[SP GetFiltroEstados]] quedaron atrás de [[BD]]: no excluyen al usuario logueado ni ocultan los artículos comprometidos.
- [[SP RegistrarUsuario]] no inserta `Edad` (columna NOT NULL), así que siempre falla; además rechaza teléfonos repetidos (los usuarios sin teléfono, guardados como vacío, chocan).
- [[SP RegistrarIntercambio]] solo inserta si `@fecha < GETDATE()` y busca artículos **por nombre** (puede haber nombres repetidos).
- [[SP RegistrarArticulo]] recibe `@descripcion varchar(50)` (la columna es 500) y no carga `Ubicacion` ni `ACambio`.

## Base de datos y datos
- `Usuarios.Telefono` pasó de `int` a `varchar(20)` el 08/11 (sin commit). En una base que ya existe hay que correr `ALTER TABLE Usuarios ALTER COLUMN Telefono varchar(20) NOT NULL` y volver a crear [[SP UpdateUsuario]] y [[SP RegistrarUsuario]] ([[Telefonos]]).
- En una base creada antes del 29/10 hay que correr [[Script Notificaciones.sql]], [[Script Chat.sql]] y [[Script Cancelado.sql]] (tablas de notificaciones, mensajes de 500 caracteres con hora y el estado Cancelado).
- Provincias repetidas (08/11): los scripts de creación ya traen 24. En una base que ya existe hay que correr [[Script ProvinciasDuplicadas.sql]] (pasa a los usuarios a la primera fila de su provincia y borra las repetidas).
- Desde el 08/11 el registro pide provincia y barrio (Figma no los tiene). Los usuarios que ya se registraron quedaron en Buenos Aires con el barrio vacío: lo corrigen en Editar perfil.
- `wwwroot/img/perfiles/` está en `.gitignore`, pero las filas de [[Tabla Imagenes]] con la foto de perfil viajan en los scripts: en otra compu la foto no existe y se ven las iniciales (ej. usuario 2).
- El comentario de [[PublicarController]] y [[PerfilController]] dice que `Imagenes.Ruta` es `varchar(50)`, pero ya es `varchar(100)`.

## Código
- "Mis artículos publicados" (Mi perfil) no muestra los artículos de intercambios aceptados, pero sí cuentan para el límite de 5 (08/11). Convendría mostrarlos con una marca "En intercambio".
- Para decidir (08/11): elegir el barrio de una lista (tabla Barrios) y proponer varios artículos en un intercambio (tabla nueva para los ofrecidos).
- La connection string está fija en [[BD]] (`Server=localhost`, autenticación de Windows); en otra compu hay que cambiarla a mano (hay una alternativa `.\SQLEXPRESS` comentada).
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
El 30/10 la carpeta `C:\Users\rafae\Proyectos\swappit` estaba en `cc3a330`, 12 commits atrás de GitHub; se hizo `git pull` y quedó en `f639baa` ("pantalla incio"). Diferencias locales sin commit: el rediseño del inicio ([[Vista Home-Inicio]], [[HomeController]], [[site.css]]), esta vault actualizada, la copia `Vault-local/` (la vault vieja de la compu, sin nada que no esté acá) y archivos de `bin/` y `obj/` de compilar. Los archivos generados de antes del pull quedaron en un `git stash`.
