---
tipo: modelo
comunidad: "Namespaces y formularios"
archivos:
  - "Models/Telefonos.cs"
graphify_ids:
  - "models_telefonos_swappit_models_telefonos"
  - "models_telefonos"
tags:
  - tipo/modelo
  - comunidad/Namespaces_y_formularios
---
# Telefonos

`Models/Telefonos.cs` · `Convertir(texto)`: deja solo los dígitos y los pasa a `int`. Si no entra en un `int` (un celular completo con +54 9 no entra) guarda **0**. Tiene un TODO: pasar la columna `Usuarios.Telefono` a `varchar`.

Comunidad del grafo: [[Comunidad - Namespaces y formularios]]

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Models]] · `contains` EXTRACTED
- tiene el método [[Telefonos.Convertir()]] · `method` EXTRACTED
