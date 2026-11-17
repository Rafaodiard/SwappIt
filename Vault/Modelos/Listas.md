---
tipo: modelo
comunidad: "Usuarios, contraseñas y sesión"
archivos:
  - "Models/Listas.cs"
graphify_ids:
  - "models_listas_swappit_models_listas"
  - "models_listas_swappit_models_listas_unirconcomas"
  - "models_listas_swappit_models_listas_unirnombres"
  - "models_listas_swappit_models_listas_idsvalidos"
  - "models_listas"
tags:
  - tipo/modelo
  - comunidad/Usuarios_contraseñas_y_sesión
---
# Listas

`Models/Listas.cs` · Ayudas para listas escritas sin LINQ (17/11):

- `IdsValidos(ids, maximo)`: deja los ids mayores a 0, sin repetir y hasta `maximo` (los que llegan de formularios con varios artículos o categorías).
- `UnirNombres(nombres)`: "a, b y c" para los textos de notificaciones y mails.
- `UnirConComas(partes)`: une con coma lo que no esté vacío (barrio y provincia en los perfiles).

La usan los controllers, [[EmailService]] y varias vistas.

Comunidad del grafo: [[Comunidad - Usuarios, contraseñas y sesión]]

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Models]] · `contains` EXTRACTED
- usa el tipo [[List]] · `references` EXTRACTED

**Desde otras notas:**
- [[ArticulosController.Buscar()]] la llama · `calls` EXTRACTED
- [[IntercambioController.Proponer()]] la llama · `calls` EXTRACTED
- [[RecomendacionesController]] la llama · `calls` EXTRACTED
