---
tipo: flujo
tags:
  - tipo/flujo
---
# Flujo: Registro

**URL:** `/Account/Registro` · **Estado:** funciona.

1. [[Vista _Layout]] (visitante) o el CTA de [[Vista Home-Index]] llevan a `GET /Account/Registro` → [[AccountController]].Registro() muestra [[Vista Account-Registro]].
2. El usuario completa nombre, apellido, email, contraseña (dos veces), fecha de nacimiento, teléfono, provincia (lista de [[BD]].GetProvincias) y barrio (texto). La validación es la del servidor ([[RegistroViewModel]]): la vista carga jQuery Validation, pero los inputs no tienen atributos `data-val`.
3. `POST /Account/Registro` → [[AccountController]].Registro(RegistroViewModel, password2):
   - Revisa que la provincia sea una de la lista.
   - Si el modelo no es válido, vuelve a la vista con los datos cargados (`ViewBag.registro`). La contraseña también vuelve cargada (`ViewBag.contrasena`) si es válida y coincide con la repetición; si no, hay que escribirla de nuevo.
   - [[BD]].UsuarioExiste(mail): si el mail ya existe → "Ya existe una cuenta con ese email."
   - Compara contraseña y repetición.
   - Arma un [[Usuarios]]: contraseña con [[Contrasenas]].Hashear, edad calculada (`CalcularEdad`), teléfono con [[Telefonos]].Convertir (si no tiene entre 8 y 15 dígitos, vuelve al formulario con el error debajo del campo), `Usuario` = parte del mail antes de la `@`, y el barrio y la provincia elegidos (hasta el 08/11 se guardaba `IdProvincias = 1`, Buenos Aires, y el barrio vacío).
   - [[BD]].Register inserta en [[Tabla Usuarios]] (SQL inline, **no** usa [[SP RegistrarUsuario]]).
   - Lee el usuario recién creado ([[BD]].GetUsuarioByMail), guarda `UsuarioId` en la sesión y [[SesionUsuario]] guarda iniciales y foto.
4. Redirige a `/` ([[HomeController]]).

**Para decidir:** elegir el barrio de una lista (hoy es texto libre, igual que en [[Flujo Editar perfil]]).
