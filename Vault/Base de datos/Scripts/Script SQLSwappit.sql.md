---
tipo: script
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
graphify_ids:
  - "sqlswappit"
tags:
  - tipo/script
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# Script SQLSwappit.sql

Raíz del repo, **UTF-16**, ~1060 líneas. Crea la base con rutas de archivos de `MSSQL14.MSSQLSERVER` (fallan en una compu con otra versión de SQL Server), el usuario `alumno`, las 11 tablas con sus FK (con [[Tabla Notificaciones]] y [[Tabla TipoNotificaciones]]), los datos de prueba y **24 stored procedures**: los 4 originales y 20 nuevos del 28/10 (uno por método de [[BD]]). Se suele regenerar desde SSMS con "Generate Scripts", lo que ya borró columnas alguna vez: revisarlo después de regenerar. Ver [[Base de datos]].

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- contiene [[SP ActualizarContrasena]] · `contains` EXTRACTED
- contiene [[SP BorrarFotoUsuario]] · `contains` EXTRACTED
- contiene [[SP GetArticuloById]] · `contains` EXTRACTED
- contiene [[SP GetArticulosCatalogo]] · `contains` EXTRACTED
- contiene [[SP GetCategoriaById]] · `contains` EXTRACTED
- contiene [[SP GetCategorias]] · `contains` EXTRACTED
- contiene [[SP GetEstadoArticuloById]] · `contains` EXTRACTED
- contiene [[SP GetEstadosArticulos]] · `contains` EXTRACTED
- contiene [[SP GetFiltroCategorias]] · `contains` EXTRACTED
- contiene [[SP GetFiltroEstados]] · `contains` EXTRACTED
- contiene [[SP GetFotoUsuario]] · `contains` EXTRACTED
- contiene [[SP GetImagenesArticulo]] · `contains` EXTRACTED
- contiene [[SP GetProvinciaById]] · `contains` EXTRACTED
- contiene [[SP GetProvincias]] · `contains` EXTRACTED
- contiene [[SP GetUsuarioById]] · `contains` EXTRACTED
- contiene [[SP GetUsuarioByMail]] · `contains` EXTRACTED
- contiene [[SP GuardarFotoUsuario]] · `contains` EXTRACTED
- contiene [[SP PublicarArticulo]] · `contains` EXTRACTED
- contiene [[SP RegistrarArticulo]] · `contains` EXTRACTED
- contiene [[SP RegistrarIntercambio]] · `contains` EXTRACTED
- contiene [[SP RegistrarMensaje]] · `contains` EXTRACTED
- contiene [[SP RegistrarUsuario]] · `contains` EXTRACTED
- contiene [[SP UpdateUsuario]] · `contains` EXTRACTED
- contiene [[SP UsuarioExiste]] · `contains` EXTRACTED
- contiene [[Tabla Articulos]] · `contains` EXTRACTED
- contiene [[Tabla Categorias]] · `contains` EXTRACTED
- contiene [[Tabla EstadosArticulos]] · `contains` EXTRACTED
- contiene [[Tabla EstadosIntercambios]] · `contains` EXTRACTED
- contiene [[Tabla Imagenes]] · `contains` EXTRACTED
- contiene [[Tabla Intercambios]] · `contains` EXTRACTED
- contiene [[Tabla Mensajes]] · `contains` EXTRACTED
- contiene [[Tabla Notificaciones]] · `contains` EXTRACTED
- contiene [[Tabla Provincias]] · `contains` EXTRACTED
- contiene [[Tabla TipoNotificaciones]] · `contains` EXTRACTED
- contiene [[Tabla Usuarios]] · `contains` EXTRACTED
