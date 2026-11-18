---
tipo: flujo
tags:
  - tipo/flujo
---
# Flujo: Mi perfil y Editar perfil

**URL:** `/Perfil` · **Estado:** funciona. Hay que estar logueado.

1. Avatar del header → `GET /Perfil` → [[PerfilController]].Index(): usuario, provincia, lista de provincias, foto y sus artículos ([[BD]].GetArticulosCatalogo(idUsuario)).
2. [[Vista Perfil-Index]]: tarjeta con nombre, @usuario y descripción; información personal (usuario, email, teléfono, barrio, edad); "Mis artículos publicados"; "Historial de intercambios" (ejemplo fijo, sin datos).
3. Pop up "Editar perfil" ([[perfil.js]]: vista previa de la foto, quitar foto, contador de la descripción, se reabre si hubo error).
4. `POST /Perfil/Editar` con [[EditarPerfilViewModel]] → [[PerfilController]].Editar:
   - valida; el error va por `TempData["ErrorPerfil"]`;
   - foto nueva (JPG/PNG, 5 MB): borra la anterior del disco, la guarda en `wwwroot/img/perfiles/` y [[BD]].GuardarFotoUsuario; o "Quitar foto" → [[BD]].BorrarFotoUsuario;
   - actualiza nombre, apellido, usuario (sin `@`), teléfono, barrio, provincia y descripción con [[BD]].UpdateUsuario;
   - refresca el avatar del header ([[SesionUsuario]]) y vuelve con "Perfil actualizado.".

El email no se puede cambiar.
