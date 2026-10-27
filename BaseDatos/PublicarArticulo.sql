/****** Publicar artículos. Solo hace falta en bases creadas antes de que los scripts de creación
   (SQLSwappit.sql, SQLSwappit_CualquierCompu.sql y BaseDatos/) trajeran estos cambios.
   Se puede volver a ejecutar sin problema. ******/
USE [Base_De_Datos_Swappit]
GO
/****** 1. Articulos.Descripcion pasa de varchar(50) a varchar(500): Publicar acepta hasta 500 caracteres. ******/
IF COL_LENGTH('dbo.Articulos', 'Descripcion') < 500
	ALTER TABLE [dbo].[Articulos] ALTER COLUMN [Descripcion] [varchar](500) NOT NULL
GO
/****** 2. Dónde está el objeto y qué le gustaría recibir a cambio a quien lo publica.
   Opcionales: los artículos de prueba no los tienen (la app usa el barrio del dueño y "Abierto a propuestas"). ******/
IF COL_LENGTH('dbo.Articulos', 'Ubicacion') IS NULL
	ALTER TABLE [dbo].[Articulos] ADD [Ubicacion] [varchar](100) NULL
GO
IF COL_LENGTH('dbo.Articulos', 'ACambio') IS NULL
	ALTER TABLE [dbo].[Articulos] ADD [ACambio] [varchar](100) NULL
GO
/****** 3. Estados con los mismos nombres que ofrece Publicar:
   "Como nuevo", "Muy buen estado", "Buen estado" y "Usado". ******/
UPDATE [dbo].[Articulos] SET [Estado] = 'Muy buen estado' WHERE [Estado] = 'Muy bueno'
UPDATE [dbo].[Articulos] SET [Estado] = 'Buen estado' WHERE [Estado] = 'Bueno'
GO
