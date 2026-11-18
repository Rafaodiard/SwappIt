---
tipo: flujo
tags:
  - tipo/flujo
---
# Flujo: Buscar y filtrar artículos

**URL:** `/Articulos/Buscar?q=texto&categoria=1&categoria=4&estado=2` · **Estado:** funciona (texto, categorías, estados).

1. El buscador del header ([[Vista _Layout]]) manda `q` por GET. "Explorar productos" en [[Vista Home-Index]] entra sin filtros.
2. [[ArticulosController]].Buscar(q, categoria[], estado[]): limpia los ids (positivos, sin repetir, máximo 20) y llama a:
   - [[BD]].GetArticulosCatalogo(busqueda, categorias, estados) → lista de [[ArticuloCardViewModel]] (JOIN [[Tabla Articulos]] + [[Tabla Usuarios]] + [[Tabla EstadosArticulos]] y la primera foto de [[Tabla Imagenes]]). Busca con `LIKE` sobre el nombre; los `%`, `_` y `[` que escribe el usuario se escapan.
   - [[BD]].GetFiltroCategorias y [[BD]].GetFiltroEstados → [[OpcionFiltroViewModel]] con cuántos artículos hay de cada opción (respetando la búsqueda).
   - Si la base falla, `errorCarga = true` y la vista muestra un aviso en lugar de "sin resultados".
3. [[Vista Articulos-Buscar]] dibuja el panel de filtros y una [[Vista _CardObjeto]] por artículo.
4. [[buscar.js]]: al marcar o desmarcar un filtro se reenvía el form (los filtros quedan en la URL); botones grilla/lista.

**Solo visual:** el select "Más recientes / A - Z" (el orden es siempre el más nuevo primero, así que "A - Z" no hace nada). El filtro de distancia y "Más cercanos" se sacaron el 30/10 (no hay coordenadas en la base).
