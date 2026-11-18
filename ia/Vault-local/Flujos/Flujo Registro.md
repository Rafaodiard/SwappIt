---
tipo: flujo
tags:
  - tipo/flujo
---
# Flujo: Registro

**URL:** `/Account/Registro` · **Estado:** funciona.

1. [[Vista _Layout]] (visitante) o el CTA de [[Vista Home-Index]] llevan a `GET /Account/Registro` → [[AccountController]].Registro() muestra [[Vista Account-Registro]].
2. El usuario completa nombre, apellido, email, contraseña (dos veces), fecha de nacimiento y teléfono. jQuery Validation valida en el navegador con los atributos de [[RegistroViewModel]].
3. `POST /Account/Registro` → [[AccountController]].Registro(RegistroViewModel, password2):
   - Si el modelo no es válido, vuelve a la vista con los datos cargados (`ViewBag.registro`).
   - [[BD]].UsuarioExiste(mail): si el mail ya existe → "Ya existe una cuenta con ese email."
   - Compara contraseña y repetición.
   - Arma un [[Usuarios]]: contraseña con [[Contrasenas]].Hashear, edad calculada (`CalcularEdad`), teléfono con [[Telefonos]].Convertir, `Usuario` = parte del mail antes de la `@`, `Barrio` vacío e `IdProvincias = 1` (el diseño no pide esos datos).
   - [[BD]].Register inserta en [[Tabla Usuarios]] (SQL inline, **no** usa [[SP RegistrarUsuario]]).
   - Lee el usuario recién creado ([[BD]].GetUsuarioByMail), guarda `UsuarioId` en la sesión y [[SesionUsuario]] guarda iniciales y foto.
4. Redirige a `/` ([[HomeController]]).

**Pendiente:** elegir barrio/provincia al registrarse; el teléfono largo se guarda como 0 (ver [[Pendientes y problemas]]).
