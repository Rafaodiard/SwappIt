---
tipo: vista
comunidad: "Controllers, vistas y JS"
archivos:
  - "Views/Perfil/Index.cshtml"
graphify_ids:
  - "views_perfil_index"
tags:
  - tipo/vista
  - comunidad/Controllers_vistas_y_JS
---
# Vista: Perfil / Index (mi perfil)

`Views/Perfil/Index.cshtml` · [[PerfilController]].Index ([[Flujo Editar perfil]]).

- Tarjeta con avatar (botón de cámara), nombre, @usuario, descripción o "Agregá una descripción", "Editar perfil".
- Información personal: usuario, email, teléfono (— si es 0), barrio + provincia, edad.
- "Mis artículos publicados" con [[Vista _CardObjeto]] y botón Publicar.
- "Historial de intercambios": los intercambios del usuario, cada uno con [[Vista _FilaIntercambio]], y link a Mis intercambios.
- Pop up "Editar perfil" (form POST a [[PerfilController]].Editar, con foto) manejado por [[perfil.js]]. El email aparece deshabilitado.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- incluye el partial [[Vista _CardObjeto]] · `includes` EXTRACTED
- incluye el partial [[Vista _FilaIntercambio]] · `includes` EXTRACTED
- tiene un link a [[IntercambioController.Index()]] · `links_to` EXTRACTED
- tiene un link a [[PublicarController.Index() GET]] · `links_to` EXTRACTED
- carga el script [[perfil.js]] · `loads_script` EXTRACTED
- envía el formulario a [[PerfilController.Editar()]] · `posts_to` EXTRACTED

**Desde otras notas:**
- [[PerfilController.Index()]] muestra esta vista · `renders` INFERRED
