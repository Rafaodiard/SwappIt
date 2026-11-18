---
tipo: controller
comunidad: "Controllers, vistas y JS"
archivos:
  - "Controllers/AccountController.cs"
graphify_ids:
  - "controllers_accountcontroller_swappit_controllers_accountcontroller"
  - "controllers_accountcontroller"
tags:
  - tipo/controller
  - comunidad/Controllers_vistas_y_JS
---
# AccountController

`Controllers/AccountController.cs` · Cuenta del usuario: iniciar sesión, registrarse, cambiar la contraseña y cerrar sesión. Ver y editar el perfil está en [[PerfilController]].

| Acción | Verbo | Qué hace | Vista |
|---|---|---|---|
| `Index()` | GET `/Account` | Muestra el login | [[Vista Account-Login]] |
| `Registro()` | GET | Form de registro | [[Vista Account-Registro]] |
| `CambiarContrasena()` | GET | Pide sesión | [[Vista Account-CambiarContrasena]] |
| `Login(LoginViewModel)` | POST | [[Flujo Iniciar sesión]] | Login o redirect a Home |
| `Registro(RegistroViewModel, password2)` | POST | [[Flujo Registro]] | Registro o redirect a Home |
| `CambiarContrasena(actual, nueva, confirmar)` | POST | [[Flujo Cambiar contraseña]] | misma vista |
| `Logout()` | GET | [[Flujo Cerrar sesión]] | redirect al login |
| `CalcularEdad(fecha)` | privado | Edad a partir de la fecha de nacimiento | — |

Usa [[BD]], [[Contrasenas]], [[SesionUsuario]], [[Telefonos]], [[LoginViewModel]], [[RegistroViewModel]]. Errores a la vista con `ViewBag.Error`.

Comunidad del grafo: [[Comunidad - Controllers, vistas y JS]]

## Conexiones en el grafo (graphify)
- contiene [[Namespace Swappit.Controllers]] · `contains` EXTRACTED
- importa [[Microsoft.AspNetCore.Mvc]] · `imports` EXTRACTED
- importa [[Namespace Swappit.Models]] · `imports` EXTRACTED
- importa [[Namespace Swappit.Models.ViewModels]] · `imports` EXTRACTED
- hereda de [[Controller (ASP.NET MVC)]] · `inherits` EXTRACTED
- tiene el método [[AccountController.CalcularEdad()]] · `method` EXTRACTED
- tiene el método [[AccountController.CambiarContrasena() GET]] · `method` EXTRACTED
- tiene el método [[AccountController.CambiarContrasena() POST]] · `method` EXTRACTED
- tiene el método [[AccountController.Index()]] · `method` EXTRACTED
- tiene el método [[AccountController.Login()]] · `method` EXTRACTED
- tiene el método [[AccountController.Logout()]] · `method` EXTRACTED
- tiene el método [[AccountController.Registro() GET]] · `method` EXTRACTED
- tiene el método [[AccountController.Registro() POST]] · `method` EXTRACTED
