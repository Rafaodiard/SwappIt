---
tipo: flujo
tags:
  - tipo/flujo
---
# Flujo: Perfil público de otro usuario

**URL:** `/Perfil/Publico/{id}` · **Estado:** funciona.

- Se llega desde "Publicado por" / "Ver todos" en [[Vista Articulos-Detalle]].
- [[PerfilController]].Publico(id): si es tu propio id, redirige a `/Perfil`. Si no existe → 404.
- Copia **solo los datos públicos** (nombre, apellido, usuario, barrio, descripción) a un [[Usuarios]] nuevo, para que la vista nunca tenga el mail, teléfono, edad ni contraseña.
- [[Vista Perfil-Publico]]: foto, descripción, ubicación, cantidad de artículos y sus cards.

**Pendiente:** reputación e intercambios realizados (no hay datos).
