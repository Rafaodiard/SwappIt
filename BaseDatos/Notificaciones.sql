/****** Notificaciones y sus tipos, para bases ya creadas.
   - TipoNotificaciones: Propuesta recibida, Propuesta aceptada, Propuesta rechazada y Mensaje nuevo.
   - Notificaciones: aviso para un usuario sobre un intercambio, con su tipo, si ya la leyó y la fecha.
   Mismas tablas y claves foráneas que SQLSwappit.sql. Solo crea lo que falta (tablas, claves foráneas y tipos).
   Se puede volver a ejecutar sin problema. ******/
USE [Base_De_Datos_Swappit]
GO
/****** 1. TipoNotificaciones. ******/
IF OBJECT_ID('dbo.TipoNotificaciones', 'U') IS NULL
	CREATE TABLE [dbo].[TipoNotificaciones](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[Nombre] [varchar](50) NOT NULL,
	 CONSTRAINT [PK_TipoNotificaciones] PRIMARY KEY CLUSTERED ([Id] ASC)
	)
GO
SET IDENTITY_INSERT [dbo].[TipoNotificaciones] ON
IF NOT EXISTS (SELECT 1 FROM [dbo].[TipoNotificaciones] WHERE [Id] = 1) INSERT [dbo].[TipoNotificaciones] ([Id], [Nombre]) VALUES (1, N'Propuesta recibida')
IF NOT EXISTS (SELECT 1 FROM [dbo].[TipoNotificaciones] WHERE [Id] = 2) INSERT [dbo].[TipoNotificaciones] ([Id], [Nombre]) VALUES (2, N'Propuesta aceptada')
IF NOT EXISTS (SELECT 1 FROM [dbo].[TipoNotificaciones] WHERE [Id] = 3) INSERT [dbo].[TipoNotificaciones] ([Id], [Nombre]) VALUES (3, N'Propuesta rechazada')
IF NOT EXISTS (SELECT 1 FROM [dbo].[TipoNotificaciones] WHERE [Id] = 4) INSERT [dbo].[TipoNotificaciones] ([Id], [Nombre]) VALUES (4, N'Mensaje nuevo')
SET IDENTITY_INSERT [dbo].[TipoNotificaciones] OFF
GO
/****** 2. Notificaciones. ******/
IF OBJECT_ID('dbo.Notificaciones', 'U') IS NULL
	CREATE TABLE [dbo].[Notificaciones](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[IdUsuario] [int] NOT NULL,
		[IdIntercambio] [int] NOT NULL,
		[IdTipoNotificacion] [int] NOT NULL,
		[Leida] [bit] NOT NULL,
		[Fecha] [datetime] NOT NULL,
	 CONSTRAINT [PK_Notificaciones] PRIMARY KEY CLUSTERED ([Id] ASC)
	)
GO
/****** 3. Claves foráneas de Notificaciones. ******/
IF OBJECT_ID('dbo.FK_Notificaciones_Intercambios', 'F') IS NULL
	ALTER TABLE [dbo].[Notificaciones]  WITH CHECK ADD  CONSTRAINT [FK_Notificaciones_Intercambios] FOREIGN KEY([IdIntercambio])
	REFERENCES [dbo].[Intercambios] ([IdIntercambios])
GO
IF OBJECT_ID('dbo.FK_Notificaciones_TipoNotificaciones', 'F') IS NULL
	ALTER TABLE [dbo].[Notificaciones]  WITH CHECK ADD  CONSTRAINT [FK_Notificaciones_TipoNotificaciones] FOREIGN KEY([IdTipoNotificacion])
	REFERENCES [dbo].[TipoNotificaciones] ([Id])
GO
IF OBJECT_ID('dbo.FK_Notificaciones_Usuarios', 'F') IS NULL
	ALTER TABLE [dbo].[Notificaciones]  WITH CHECK ADD  CONSTRAINT [FK_Notificaciones_Usuarios] FOREIGN KEY([IdUsuario])
	REFERENCES [dbo].[Usuarios] ([IdUsuarios])
GO
