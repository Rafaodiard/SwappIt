---
tipo: general
tags:
  - tipo/general
---
# Swappit · Inicio

> **Intercambiá. Conectá. Reutilizá.**
> Plataforma de intercambio de objetos sin dinero, para jóvenes de 20 a 30 años que se están independizando.

Esta vault documenta el código de Swappit tal como está en `main` de GitHub (commit `f639baa`, 29/10/2026, "pantalla incio") más el rediseño del inicio del 30/10, todavía sin commit. Cada nota de código es también un nodo del grafo que generó **graphify**: abrí la **vista de grafo** de Obsidian (Ctrl+G) para ver cómo se conecta todo.

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
| [[Flujo Buscar y filtrar]] | Funciona (texto, categoría, estado). El select de orden es solo visual |
| [[Flujo Ver detalle de artículo]] | Funciona |
| [[Flujo Publicar artículo]] | Funciona (con fotos) |
| [[Flujo Editar perfil]] | Funciona (con foto y descripción) |
| [[Flujo Perfil público]] | Funciona |
| [[Flujo Proponer intercambio]] | Funciona (proponer, aceptar, rechazar, cancelar, realizado) |
| [[Flujo Chat]] | Funciona (un chat por intercambio, se actualiza cada 4 s) |
| [[Flujo Notificaciones y favoritos]] | Notificaciones funcionan; favoritos no existe |

## Código
- **Controllers:** [[AccountController]] · [[ArticulosController]] · [[PublicarController]] · [[PerfilController]] · [[IntercambioController]] · [[ChatController]] · [[NotificacionesController]] · [[HomeController]]
- **Acceso a datos:** [[BD]] (todas las consultas SQL, con Dapper)
- **Modelos:** [[Usuarios]] · [[Articulos]] · [[Categorias]] · [[EstadosArticulos]] · [[EstadosIntercambios]] · [[Intercambios]] · [[Mensajes]] · [[Provincias]] · [[TipoNotificaciones]]
- **Ayudantes:** [[Contrasenas]] · [[SesionUsuario]] · [[Telefonos]]
- **ViewModels:** [[LoginViewModel]] · [[RegistroViewModel]] · [[EditarPerfilViewModel]] · [[PublicarArticuloViewModel]] · [[ArticuloCardViewModel]] · [[OpcionFiltroViewModel]] · [[IntercambioViewModel]] · [[NotificacionViewModel]] · [[ConversacionViewModel]]
- **Vistas:** [[Vista _Layout]] · [[Vista Home-Index]] · [[Vista Home-Inicio]] · [[Vista Intercambio-Index]] · [[Vista Intercambio-Detalle]] · [[Vista Chat-_Mensajes]] · [[Vista Notificaciones-_Lista]] · [[Vista _FilaIntercambio]] · [[Vista Articulos-Buscar]] · [[Vista Articulos-Detalle]] · [[Vista Publicar-Index]] · [[Vista Perfil-Index]] · [[Vista Perfil-Publico]] · [[Vista Account-Login]] · [[Vista Account-Registro]] · [[Vista Account-CambiarContrasena]] · [[Vista Chat-Index]] · [[Vista _CardObjeto]] · [[Vista _PopupNotificaciones]] · [[Vista Error]]
- **Frontend:** [[site.css]] · [[plantillas.js]] · [[imagenes.js]] · [[notificaciones.js]] · [[chat.js]] · [[buscar.js]] · [[articulo.js]] · [[perfil.js]] · [[publicar.js]] · [[favoritos.js]] (sin usar)
- **Base de datos:** [[Base de datos]] (tablas, stored procedures y scripts)
- **Proyecto:** [[Program.cs]] · [[Swappit.csproj]] · [[appsettings.json]] · [[launchSettings.json]]
