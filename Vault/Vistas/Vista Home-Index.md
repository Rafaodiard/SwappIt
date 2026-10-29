---
tipo: vista
comunidad: "Controllers, vistas y JS"
archivos:
  - "Views/Home/Index.cshtml"
graphify_ids:
  - "views_home_index"
tags:
  - tipo/vista
  - comunidad/Controllers_vistas_y_JS
---
# Vista: Home / Index (landing)

`Views/Home/Index.cshtml` · [[HomeController]].Index. Secciones: hero ("Explorar productos" → Buscar), banda Intercambiá/Conectá/Reutilizá, "¿Qué es Swappit?", "Una segunda vida para cada objeto", "¿Cómo funciona?" (4 pasos, `id="como-funciona"`), "Todo lo que necesitás", **objetos destacados** (`ViewBag.destacados`, 4 cards [[Vista _CardObjeto]]) y CTA "Registrate ahora". Imágenes `foto1.png` a `foto4.jpg` de `wwwroot/img`.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- incluye el partial [[Vista _CardObjeto]] · `includes` EXTRACTED
- tiene un link a [[AccountController.Registro() GET]] · `links_to` EXTRACTED
- tiene un link a [[ArticulosController.Buscar()]] · `links_to` EXTRACTED

**Desde otras notas:**
- [[HomeController.Index()]] muestra esta vista · `renders` INFERRED
