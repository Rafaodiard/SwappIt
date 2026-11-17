---
tipo: metodo
comunidad: "Controllers, vistas y JS"
archivos:
  - "Models/BD/UsuariosBD.cs"
graphify_ids:
  - "models_bd_usuariosbd_swappit_models_usuariosbd_getfotousuario"
tags:
  - tipo/metodo
  - comunidad/Controllers_vistas_y_JS
---
# UsuariosBD.GetFotoUsuario()

Método de `UsuariosBD` ([[BD]]) · `Models/BD/UsuariosBD.cs` línea 114. Parámetros: `int`.

Llama al SP [[SP GetFotoUsuario]] con `CommandType.StoredProcedure`.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- llama al SP [[SP GetFotoUsuario]] · `calls_sp` EXTRACTED

**Desde otras notas:**
- [[ArticulosController.Detalle()]] la llama · `calls` EXTRACTED
- [[ChatController.Index()]] la llama · `calls` EXTRACTED
- [[IntercambioController.Detalle()]] la llama · `calls` EXTRACTED
- [[PerfilController.Editar()]] la llama · `calls` EXTRACTED
- [[PerfilController.Index()]] la llama · `calls` EXTRACTED
- [[PerfilController.Publico()]] la llama · `calls` EXTRACTED
- [[SesionUsuario.GuardarDatosHeader()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
