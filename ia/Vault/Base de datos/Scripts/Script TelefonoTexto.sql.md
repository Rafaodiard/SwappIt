---
tipo: script
archivos:
  - "BaseDatos/TelefonoTexto.sql"
tags:
  - tipo/script
---
# Script TelefonoTexto.sql

`BaseDatos/TelefonoTexto.sql` (11/11) · **Ya no está en el repo** (14/11, pedido de Rafael: en `BaseDatos/` solo van [[Script Estructura.sql]], [[Script Datos.sql]] y [[Script StoredProcedures.sql]]). Era: Para una base que ya existe: si `Usuarios.Telefono` todavía es `int`, la pasa a `varchar(20)` como en [[Script Estructura.sql]]; deja vacíos los teléfonos que habían quedado en 0 (el perfil muestra "—"); vuelve a crear [[SP RegistrarUsuario]] y [[SP UpdateUsuario]] con `@telefono varchar(20)`. Al final lista los teléfonos. Se puede volver a ejecutar. Lo corre Rafael en SSMS. Ver [[Telefonos]] y [[Tabla Usuarios]].
