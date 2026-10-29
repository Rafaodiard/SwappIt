---
tipo: metodo
comunidad: "Publicar artículo"
archivos:
  - "Models/BD.cs"
graphify_ids:
  - "models_bd_swappit_models_bd_publicararticulo"
tags:
  - tipo/metodo
  - comunidad/Publicar_artículo
---
# BD.PublicarArticulo()

Método de [[BD]] · `Models/BD.cs` línea 163. Parámetros: `Articulos,List&lt;string&gt;`.

Comunidad del grafo: [[Comunidad - Publicar artículo]]

## Conexiones en el grafo (graphify)
- usa el tipo [[Articulos]] · `references` EXTRACTED
- usa el tipo [[List]] · `references` EXTRACTED
- tiene un SP con el mismo nombre [[SP PublicarArticulo]] · `same_name_as_sp` INFERRED
- escribe en [[Tabla Articulos]] · `writes_to` EXTRACTED
- escribe en [[Tabla Imagenes]] · `writes_to` EXTRACTED

**Desde otras notas:**
- [[PublicarController.Index() POST]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
