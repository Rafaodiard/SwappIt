/****** Descripción del perfil. Agrega la columna Usuarios.Descripcion (opcional, hasta 500 caracteres).
   Se puede volver a ejecutar sin problema. No hace falta tocar ningún procedure:
   la app registra y edita usuarios con consultas en BD.cs (Register / UpdateUsuario). ******/
USE [Base_De_Datos_Swappit]
GO
IF COL_LENGTH('dbo.Usuarios', 'Descripcion') IS NULL
	ALTER TABLE [dbo].[Usuarios] ADD [Descripcion] [varchar](500) NULL
GO
