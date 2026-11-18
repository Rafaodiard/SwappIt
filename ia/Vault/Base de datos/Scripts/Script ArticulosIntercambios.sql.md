---
tipo: script
archivos:
  - "BaseDatos/ArticulosIntercambios.sql"
tags:
  - tipo/script
---
# Script ArticulosIntercambios.sql

`BaseDatos/ArticulosIntercambios.sql` (11/11) · **Ya no está en el repo** (14/11, pedido de Rafael: en `BaseDatos/` solo van [[Script Estructura.sql]], [[Script Datos.sql]] y [[Script StoredProcedures.sql]]). Era: Para una base que ya existe. Primero revisa que en cada intercambio el artículo 1 sea de `IdUsuarios1` y el 2 de `IdUsuarios2`; si alguno no cumple, avisa y no cambia nada. Después crea [[Tabla ArticulosIntercambios]] (con el UNIQUE y las claves foráneas, solo lo que falte), copia `IdArticulos1` e `IdArticulos2` de cada intercambio y borra esas dos columnas de [[Tabla Intercambios]] en una sola transacción. Vuelve a crear [[SP GetFiltroCategorias]], [[SP GetFiltroEstados]], [[SP RegistrarIntercambio]], `Complejos_SeguimientoIntercambiosPendientes` y `Complejos_Personalizado_GestionarPropuestaYNotificacion`. Al final lista los artículos de cada intercambio con su lado. Se puede volver a ejecutar. Lo corre Rafael en SSMS, junto con el código nuevo (el código viejo usa las columnas que se borran).
