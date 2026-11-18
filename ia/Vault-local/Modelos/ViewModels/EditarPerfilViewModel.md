---
tipo: modelo
comunidad: "Editar perfil"
archivos:
  - "Models/ViewModels/EditarPerfilViewModel.cs"
graphify_ids:
  - "models_viewmodels_editarperfilviewmodel_swappit_models_viewmodels_editarperfilviewmodel"
  - "models_viewmodels_editarperfilviewmodel"
  - "models_viewmodels_editarperfilviewmodel_swappit_models_viewmodels_editarperfilviewmodel_apellido"
  - "models_viewmodels_editarperfilviewmodel_swappit_models_viewmodels_editarperfilviewmodel_barrio"
  - "models_viewmodels_editarperfilviewmodel_swappit_models_viewmodels_editarperfilviewmodel_descripcion"
  - "models_viewmodels_editarperfilviewmodel_swappit_models_viewmodels_editarperfilviewmodel_foto"
  - "models_viewmodels_editarperfilviewmodel_swappit_models_viewmodels_editarperfilviewmodel_idprovincias"
  - "models_viewmodels_editarperfilviewmodel_swappit_models_viewmodels_editarperfilviewmodel_nombre"
  - "models_viewmodels_editarperfilviewmodel_swappit_models_viewmodels_editarperfilviewmodel_quitarfoto"
  - "models_viewmodels_editarperfilviewmodel_swappit_models_viewmodels_editarperfilviewmodel_telefono"
  - "models_viewmodels_editarperfilviewmodel_swappit_models_viewmodels_editarperfilviewmodel_usuario"
tags:
  - tipo/modelo
  - comunidad/Editar_perfil
---
# EditarPerfilViewModel

`Models/ViewModels/EditarPerfilViewModel.cs` · Pop up "Editar perfil" de [[Vista Perfil-Index]]. Constantes `MaxFotoMB = 5`, `MaxDescripcion = 500`, `ExtensionesFoto` (.jpg, .jpeg, .png). Campos: Nombre, Apellido, Usuario, Telefono, Barrio, Descripcion, IdProvincias, `Foto` (IFormFile) y `QuitarFoto`. Lo recibe [[PerfilController]].Editar. (El comentario todavía dice `Views/Account/Perfil.cshtml`, que ahora es `Views/Perfil/Index.cshtml`.)

Comunidad del grafo: [[Comunidad - Editar perfil]]

## Propiedades
`Apellido` · `Barrio` · `Descripcion` · `Foto` · `IdProvincias` · `Nombre` · `QuitarFoto` · `Telefono` · `Usuario`

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Models.ViewModels]] · `contains` EXTRACTED
- importa [[System.ComponentModel.DataAnnotations]] · `imports` EXTRACTED
- usa el tipo [[IFormFile]] · `references` EXTRACTED

**Desde otras notas:**
- [[PerfilController.Editar()]] la usa como tipo · `references` EXTRACTED
