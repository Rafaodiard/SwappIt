---
tipo: modelo
comunidad: "Usuarios, contraseñas y sesión"
archivos:
  - "Models/Contrasenas.cs"
graphify_ids:
  - "models_contrasenas_swappit_models_contrasenas"
  - "models_contrasenas"
tags:
  - tipo/modelo
  - comunidad/Usuarios_contraseñas_y_sesión
---
# Contrasenas

`Models/Contrasenas.cs` · Hash de contraseñas con el `PasswordHasher<Usuarios>` de ASP.NET Core (PBKDF2 con sal aleatoria), sin paquetes extra.

- `Hashear(contrasena)` → hash base64 de 84 caracteres.
- `Verificar(guardada, ingresada, out hayQueActualizar)`: si lo guardado es texto plano (usuarios de prueba) compara directo y pide re-hashear; si es hash, usa `VerifyHashedPassword` (también avisa si hay que re-hashear por formato viejo).
- `EsHash(valor)` (privado): más de 50 caracteres, base64 y primer byte `0x01`. Evita que alguien entre escribiendo el hash como contraseña.

Nunca se compara la contraseña en SQL: se trae el usuario por mail y se verifica acá. Lo usa [[AccountController]].

Comunidad del grafo: [[Comunidad - Usuarios, contraseñas y sesión]]

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Models]] · `contains` EXTRACTED
- importa [[Microsoft.AspNetCore.Identity]] · `imports` EXTRACTED
- tiene el método [[Contrasenas.EsHash()]] · `method` EXTRACTED
- tiene el método [[Contrasenas.Hashear()]] · `method` EXTRACTED
- tiene el método [[Contrasenas.Verificar()]] · `method` EXTRACTED
- usa el tipo [[PasswordHasher]] · `references` EXTRACTED
- usa el tipo [[Usuarios]] · `references` EXTRACTED
