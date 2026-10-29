/****** Estados de artículos y de intercambios como tablas, para bases ya creadas.
   - EstadosArticulos (antes Estados): opciones de "Estado del objeto" en Publicar.
   - EstadosIntercambios: Pendiente, Aceptado, Rechazado y Realizado.
   - Articulos.Estado e Intercambios.Estado (texto) pasan a IdEstado, con clave foránea a su tabla.
   Los textos que ya había se convierten a su Id. Si alguno no coincide con un estado de la tabla,
   el script se corta antes de borrar la columna vieja y no se pierde nada.
   Se puede volver a ejecutar sin problema. ******/
USE [Base_De_Datos_Swappit]
GO
/****** 1. Estados -> EstadosArticulos (o se crea si la base no tenía tabla de estados). ******/
IF OBJECT_ID('dbo.Estados', 'U') IS NOT NULL AND OBJECT_ID('dbo.EstadosArticulos', 'U') IS NULL
BEGIN
	EXEC sp_rename 'dbo.Estados', 'EstadosArticulos'
	EXEC sp_rename 'dbo.EstadosArticulos.Id', 'IdEstadosArticulos', 'COLUMN'
	EXEC sp_rename 'dbo.PK_Estados', 'PK_EstadosArticulos', 'OBJECT'
END
GO
IF OBJECT_ID('dbo.EstadosArticulos', 'U') IS NULL
	CREATE TABLE [dbo].[EstadosArticulos](
		[IdEstadosArticulos] [int] IDENTITY(1,1) NOT NULL,
		[Nombre] [varchar](50) NOT NULL,
	 CONSTRAINT [PK_EstadosArticulos] PRIMARY KEY CLUSTERED ([IdEstadosArticulos] ASC)
	)
GO
SET IDENTITY_INSERT [dbo].[EstadosArticulos] ON
IF NOT EXISTS (SELECT 1 FROM [dbo].[EstadosArticulos] WHERE [IdEstadosArticulos] = 2) INSERT [dbo].[EstadosArticulos] ([IdEstadosArticulos], [Nombre]) VALUES (2, N'Muy buen estado')
IF NOT EXISTS (SELECT 1 FROM [dbo].[EstadosArticulos] WHERE [IdEstadosArticulos] = 3) INSERT [dbo].[EstadosArticulos] ([IdEstadosArticulos], [Nombre]) VALUES (3, N'Buen estado')
IF NOT EXISTS (SELECT 1 FROM [dbo].[EstadosArticulos] WHERE [IdEstadosArticulos] = 4) INSERT [dbo].[EstadosArticulos] ([IdEstadosArticulos], [Nombre]) VALUES (4, N'Usado')
SET IDENTITY_INSERT [dbo].[EstadosArticulos] OFF
GO
/****** 2. EstadosIntercambios. ******/
IF OBJECT_ID('dbo.EstadosIntercambios', 'U') IS NULL
	CREATE TABLE [dbo].[EstadosIntercambios](
		[IdEstadosIntercambios] [int] IDENTITY(1,1) NOT NULL,
		[Nombre] [varchar](50) NOT NULL,
	 CONSTRAINT [PK_EstadosIntercambios] PRIMARY KEY CLUSTERED ([IdEstadosIntercambios] ASC)
	)
