---
tipo: script
comunidad: "Migración de estados"
archivos:
  - "BaseDatos/Estados.sql"
graphify_ids:
  - "basedatos_estados"
tags:
  - tipo/script
  - comunidad/Migración_de_estados
---
# Script Estados.sql

`BaseDatos/Estados.sql` · Migración para bases **ya creadas** (se puede ejecutar varias veces):
1. Renombra `Estados` → [[Tabla EstadosArticulos]] (o la crea) y carga los 4 estados.
2. Crea [[Tabla EstadosIntercambios]] con sus 4 estados.
3. Pasa `Articulos.Estado` (texto) a `IdEstado` con FK (corrige "Muy bueno" → "Muy buen estado", "Bueno" → "Buen estado"); si algún texto no coincide, corta con `RAISERROR` sin borrar la columna vieja.
4. Lo mismo con `Intercambios.Estado`.
5. Actualiza [[SP RegistrarArticulo]] y [[SP RegistrarIntercambio]] para que reciban el nombre del estado y guarden su id.

Según lo acordado, se borra cuando Rafael lo haya ejecutado en su base.

Comunidad del grafo: [[Comunidad - Migración de estados]]

## Conexiones en el grafo (graphify)
- contiene [[Tabla EstadosArticulos]] · `contains` EXTRACTED
- contiene [[Tabla EstadosIntercambios]] · `contains` EXTRACTED
