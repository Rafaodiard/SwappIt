/****** Estados de los artículos (opciones de "Estado del objeto" en Publicar), para bases ya creadas.
   Crea la tabla Estados si no existe y carga los 4 estados que falten.
   Articulos.Estado guarda el Nombre del estado. Se puede volver a ejecutar sin problema. ******/
USE [Base_De_Datos_Swappit]
GO
IF OBJECT_ID('dbo.Estados', 'U') IS NULL
	CREATE TABLE [dbo].[Estados](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[Nombre] [varchar](50) NOT NULL,
	 CONSTRAINT [PK_Estados] PRIMARY KEY CLUSTERED ([Id] ASC)
	)
GO
SET IDENTITY_INSERT [dbo].[Estados] ON
IF NOT EXISTS (SELECT 1 FROM [dbo].[Estados] WHERE [Id] = 1) INSERT [dbo].[Estados] ([Id], [Nombre]) VALUES (1, N'Como nuevo')
IF NOT EXISTS (SELECT 1 FROM [dbo].[Estados] WHERE [Id] = 2) INSERT [dbo].[Estados] ([Id], [Nombre]) VALUES (2, N'Muy buen estado')
IF NOT EXISTS (SELECT 1 FROM [dbo].[Estados] WHERE [Id] = 3) INSERT [dbo].[Estados] ([Id], [Nombre]) VALUES (3, N'Buen estado')
IF NOT EXISTS (SELECT 1 FROM [dbo].[Estados] WHERE [Id] = 4) INSERT [dbo].[Estados] ([Id], [Nombre]) VALUES (4, N'Usado')
SET IDENTITY_INSERT [dbo].[Estados] OFF
GO
/****** Los artículos de prueba viejos usaban otros nombres. ******/
UPDATE [dbo].[Articulos] SET [Estado] = 'Muy buen estado' WHERE [Estado] = 'Muy bueno'
UPDATE [dbo].[Articulos] SET [Estado] = 'Buen estado' WHERE [Estado] = 'Bueno'
GO
