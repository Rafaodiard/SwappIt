---
tipo: tabla
comunidad: "Tablas y acceso a datos"
archivos:
  - "BaseDatos/Estructura.sql"
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
graphify_ids:
  - "basedatos_estructura_dbo_usuarios"
  - "sqlswappit_dbo_usuarios"
  - "sqlswappit_cualquiercompu_dbo_usuarios"
  - "basedatos_storedprocedures_sql_usuarios"
tags:
  - tipo/tabla
  - comunidad/Tablas_y_acceso_a_datos
---
# Tabla Usuarios

| Columna | Tipo | Nota |
|---|---|---|
| IdUsuarios | int identity, PK | |
| Nombre, Apellido, Usuario, Mail | varchar(50) NOT NULL | Usuario = @alias |
| Telefono | **int** NOT NULL | un celular completo no entra ([[Telefonos]]) |
| Contraseña | varchar(100) NOT NULL | hash de [[Contrasenas]] (84 caracteres) |
| Barrio | varchar(50) NOT NULL | vacío al registrarse |
| Fecha nacimiento | date NOT NULL | con espacio en el nombre: [[BD]] la renombra `FechaNacimiento` |
| Edad | int NOT NULL | calculada al registrarse |
| IdProvincias | int NOT NULL, FK → [[Tabla Provincias]] | 1 al registrarse |
| Descripcion | varchar(500) NULL | perfil |

Datos de prueba: 12 usuarios (ids 2 a 13), ver [[Script Datos.sql]]. Modelo: [[Usuarios]].

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)

**Desde otras notas:**
- [[Script Estructura.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Usuarios]] es su clase en C# · `maps_to` INFERRED
- [[BD.GetArticulosCatalogo()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetIntercambio()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetIntercambios()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetNotificaciones()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetUsuarioById()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetUsuarioByMail()]] lee de acá · `reads_from` EXTRACTED
- [[BD.UsuarioExiste()]] lee de acá · `reads_from` EXTRACTED
- [[SP GetArticulosCatalogo]] lee de acá · `reads_from` EXTRACTED
- [[SP GetUsuarioById]] lee de acá · `reads_from` EXTRACTED
- [[SP GetUsuarioByMail]] lee de acá · `reads_from` EXTRACTED
- [[SP RegistrarArticulo]] lee de acá · `reads_from` EXTRACTED
- [[SP RegistrarIntercambio]] lee de acá · `reads_from` EXTRACTED
- [[SP RegistrarMensaje]] lee de acá · `reads_from` EXTRACTED
- [[SP UsuarioExiste]] lee de acá · `reads_from` EXTRACTED
- [[Tabla Articulos]] la usa como tipo · `references` EXTRACTED
- [[Tabla Imagenes]] la usa como tipo · `references` EXTRACTED
- [[Tabla Intercambios]] la usa como tipo · `references` EXTRACTED
- [[Tabla Mensajes]] la usa como tipo · `references` EXTRACTED
- [[Tabla Notificaciones]] la usa como tipo · `references` EXTRACTED
- [[BD.ActualizarContrasena()]] escribe acá · `writes_to` EXTRACTED
- [[BD.Register()]] escribe acá · `writes_to` EXTRACTED
- [[BD.UpdateUsuario()]] escribe acá · `writes_to` EXTRACTED
- [[SP ActualizarContrasena]] escribe acá · `writes_to` EXTRACTED
- [[SP RegistrarUsuario]] escribe acá · `writes_to` EXTRACTED
- [[SP UpdateUsuario]] escribe acá · `writes_to` EXTRACTED
