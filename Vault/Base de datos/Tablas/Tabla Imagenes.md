---
tipo: tabla
comunidad: "Tablas y acceso a datos"
archivos:
  - "BaseDatos/Estructura.sql"
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
graphify_ids:
  - "basedatos_estructura_dbo_imagenes"
  - "sqlswappit_dbo_imagenes"
  - "sqlswappit_cualquiercompu_dbo_imagenes"
  - "imagenes"
tags:
  - tipo/tabla
  - comunidad/Tablas_y_acceso_a_datos
---
# Tabla Imagenes

`IdImagenes` (PK), `Ruta` varchar(100) NOT NULL, `IdArticulos` int NULL (FK → [[Tabla Articulos]]), `IdUsuarios` int NULL (FK → [[Tabla Usuarios]]).

- **Foto de perfil:** `IdUsuarios` con valor e `IdArticulos` NULL (una por usuario: [[BD]].GuardarFotoUsuario borra la anterior).
- **Foto de artículo:** `IdArticulos` con valor; la de menor id es la portada.

Datos: la foto de perfil del usuario 2 y 20 fotos de los artículos de prueba (`/img/ArticulosPrueba/Fotos swappit objetos/…`).

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- usa el tipo [[Tabla Articulos]] · `references` EXTRACTED
- usa el tipo [[Tabla Usuarios]] · `references` EXTRACTED

**Desde otras notas:**
- [[Script Estructura.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[BD.GetArticulosCatalogo()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetFotoUsuario()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetImagenesArticulo()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetIntercambio()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetIntercambios()]] lee de acá · `reads_from` EXTRACTED
- [[SP GetArticulosCatalogo]] lee de acá · `reads_from` EXTRACTED
- [[SP GetFotoUsuario]] lee de acá · `reads_from` EXTRACTED
- [[SP GetImagenesArticulo]] lee de acá · `reads_from` EXTRACTED
- [[BD.BorrarFotoUsuario()]] escribe acá · `writes_to` EXTRACTED
- [[BD.GuardarFotoUsuario()]] escribe acá · `writes_to` EXTRACTED
- [[BD.PublicarArticulo()]] escribe acá · `writes_to` EXTRACTED
- [[SP BorrarFotoUsuario]] escribe acá · `writes_to` EXTRACTED
- [[SP GuardarFotoUsuario]] escribe acá · `writes_to` EXTRACTED
- [[SP PublicarArticulo]] escribe acá · `writes_to` EXTRACTED
