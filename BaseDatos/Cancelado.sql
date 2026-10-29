/****** Cancelar intercambios, para bases ya creadas.
   - EstadosIntercambios: agrega Cancelado.
   - TipoNotificaciones: agrega Intercambio cancelado (necesita BaseDatos/Notificaciones.sql ya ejecutado).
   Los mismos datos ya están en SQLSwappit.sql, Datos.sql, Estados.sql y Notificaciones.sql.
   Se puede volver a ejecutar sin problema. Después de ejecutarlo se puede borrar. ******/
USE [Base_De_Datos_Swappit]
GO
SET IDENTITY_INSERT [dbo].[EstadosIntercambios] ON
IF NOT EXISTS (SELECT 1 FROM [dbo].[EstadosIntercambios] WHERE [IdEstadosIntercambios] = 5) INSERT [dbo].[EstadosIntercambios] ([IdEstadosIntercambios], [Nombre]) VALUES (5, N'Cancelado')
SET IDENTITY_INSERT [dbo].[EstadosIntercambios] OFF
GO
SET IDENTITY_INSERT [dbo].[TipoNotificaciones] ON
IF NOT EXISTS (SELECT 1 FROM [dbo].[TipoNotificaciones] WHERE [Id] = 5) INSERT [dbo].[TipoNotificaciones] ([Id], [Nombre]) VALUES (5, N'Intercambio cancelado')
SET IDENTITY_INSERT [dbo].[TipoNotificaciones] OFF
GO
