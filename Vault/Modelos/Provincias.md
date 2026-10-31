---
tipo: modelo
comunidad: "Namespaces y formularios"
archivos:
  - "Models/Provincia.cs"
graphify_ids:
  - "models_provincia_swappit_models_provincias"
  - "models_provincia"
  - "models_provincia_swappit_models_provincias_idprovincia"
  - "models_provincia_swappit_models_provincias_nombre"
tags:
  - tipo/modelo
  - comunidad/Namespaces_y_formularios
---
# Provincias (modelo)

`Models/Provincia.cs` (el archivo se llama en singular, la clase en plural) · [[Tabla Provincias]]. Se usa en el perfil y en el detalle del artículo.

Comunidad del grafo: [[Comunidad - Namespaces y formularios]]

## Propiedades
`IdProvincia` · `Nombre`

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Models]] · `contains` EXTRACTED
- corresponde a la tabla [[Tabla Provincias]] · `maps_to` INFERRED

**Desde otras notas:**
- [[BD.GetProvinciaById()]] la usa como tipo · `references` EXTRACTED
- [[BD.GetProvincias()]] la usa como tipo · `references` EXTRACTED
