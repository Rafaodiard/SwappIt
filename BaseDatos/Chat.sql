/****** Chat de los intercambios, para bases ya creadas.
   - Mensajes.Texto pasa de varchar(50) a varchar(500): 50 caracteres no alcanzan para un mensaje.
   - Mensajes.FechaEnviado y FechaRecibido pasan de date a datetime: el chat muestra la hora de cada mensaje.
   - El SP RegistrarMensaje recibe @texto varchar(500) y @fechaEnviado datetime, igual que la tabla.
   Mismos tipos que SQLSwappit.sql. Se puede volver a ejecutar sin problema (los mensajes que ya haya se conservan). ******/
USE [Base_De_Datos_Swappit]
GO
/****** 1. Columnas de Mensajes. ******/
IF COL_LENGTH('dbo.Mensajes', 'Texto') < 500
	ALTER TABLE [dbo].[Mensajes] ALTER COLUMN [Texto] [varchar](500) NOT NULL
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Mensajes') AND name = 'FechaEnviado' AND TYPE_NAME(system_type_id) = 'date')
	ALTER TABLE [dbo].[Mensajes] ALTER COLUMN [FechaEnviado] [datetime] NOT NULL
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Mensajes') AND name = 'FechaRecibido' AND TYPE_NAME(system_type_id) = 'date')
	ALTER TABLE [dbo].[Mensajes] ALTER COLUMN [FechaRecibido] [datetime] NULL
GO
/****** 2. SP RegistrarMensaje con los tipos nuevos. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[RegistrarMensaje]
	@texto varchar(500),
	@fueVisto bit,
	@fechaEnviado datetime,
	@usuariomanda varchar(50),
	@usuariorecibe varchar(50),
	@idIntercambio int

AS
BEGIN
    IF EXISTS (SELECT Usuario FROM Usuarios WHERE Usuario = @usuariomanda)
    BEGIN
        IF EXISTS (SELECT Usuario FROM Usuarios WHERE Usuario = @usuariorecibe)
        BEGIN
            IF EXISTS (SELECT IdIntercambios FROM Intercambios WHERE IdIntercambios = @idIntercambio)
            BEGIN
                INSERT INTO Mensajes (Texto, fueVisto, FechaEnviado, FechaRecibido, IdUsuariosManda, IdIntercambio)
                VALUES (@texto, @fueVisto, @fechaEnviado, @fechaEnviado,
                     (SELECT IdUsuarios FROM Usuarios WHERE Usuario = @usuariomanda), @idIntercambio)
            END
        END
    END
END
GO
