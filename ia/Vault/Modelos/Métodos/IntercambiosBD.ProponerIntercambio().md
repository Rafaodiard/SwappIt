---
tipo: metodo
comunidad: "Tablas y acceso a datos"
archivos:
  - "Models/BD/IntercambiosBD.cs"
graphify_ids:
  - "models_bd_intercambiosbd_swappit_models_intercambiosbd_proponerintercambio"
tags:
  - tipo/metodo
  - comunidad/Tablas_y_acceso_a_datos
---
# IntercambiosBD.ProponerIntercambio()

Método de [[BD]] · `Models/BD.cs`. Parámetros: `idUsuario`, `idsOfrecidos` (1 a 3), `idDueno`, `idArticuloPedido`, `creadas`.

En una transacción: inserta el intercambio Pendiente si no hay otra propuesta en curso del mismo usuario por ese artículo y si ninguno de los artículos está comprometido; después guarda los ofrecidos y el pedido en [[Tabla ArticulosIntercambios]] y crea la notificación. Devuelve el id o `null` (desde el 11/11 lee con `QueryFirstOrDefault<int?>`; antes devolvía 0 y el aviso de propuesta en curso nunca aparecía).

Comunidad del grafo: [[Comunidad - Tablas y acceso a datos]]

## Conexiones en el grafo (graphify)
- llama a [[ConexionBD.ListaDeIds()]] · `calls` EXTRACTED
- llama a [[NotificacionesBD.LeerCreadas()]] · `calls` EXTRACTED
- llama al SP [[SP ProponerIntercambio]] · `calls_sp` EXTRACTED
- usa el tipo [[IReadOnlyCollection]] · `references` EXTRACTED
- usa el tipo [[List]] · `references` EXTRACTED

**Desde otras notas:**
- [[IntercambioController.Proponer()]] la llama · `calls` EXTRACTED
- [[BD]] la tiene como método · `method` EXTRACTED
