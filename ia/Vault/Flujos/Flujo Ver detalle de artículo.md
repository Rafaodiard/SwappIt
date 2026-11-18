---
tipo: flujo
tags:
  - tipo/flujo
---
# Flujo: Ver el detalle de un artículo

**URL:** `/Articulos/Detalle/{id}` · **Estado:** funciona. Lo puede ver cualquiera.

1. Cada [[Vista _CardObjeto]] linkea al detalle.
2. [[ArticulosController]].Detalle(id):
   - [[BD]].GetArticuloById → si no existe, 404 con "Este artículo no existe".
   - Dueño: [[BD]].GetUsuarioById, su foto ([[BD]].GetFotoUsuario) y provincia ([[BD]].GetProvinciaById).
   - Fotos ([[BD]].GetImagenesArticulo), categoría ([[BD]].GetCategoriaById), estado ([[BD]].GetEstadoArticuloById).
   - Hasta 4 artículos más del mismo dueño.
   - `esPropio` = el usuario de la sesión es el dueño. Si está logueado y no es suyo, carga sus artículos para el pop up de [[Flujo Proponer intercambio]].
3. [[Vista Articulos-Detalle]] muestra galería ([[articulo.js]] cambia la foto principal), descripción, "Busca a cambio" (o "Abierto a propuestas"), ubicación (la del artículo o barrio + provincia del dueño) y "Publicado por" con link a [[Flujo Perfil público]].
4. Según quién mira: dueño → aviso "Este artículo es tuyo" y "Editar artículo" (deshabilitado); logueado → "Proponer intercambio"; visitante → link al login.
