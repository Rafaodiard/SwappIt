---
tipo: servicio
archivos:
  - "Services/EmailService.cs"
  - "Services/SmtpSettings.cs"
tags:
  - tipo/servicio
---
# EmailService

`Services/EmailService.cs` · Manda un mail por cada notificación nueva (propuesta recibida, aceptada, rechazada, intercambio cancelado, mensaje nuevo). Está registrado como singleton en [[Program.cs]] y lo usan [[IntercambioController]] y [[ChatController]] después de guardar la acción.

- `EnviarNotificaciones(creadas, url)`: arma el link de cada mail (chat o detalle del intercambio) y manda los mails en segundo plano (`Task.Run`), así la página no espera a Gmail.
- Los datos del mail (mail y nombre del destinatario, nombre del otro, los dos artículos) los trae `BD.GetDatosMailNotificacion` desde [[BD]]. **El destinatario es el `Mail` con el que se registró el usuario.**
- Si `Smtp:CarpetaPrueba` tiene valor, además guarda una copia `.eml` en esa carpeta (`MailsPrueba/`, ignorada por git). Sirve para ver qué se mandó y a quién.
- Los errores no cortan nada: se escriben en la consola de la app como `fail: Swappit.Services.EmailService`. Si el envío sale bien no se escribe nada.

## Recorrido de un mail
1. El controller llama al método de [[BD]] (`ProponerIntercambio`, `CambiarEstadoIntercambio`, `CancelarIntercambio`, `EnviarMensaje`) con una lista vacía de `NotificacionCreada`.
2. El SP de la acción crea las notificaciones adentro de su transacción ([[SP CrearNotificacion]]) y las devuelve en un segundo resultado; [[NotificacionesBD.LeerCreadas()]] las suma a la lista (desde el 17/11).
3. El controller llama a `EnviarNotificaciones`, que arma los links con `Url.Action` y sigue en segundo plano.
4. Por cada notificación: `GetDatosMailNotificacion` ([[SP GetDatosMailNotificacion]]), `CrearMail` (texto plano + HTML con la paleta), copia `.eml` y envío por SMTP.

Qué manda mail: Propuesta recibida (al dueño), Propuesta aceptada y rechazada (a quien propuso; al aceptar, las otras pendientes de esos artículos se rechazan solas y también avisan), Intercambio cancelado y Mensaje nuevo (a la otra persona, solo si no tenía otro "Mensaje nuevo" sin leer en ese chat). Marcar realizado no manda nada.

Tecnología: `System.Net.Mail` de .NET (sin paquetes NuGet), opciones de ASP.NET Core (`Configure<SmtpSettings>`) e inyección de dependencias en los controllers.

## Configuración (`SmtpSettings`, sección `Smtp`)
`Host`, `Port` (587), `EnableSsl` (true), `User`, `Password`, `From`, `FromName` ("Swappit") y `CarpetaPrueba`. Sin `Host` y `From` no sale ningún mail (solo el aviso en la consola).

- Desde el 05/11 (commit `61c70fb`, PR #13) la config de Gmail (`smtp.gmail.com`, cuenta swappit9@gmail.com con contraseña de aplicación) está en `appsettings.Development.json`, commiteada. Por eso en cualquier compu funciona sin user-secrets.
- Riesgo: la contraseña de aplicación queda en el historial del repo (privado). Lo recomendable es generar una nueva y guardarla con `dotnet user-secrets` en cada compu.

## Si no llega un mail
1. Mirar la copia en `MailsPrueba/`: si no está, la notificación no se creó o falta config.
2. Revisar el `To:` de esa copia: tiene que ser el mail real del usuario.
3. Si la dirección no existe, Gmail acepta el envío igual y manda el rebote ("Address not found") a la casilla de swappit9@gmail.com. La app no muestra error.
4. Si hay `fail: Swappit.Services.EmailService` en la consola, el problema es de Gmail (contraseña de aplicación, red).
5. Revisar spam.

Ver [[Flujo Notificaciones y favoritos]] y [[Bitácora]] (08/11).
