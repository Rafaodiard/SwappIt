---
tipo: script
archivos:
  - "BaseDatos/ProvinciasDuplicadas.sql"
tags:
  - tipo/script
---
# Script ProvinciasDuplicadas.sql

`BaseDatos/ProvinciasDuplicadas.sql` (08/11) · **Ya no está en el repo** (14/11, pedido de Rafael: en `BaseDatos/` solo van [[Script Estructura.sql]], [[Script Datos.sql]] y [[Script StoredProcedures.sql]]). Era: Para una base que ya existe: en una transacción pasa a cada usuario a la primera fila de su provincia (la de menor `IdProvincia` con el mismo nombre) y borra las filas repetidas de [[Tabla Provincias]]. Al final muestra cuántas quedaron (tienen que ser 24). Los scripts de creación ya vienen sin repetidas, así que no hace falta en una base nueva. Lo corre Rafael en SSMS.