GO
SET IDENTITY_INSERT [dbo].[EstadosIntercambios] ON
IF NOT EXISTS (SELECT 1 FROM [dbo].[EstadosIntercambios] WHERE [IdEstadosIntercambios] = 1) INSERT [dbo].[EstadosIntercambios] ([IdEstadosIntercambios], [Nombre]) VALUES (1, N'Pendiente')
IF NOT EXISTS (SELECT 1 FROM [dbo].[EstadosIntercambios] WHERE [IdEstadosIntercambios] = 2) INSERT [dbo].[EstadosIntercambios] ([IdEstadosIntercambios], [Nombre]) VALUES (2, N'Aceptado')
IF NOT EXISTS (SELECT 1 FROM [dbo].[EstadosIntercambios] WHERE [IdEstadosIntercambios] = 3) INSERT [dbo].[EstadosIntercambios] ([IdEstadosIntercambios], [Nombre]) VALUES (3, N'Rechazado')
IF NOT EXISTS (SELECT 1 FROM [dbo].[EstadosIntercambios] WHERE [IdEstadosIntercambios] = 4) INSERT [dbo].[EstadosIntercambios] ([IdEstadosIntercambios], [Nombre]) VALUES (4, N'Realizado')
SET IDENTITY_INSERT [dbo].[EstadosIntercambios] OFF
GO
/****** 3. Articulos.Estado (texto) -> Articulos.IdEstado.
   Lo que usa la columna vieja va con EXEC: si ya no existe, el lote igual compila. ******/
IF COL_LENGTH('dbo.Articulos', 'IdEstado') IS NULL
	ALTER TABLE [dbo].[Articulos] ADD [IdEstado] [int] NULL
