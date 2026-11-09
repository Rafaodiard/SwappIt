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

`Models/Telefonos.cs` · `Convertir(texto)`: devuelve solo los dígitos, como texto (vacío si no hay). `EsValido(digitos)`: true si tiene entre `MinDigitos` (8) y `MaxDigitos` (15). Lo usan [[AccountController]].Registro (obligatorio) y [[PerfilController]].Editar (vacío permitido). Hasta el 08/11 pasaba el número a `int` y guardaba 0 si no entraba.

Comunidad del grafo: [[Comunidad - Namespaces y formularios]]

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Models]] · `contains` EXTRACTED
- tiene el método [[Telefonos.Convertir()]] · `method` EXTRACTED
