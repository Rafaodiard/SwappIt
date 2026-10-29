---
tipo: general
tags:
  - tipo/general
---
# Pendientes y problemas

Lo que encontré leyendo el código de `main` (`cc3a330`). Nada de esto se cambió: es para decidir qué hacer.

## Funcionalidades que todavía no existen
- **Proponer intercambio** no se guarda: el botón "Enviar propuesta" está deshabilitado y el form tiene `onsubmit="return false"` ([[Vista Articulos-Detalle]], [[Flujo Proponer intercambio]]).
- **Aceptar / rechazar / seguir intercambios**: no hay código. [[Tabla Intercambios]] existe pero no tiene datos de prueba ni métodos en [[BD]].
- **Chat**: [[Vista Chat-Index]] tiene datos de ejemplo escritos en el HTML (Juan Pérez, "Silla ⇄ Lámpara"); [[ChatController]] no lee nada. [[Tabla Mensajes]] sin uso.
- **Historial de intercambios** en [[Vista Perfil-Index]]: es un ejemplo fijo ("Silla", "@juanp").
- **Favoritos**: el corazón solo cambia de ícono ([[favoritos.js]]); no hay tabla.
- **Notificaciones**: solo el estado vacío ([[Vista _PopupNotificaciones]]); no hay tabla.
- **Reputación / calificaciones**: no hay tabla ni código.
- **Editar o borrar un artículo**: el botón "Editar artículo" está deshabilitado.
- **Filtro de distancia y orden "Más cercanos"**: no hacen nada (no hay coordenadas en la base). El select de orden tampoco cambia el orden: siempre es `ORDER BY IdArticulos DESC`.
- **Ubicación del header** ("Palermo, CABA") es un texto fijo.
- **¿Olvidaste tu contraseña?** apunta a `#`.
- **Cambiar contraseña** existe (`/Account/CambiarContrasena`) pero ninguna vista tiene un link a esa pantalla.
- **Términos y privacidad** ([[Vista Home-Privacy]]) sigue con el texto en inglés de la plantilla.

## Stored procedures (commit de Martina del 28/10)
- [[BD]] no llama a ningún SP: todo es SQL inline. Los SP nuevos de [[Script SQLSwappit.sql]] por ahora son duplicados sin uso.
- Cinco SP están vacíos (plantilla de SSMS sin código): [[SP GetArticulosCatalogo]], [[SP GetFiltroCategorias]], [[SP GetFiltroEstados]], [[SP PublicarArticulo]], [[SP UpdateUsuario]].
- [[SP ActualizarContrasena]] recibe `@contrasenaHash varchar(50)`, pero el hash mide 84 caracteres: **lo cortaría** y nadie podría volver a entrar. Tiene que ser `varchar(100)` como la columna.
- [[SP GuardarFotoUsuario]] recibe `@ruta varchar(50)` (la columna es `varchar(100)`) y el parámetro se llama `@idUauario` (typo).
- Los SP nuevos no están en [[Script StoredProcedures.sql]] ni en [[Script SQLSwappit_CualquierCompu.sql]] (esos tienen solo los 4 `Registrar*`).
- [[SP RegistrarUsuario]] no inserta `Edad` (columna NOT NULL), así que siempre falla; además rechaza teléfonos repetidos (los usuarios de prueba con teléfono 0 chocan).
- [[SP RegistrarIntercambio]] solo inserta si `@fecha < GETDATE()` y busca artículos **por nombre** (puede haber nombres repetidos).
- [[SP RegistrarArticulo]] recibe `@descripcion varchar(50)` (la columna es 500) y no carga `Ubicacion` ni `ACambio`.

## Base de datos y datos
- `Usuarios.Telefono` es `int`: un número completo (+54 9 11 …) no entra y se guarda 0 ([[Telefonos]]).
- `Mensajes.Texto` es `varchar(50)`: mensajes muy cortos. `FechaEnviado` es `date` (sin hora).
- [[Script Provincias.sql]] vuelve a insertar las 24 provincias: en los datos hay 48 filas (25–48 repiten 1–24).
- Los usuarios nuevos se registran con `IdProvincias = 1` y `Barrio` vacío porque el formulario de Figma no los pide ([[RegistroViewModel]]).
- El comentario de [[PublicarController]] y [[PerfilController]] dice que `Imagenes.Ruta` es `varchar(50)`, pero ya es `varchar(100)`.

## Código
- La connection string está fija en [[BD]] (`Server=localhost`, autenticación de Windows); en otra compu hay que cambiarla a mano (hay una alternativa `.\SQLEXPRESS` comentada).
- [[Intercambios]] (modelo) no tiene la columna `Ubicacion` que sí tiene la tabla.
- [[Usuarios]] ([[BD]].UpdateUsuario) actualiza también `Mail`, `Contraseña` y fecha de nacimiento con lo que traía el objeto: funciona porque [[PerfilController]] primero lee el usuario completo.
- `bin/` y `obj/` están en git aunque el `.gitignore` los excluye (152 archivos): conviene `git rm -r --cached bin obj`.
- El guardado de fotos está repetido en [[PerfilController]] y [[PublicarController]].
- `_Layout.cshtml.css` es el CSS de la plantilla de Visual Studio y no se usa.

## Carpeta local vs GitHub
La carpeta `C:\Users\rafae\Proyectos\swappit` está en el mismo commit que GitHub (`cc3a330`): **no hace falta `git pull`**. Diferencias locales: los `.js` aparecen modificados solo por fin de línea (CRLF), archivos de `obj/` de compilar, y la carpeta `graphify-out/` (versionada) está borrada en la compu.
