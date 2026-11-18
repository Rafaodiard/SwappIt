---
tipo: flujo
tags:
  - tipo/flujo
---
# Flujo: Iniciar sesión

**URL:** `/Account` · **Estado:** funciona.

1. `GET /Account` → [[AccountController]].Index() devuelve la vista `Login` ([[Vista Account-Login]]).
2. `POST /Account/Login` con [[LoginViewModel]] (Mail, Contrasena).
3. [[BD]].GetUsuarioByMail trae el usuario; [[Contrasenas]].Verificar compara:
   - si lo guardado es un hash (más de 50 caracteres, base64 que empieza con 0x01) usa `PasswordHasher`;
   - si es texto plano (usuarios de prueba) compara directo y avisa `hayQueActualizar`.
4. Si hay que actualizar, [[BD]].ActualizarContrasena guarda el hash nuevo.
5. Sesión: `UsuarioId` + [[SesionUsuario]].GuardarDatosHeader (iniciales y foto para el avatar de [[Vista _Layout]]).
6. Redirige a `/`. Si falla: "Email o contraseña incorrectos".

**Pendiente:** "¿Olvidaste tu contraseña?" no tiene pantalla.
