/****** Contraseñas hasheadas. Solo hace falta en bases creadas antes de que los scripts de creación
   (SQLSwappit.sql, SQLSwappit_CualquierCompu.sql y BaseDatos/) ya trajeran Contraseña varchar(100).
   Se puede volver a ejecutar sin problema. ******/
USE [Base_De_Datos_Swappit]
GO
/****** 1. Usuarios.Contraseña pasa de varchar(50) a varchar(100): el hash ocupa 84 caracteres. ******/
IF COL_LENGTH('dbo.Usuarios', 'Contraseña') < 100
	ALTER TABLE [dbo].[Usuarios] ALTER COLUMN [Contraseña] [varchar](100) NOT NULL
GO
/****** 2. RegistrarUsuario: se saca el control de "contraseña ya usada por otro usuario".
   Con hash nunca coincide (cada hash tiene su propia sal) y, además, le avisaba a quien se registraba
   que otra persona usa esa contraseña. Lo demás queda igual que antes.
   La app no usa este procedure (registra con un INSERT en BD.Register). ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[RegistrarUsuario]
	@nombre varchar(50),
	@apellido varchar(50),
	@usuario varchar(50),
	@mail varchar(50),
	@telefono int,
	@contraseña varchar(100),
	@barrio varchar(50),
	@fechaNacimiento date,
	@idProvincia int
AS
BEGIN
	IF NOT EXISTS (SELECT Usuario FROM Usuarios WHERE Usuario = @usuario)
	BEGIN
		IF NOT EXISTS (SELECT Telefono FROM Usuarios WHERE Telefono = @telefono)
		BEGIN
			INSERT INTO Usuarios (Nombre, Apellido, Usuario, Mail, Telefono, Contraseña, Barrio, [Fecha nacimiento], IdProvincias)
			VALUES(@nombre, @apellido, @usuario, @mail, @telefono, @contraseña, @barrio, @fechaNacimiento, @idProvincia)
		END
	END
END
GO
