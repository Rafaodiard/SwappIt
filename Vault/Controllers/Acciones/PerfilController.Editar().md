---
tipo: metodo
comunidad: "Controllers, vistas y JS"
archivos:
  - "Controllers/PerfilController.cs"
graphify_ids:
  - "controllers_perfilcontroller_swappit_controllers_perfilcontroller_editar"
tags:
  - tipo/metodo
  - comunidad/Controllers_vistas_y_JS
---
# PerfilController.Editar()

Método de [[PerfilController]] · `Controllers/PerfilController.cs` línea 72. Parámetros: `EditarPerfilViewModel`.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- llama a [[BD.BorrarFotoUsuario()]] · `calls` EXTRACTED
- llama a [[BD.GetFotoUsuario()]] · `calls` EXTRACTED
- llama a [[BD.GetUsuarioById()]] · `calls` EXTRACTED
- llama a [[BD.GuardarFotoUsuario()]] · `calls` EXTRACTED
- llama a [[BD.UpdateUsuario()]] · `calls` EXTRACTED
- llama a [[PerfilController.BorrarFoto()]] · `calls` EXTRACTED
- llama a [[PerfilController.GuardarFoto()]] · `calls` EXTRACTED
- llama a [[SesionUsuario.GuardarDatosHeader()]] · `calls` EXTRACTED
- llama a [[Telefonos.Convertir()]] · `calls` EXTRACTED
- redirige a [[AccountController.Index()]] · `redirects_to` EXTRACTED
- redirige a [[PerfilController.Index()]] · `redirects_to` EXTRACTED
- usa el tipo [[EditarPerfilViewModel]] · `references` EXTRACTED
- usa el tipo [[HttpPost]] · `references` EXTRACTED
- usa el tipo [[IActionResult]] · `references` EXTRACTED

**Desde otras notas:**
- [[PerfilController]] la tiene como método · `method` EXTRACTED
- [[Vista Perfil-Index]] envía su formulario acá · `posts_to` EXTRACTED
