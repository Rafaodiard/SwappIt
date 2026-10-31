---
tipo: tabla
comunidad: "Categorías"
archivos:
  - "BaseDatos/Estructura.sql"
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
graphify_ids:
  - "basedatos_estructura_dbo_categorias"
  - "sqlswappit_dbo_categorias"
  - "sqlswappit_cualquiercompu_dbo_categorias"
  - "basedatos_storedprocedures_sql_categorias"
tags:
  - tipo/tabla
  - comunidad/Categorías
---
# Tabla Categorias

`IdCategorias` (PK) y `Nombre`. Datos: 1 Tecnología, 2 Libros, 3 Ropa, 4 Hogar, 5 Deportes, 6 Música. Modelo: [[Categorias]].

Comunidad del grafo: [[Comunidad - Categorías]]

## Conexiones en el grafo (graphify)

**Desde otras notas:**
- [[Script Estructura.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Categorias]] es su clase en C# · `maps_to` INFERRED
- [[BD.GetCategoriaById()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetCategorias()]] lee de acá · `reads_from` EXTRACTED
- [[BD.GetFiltroCategorias()]] lee de acá · `reads_from` EXTRACTED
- [[SP GetCategoriaById]] lee de acá · `reads_from` EXTRACTED
- [[SP GetCategorias]] lee de acá · `reads_from` EXTRACTED
- [[SP GetFiltroCategorias]] lee de acá · `reads_from` EXTRACTED
- [[SP RegistrarArticulo]] lee de acá · `reads_from` EXTRACTED
