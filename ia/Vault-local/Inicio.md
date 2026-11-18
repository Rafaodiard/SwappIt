---
tipo: general
tags:
  - tipo/general
---
# Swappit · Inicio

> **Intercambiá. Conectá. Reutilizá.**
> Plataforma de intercambio de objetos sin dinero, para jóvenes de 20 a 30 años que se están independizando.

Esta vault documenta el código de Swappit tal como está en `main` de GitHub (commit `cc3a330`, 28/10/2026, "stored procedures"). Cada nota de código es también un nodo del grafo que generó **graphify**: abrí la **vista de grafo** de Obsidian (Ctrl+G) para ver cómo se conecta todo.

## Por dónde empezar
- [[Memoria del proyecto]]: memoria de Claude (reglas, decisiones, equipo, bitácora). Se lee antes de trabajar y se actualiza siempre.
- [[Arquitectura]]: cómo está armado el proyecto (MVC + Dapper + SQL Server).
- [[Cómo usar esta vault]]: carpetas, colores del grafo y cómo regenerarlo.
- [[Pendientes y problemas]]: lo que falta y los errores conocidos.
- [[Convenciones y decisiones]]: reglas del equipo (ViewBag, scripts SQL, fuentes, paleta).
- [[Historial del repo]]: quién hizo qué y cuándo.
- [[Reporte del grafo]]: el informe de graphify (nodos más conectados, comunidades).

## Flujos de usuario
| Flujo | Estado |
|---|---|
| [[Flujo Registro]] | Funciona |
| [[Flujo Iniciar sesión]] | Funciona (con hash de contraseñas) |
| [[Flujo Cerrar sesión]] | Funciona |
| [[Flujo Cambiar contraseña]] | Funciona, pero ninguna vista linkea a la pantalla |
| [[Flujo Buscar y filtrar]] | Funciona (texto, categoría, estado). Distancia y orden son solo visuales |
| [[Flujo Ver detalle de artículo]] | Funciona |
| [[Flujo Publicar artículo]] | Funciona (con fotos) |
| [[Flujo Editar perfil]] | Funciona (con foto y descripción) |
| [[Flujo Perfil público]] | Funciona |
| [[Flujo Proponer intercambio]] | Solo visual: no se guarda |
| [[Flujo Chat]] | Solo visual: datos de ejemplo en el HTML |
| [[Flujo Notificaciones y favoritos]] | Solo visual |

## Código
- **Controllers:** [[AccountController]] · [[ArticulosController]] · [[PublicarController]] · [[PerfilController]] · [[ChatController]] · [[HomeController]]
- **Acceso a datos:** [[BD]] (todas las consultas SQL, con Dapper)
- **Modelos:** [[Usuarios]] · [[Articulos]] · [[Categorias]] · [[EstadosArticulos]] · [[EstadosIntercambios]] · [[Intercambios]] · [[Mensajes]] · [[Provincias]]
- **Ayudantes:** [[Contrasenas]] · [[SesionUsuario]] · [[Telefonos]]
- **ViewModels:** [[LoginViewModel]] · [[RegistroViewModel]] · [[EditarPerfilViewModel]] · [[PublicarArticuloViewModel]] · [[ArticuloCardViewModel]] · [[OpcionFiltroViewModel]]
- **Vistas:** [[Vista _Layout]] · [[Vista Home-Index]] · [[Vista Articulos-Buscar]] · [[Vista Articulos-Detalle]] · [[Vista Publicar-Index]] · [[Vista Perfil-Index]] · [[Vista Perfil-Publico]] · [[Vista Account-Login]] · [[Vista Account-Registro]] · [[Vista Account-CambiarContrasena]] · [[Vista Chat-Index]] · [[Vista _CardObjeto]] · [[Vista _PopupNotificaciones]] · [[Vista Error]]
- **Frontend:** [[site.css]] · [[plantillas.js]] · [[imagenes.js]] · [[favoritos.js]] · [[notificaciones.js]] · [[buscar.js]] · [[articulo.js]] · [[perfil.js]] · [[publicar.js]]
- **Base de datos:** [[Base de datos]] (tablas, stored procedures y scripts)
- **Proyecto:** [[Program.cs]] · [[Swappit.csproj]] · [[appsettings.json]] · [[launchSettings.json]]
