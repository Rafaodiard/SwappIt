---
tipo: sp
comunidad: "SQLSwappit.sql y SPs nuevos"
archivos:
  - "SQLSwappit.sql"
  - "SQLSwappit_CualquierCompu.sql"
  - "BaseDatos/StoredProcedures.sql"
graphify_ids:
  - "sqlswappit_dbo_publicararticulo"
  - "sqlswappit_cualquiercompu_dbo_publicararticulo"
  - "basedatos_storedprocedures_dbo_publicararticulo"
tags:
  - tipo/sp
  - comunidad/SQLSwappit_sql_y_SPs_nuevos
---
# SP PublicarArticulo

Stored procedure `dbo.PublicarArticulo`. Está en: [[Script StoredProcedures.sql]], [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]].

Desde el 29/10 tiene código (antes era la plantilla vacía de SSMS): guarda el artículo y sus fotos (rutas separadas por `|`, la primera es la portada) en una transacción y devuelve el id nuevo, como [[BD]].PublicarArticulo.

Es la copia en SQL de [[BD]].PublicarArticulo, pero **C# no lo llama** (ver [[Pendientes y problemas]]).

Comunidad del grafo: [[Comunidad - SQLSwappit.sql y SPs nuevos]]

## Conexiones en el grafo (graphify)
- escribe en [[Tabla Articulos]] · `writes_to` EXTRACTED
- escribe en [[Tabla Imagenes]] · `writes_to` EXTRACTED

**Desde otras notas:**
- [[Script SQLSwappit.sql]] la contiene · `contains` EXTRACTED
- [[Script SQLSwappit_CualquierCompu.sql]] la contiene · `contains` EXTRACTED
- [[Script StoredProcedures.sql]] la contiene · `contains` EXTRACTED
- [[BD.PublicarArticulo()]] tiene el mismo nombre · `same_name_as_sp` INFERRED