GO
IF COL_LENGTH('dbo.Articulos', 'Estado') IS NOT NULL
BEGIN
	-- Los artículos de prueba viejos usaban otros nombres.
	EXEC(N'UPDATE [dbo].[Articulos] SET [Estado] = ''Muy buen estado'' WHERE [Estado] = ''Muy bueno''
		UPDATE [dbo].[Articulos] SET [Estado] = ''Buen estado'' WHERE [Estado] = ''Bueno''
		UPDATE a SET a.[IdEstado] = e.[IdEstadosArticulos]
		FROM [dbo].[Articulos] a INNER JOIN [dbo].[EstadosArticulos] e ON e.[Nombre] = a.[Estado]')
END
GO
IF EXISTS (SELECT 1 FROM [dbo].[Articulos] WHERE [IdEstado] IS NULL)
BEGIN
	RAISERROR(N'Hay artículos con un Estado que no está en EstadosArticulos. Se corta el script sin borrar Articulos.Estado: corregí esos valores y volvé a ejecutarlo.', 16, 1)
	SET NOEXEC ON
END
GO
IF COL_LENGTH('dbo.Articulos', 'Estado') IS NOT NULL
	ALTER TABLE [dbo].[Articulos] DROP COLUMN [Estado]
GO
ALTER TABLE [dbo].[Articulos] ALTER COLUMN [IdEstado] [int] NOT NULL
GO
IF OBJECT_ID('dbo.FK_Articulos_EstadosArticulos', 'F') IS NULL
	ALTER TABLE [dbo].[Articulos]  WITH CHECK ADD  CONSTRAINT [FK_Articulos_EstadosArticulos] FOREIGN KEY([IdEstado])
	REFERENCES [dbo].[EstadosArticulos] ([IdEstadosArticulos])
GO
/****** 4. Intercambios.Estado (texto) -> Intercambios.IdEstado. ******/
IF COL_LENGTH('dbo.Intercambios', 'IdEstado') IS NULL
	ALTER TABLE [dbo].[Intercambios] ADD [IdEstado] [int] NULL
GO
IF COL_LENGTH('dbo.Intercambios', 'Estado') IS NOT NULL
	EXEC(N'UPDATE i SET i.[IdEstado] = e.[IdEstadosIntercambios]
		FROM [dbo].[Intercambios] i INNER JOIN [dbo].[EstadosIntercambios] e ON e.[Nombre] = i.[Estado]')
GO
IF EXISTS (SELECT 1 FROM [dbo].[Intercambios] WHERE [IdEstado] IS NULL)
BEGIN
	RAISERROR(N'Hay intercambios con un Estado que no está en EstadosIntercambios. Se corta el script sin borrar Intercambios.Estado: corregí esos valores y volvé a ejecutarlo.', 16, 1)
	SET NOEXEC ON
END
GO
IF COL_LENGTH('dbo.Intercambios', 'Estado') IS NOT NULL
	ALTER TABLE [dbo].[Intercambios] DROP COLUMN [Estado]
GO
ALTER TABLE [dbo].[Intercambios] ALTER COLUMN [IdEstado] [int] NOT NULL
GO
IF OBJECT_ID('dbo.FK_Intercambios_EstadosIntercambios', 'F') IS NULL
	ALTER TABLE [dbo].[Intercambios]  WITH CHECK ADD  CONSTRAINT [FK_Intercambios_EstadosIntercambios] FOREIGN KEY([IdEstado])
	REFERENCES [dbo].[EstadosIntercambios] ([IdEstadosIntercambios])
GO
/****** 5. Stored procedures: siguen recibiendo el nombre del estado y guardan su Id. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID('dbo.RegistrarArticulo', 'P') IS NULL
	EXEC(N'CREATE PROCEDURE [dbo].[RegistrarArticulo] AS RETURN')
GO
ALTER PROCEDURE [dbo].[RegistrarArticulo]
	@nombre varchar(50),
	@descripcion varchar(50),
	@estado varchar(50),
    @usuario VARCHAR(50),
    @categoria VARCHAR(50)
AS
BEGIN
	    IF EXISTS (SELECT Usuario FROM Usuarios WHERE Usuario = @usuario)
        BEGIN
            IF EXISTS (SELECT Nombre FROM Categorias WHERE Nombre = @categoria) AND EXISTS (SELECT Nombre FROM EstadosArticulos WHERE Nombre = @estado)
            BEGIN
                INSERT INTO Articulos (Nombre, Descripcion, IdEstado, IdUsuarios, IdCategorias)
                VALUES(@nombre, @descripcion, (SELECT IdEstadosArticulos FROM EstadosArticulos WHERE Nombre = @estado), (SELECT IdUsuarios FROM Usuarios WHERE Usuario = @usuario), (SELECT IdCategorias
                FROM Categorias WHERE Nombre = @categoria))
            END
        END
END
GO
IF OBJECT_ID('dbo.RegistrarIntercambio', 'P') IS NULL
	EXEC(N'CREATE PROCEDURE [dbo].[RegistrarIntercambio] AS RETURN')
GO
ALTER PROCEDURE [dbo].[RegistrarIntercambio]
    @fecha DATE,
    @estado VARCHAR(50),
    @Usuario1 VARCHAR(50),
    @Usuario2 VARCHAR(50),
    @Articulo1 VARCHAR(50),
    @Articulo2 VARCHAR(50)
AS
BEGIN
    IF EXISTS (SELECT IdUsuarios FROM Usuarios WHERE Usuario = @Usuario1)
    BEGIN
        IF EXISTS (SELECT IdUsuarios FROM Usuarios WHERE Usuario = @Usuario2)
        BEGIN
            IF EXISTS (SELECT IdArticulos FROM Articulos WHERE Nombre = @Articulo1)
            BEGIN
                IF EXISTS (SELECT IdArticulos FROM Articulos WHERE Nombre = @Articulo2)
                BEGIN
                    IF @fecha < GETDATE() AND EXISTS (SELECT Nombre FROM EstadosIntercambios WHERE Nombre = @estado)
                    BEGIN
                        INSERT INTO Intercambios (Fecha, IdEstado, IdUsuarios1, IdUsuarios2, IdArticulos1, IdArticulos2)
                        VALUES
                            (@fecha, (SELECT IdEstadosIntercambios FROM EstadosIntercambios WHERE Nombre = @estado),
                             (SELECT IdUsuarios FROM Usuarios WHERE Usuario = @Usuario1),
                             (SELECT IdUsuarios FROM Usuarios WHERE Usuario = @Usuario2),
                             (SELECT IdArticulos FROM Articulos WHERE Nombre = @Articulo1),
                             (SELECT IdArticulos FROM Articulos WHERE Nombre = @Articulo2))
                    END
                END
            END
        END
    END
END
GO
SET NOEXEC OFF
GO
