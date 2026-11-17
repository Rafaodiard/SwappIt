---
tipo: metodo
comunidad: "Controllers, vistas y JS"
archivos:
  - "Models/BD/UsuariosBD.cs"
graphify_ids:
  - "models_bd_usuariosbd_swappit_models_usuariosbd_getusuariobyid"
tags:
  - tipo/metodo
  - comunidad/Controllers_vistas_y_JS
---
# UsuariosBD.GetUsuarioById()

Método de `UsuariosBD` ([[BD]]) · `Models/BD/UsuariosBD.cs` línea 40. Parámetros: `int`.

Llama al SP [[SP GetUsuarioById]] con `CommandType.StoredProcedure`.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- llama al SP [[SP GetUsuarioById]] · `calls_sp` EXTRACTED
- usa el tipo [[Usuarios]] · `references` EXTRACTED

**Desde otras notas:**
- [[AccountController.CambiarContrasena() POST]] la llama · `calls` EXTRACTED
- [[ArticulosController.Detalle()]] la llama · `calls` EXTRACTED
- [[HomeController.Inicio()]] la llama · `calls` EXTRACTED
- [[PerfilController.Editar()]] la llama · `calls` EXTRACTED
- [[PerfilController.Index()]] la llama · `calls` EXTRACTED
- [[PerfilController.Publico()]] la llama · `calls` EXTRACTED
- [[PublicarController.Index() GET]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
