---
tipo: tabla
comunidad: "Tablas y acceso a datos"
archivos:
  - "BaseDatos/Estructura.sql"
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
graphify_ids:
  - "basedatos_estructura_dbo_articulos"
  - "sqlswappit_dbo_articulos"
  - "sqlswappit_cualquiercompu_dbo_articulos"
  - "basedatos_storedprocedures_sql_articulos"
tags:
  - tipo/tabla
  - comunidad/Tablas_y_acceso_a_datos
---
# Tabla Articulos

| Columna | Tipo |
|---|---|
| IdArticulos | int identity, PK |
| Nombre | varchar(50) NOT NULL |
| Descripcion | varchar(500) NOT NULL |
| IdEstado | int NOT NULL, FK → [[Tabla EstadosArticulos]] |
| IdUsuarios | int NOT NULL, FK → [[Tabla Usuarios]] (dueño) |
| IdCategorias | int NOT NULL, FK → [[Tabla Categorias]] |
| Ubicacion | varchar(100) NULL |
| ACambio | varchar(100) NULL ("¿qué te gustaría recibir?") |

20 artículos de prueba (Microondas, Mesa de luz, Bicicleta urbana…), de los usuarios 3 a 12. Fotos en [[Tabla Imagenes]]. Modelo: [[Articulos]].

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- usa el tipo [[Tabla EstadosArticulos]] · `references` EXTRACTED
- usa el tipo [[Tabla Usuarios]] · `references` EXTRACTED

**Desde otras notas:**
- [[Script Estructura.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Articulos]] es su clase en C# · `maps_to` INFERRED
- [[BD.GetArticuloById()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetArticulosCatalogo()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetFiltroCategorias()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetFiltroEstados()]] lee de acá · `reads_from` EXTRACTED
- [[SP GetArticuloById]] lee de acá · `reads_from` EXTRACTED
- [[SP RegistrarIntercambio]] lee de acá · `reads_from` EXTRACTED
- [[Tabla Imagenes]] la usa como tipo · `references` EXTRACTED
- [[Tabla Intercambios]] la usa como tipo · `references` EXTRACTED
- [[BD.PublicarArticulo()]] escribe acá · `writes_to` EXTRACTED
- [[SP RegistrarArticulo]] escribe acá · `writes_to` EXTRACTED
