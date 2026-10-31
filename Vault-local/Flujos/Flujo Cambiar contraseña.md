---
tipo: flujo
tags:
  - tipo/flujo
---
# Flujo: Cambiar contraseña

**URL:** `/Account/CambiarContrasena` · **Estado:** funciona, pero **ninguna vista tiene un link** a esta pantalla (solo se llega escribiendo la URL).

1. GET: si no hay sesión → login. Muestra [[Vista Account-CambiarContrasena]].
2. POST con `contrasenaActual`, `contrasenaNueva`, `confirmarContrasena`:
   - [[BD]].GetUsuarioById + [[Contrasenas]].Verificar de la actual.
   - Nueva entre 8 y 50 caracteres e igual a la confirmación.
   - [[BD]].ActualizarContrasena con [[Contrasenas]].Hashear.
   - "Contraseña cambiada exitosamente."
