---
tipo: modelo
comunidad: "Intercambios y mensajes"
archivos:
  - "Models/ViewModels/RegistroViewModel.cs"
graphify_ids:
  - "models_viewmodels_registroviewmodel_swappit_models_viewmodels_registroviewmodel"
  - "models_viewmodels_registroviewmodel"
  - "models_viewmodels_registroviewmodel_swappit_models_viewmodels_registroviewmodel_apellido"
  - "models_viewmodels_registroviewmodel_swappit_models_viewmodels_registroviewmodel_contrasena"
  - "models_viewmodels_registroviewmodel_swappit_models_viewmodels_registroviewmodel_fechanacimiento"
  - "models_viewmodels_registroviewmodel_swappit_models_viewmodels_registroviewmodel_mail"
  - "models_viewmodels_registroviewmodel_swappit_models_viewmodels_registroviewmodel_nombre"
  - "models_viewmodels_registroviewmodel_swappit_models_viewmodels_registroviewmodel_telefono"
tags:
  - tipo/modelo
  - comunidad/Intercambios_y_mensajes
---
# RegistroViewModel

`Models/ViewModels/RegistroViewModel.cs` · Form de [[Vista Account-Registro]]: Nombre, Apellido, Mail (50), Contrasena (8 a 50), FechaNacimiento, Telefono. Tiene un TODO: la tabla también pide Usuario, Barrio e IdProvincias, que el diseño de Figma no incluye ([[AccountController]] los completa solo).

Comunidad del grafo: [[Comunidad - Intercambios y mensajes]]

## Propiedades
`Apellido` · `Contrasena` · `FechaNacimiento` · `Mail` · `Nombre` · `Telefono`

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Models.ViewModels]] · `contains` EXTRACTED
- importa [[System.ComponentModel.DataAnnotations]] · `imports` EXTRACTED
- usa el tipo [[DateTime]] · `references` EXTRACTED

**Desde otras notas:**
- [[AccountController.Registro() POST]] la usa como tipo · `references` EXTRACTED
