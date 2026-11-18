---
tipo: tabla
archivos:
  - "BaseDatos/Estructura.sql"
  - "BaseDatos/Datos.sql"
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
tags:
  - tipo/tabla
---
# Tabla TipoCambios

`Id` (PK) y `Nombre` varchar(50). Tres tipos: 1 Agregar, 2 Sacar, 3 Pedir (14/11). Son los tipos de [[Tabla CambiosIntercambios]]. En el código se usan las constantes de `Models/TipoCambios.cs`.
