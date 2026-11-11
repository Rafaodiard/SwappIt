---
tipo: tabla
archivos:
  - "BaseDatos/Estructura.sql"
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/ArticulosIntercambios.sql"
tags:
  - tipo/tabla
---
# Tabla ArticulosIntercambios

| Columna | Tipo |
|---|---|
| Id | int identity, PK |
| IdArticulo | int NOT NULL, FK → [[Tabla Articulos]] |
| IdIntercambio | int NOT NULL, FK → [[Tabla Intercambios]] |

`UQ_ArticulosIntercambios`: un artículo no puede estar dos veces en el mismo intercambio.

Guarda todos los artículos de un intercambio, de los dos lados (11/11, pedido de Rafael). No hay columna de lado: los de `Intercambios.IdUsuarios1` son los que se ofrecen y los de `IdUsuarios2` lo que se pide. Hoy se ofrecen de 1 a 3 (`Intercambios.MaxArticulosOfrecidos`, se controla en [[IntercambioController]]) y se pide uno; la base no lo impide, así que pedir varios no necesitaría cambiarla.

Lo usan casi todas las consultas de intercambios de [[BD]]: la disponibilidad en el catálogo (`ArticuloDisponible`, `ArticuloNoIntercambiado`), [[BD.GetIntercambios()]] (primer artículo de cada lado + cantidad), [[BD.ProponerIntercambio()]], el control al aceptar y el rechazo automático de las otras propuestas ([[BD.CambiarEstadoIntercambio()]]), los mails y las notificaciones. También [[SP GetFiltroCategorias]], [[SP GetFiltroEstados]], [[SP RegistrarIntercambio]] y dos SP Complejos.

Datos de prueba: los 26 intercambios son 52 filas (ofrecido y pedido, en ese orden). Para una base que ya existe: [[Script ArticulosIntercambios.sql]].
