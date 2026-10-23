/****** 3 de 3: Stored procedures. Ejecutar después de 1_estructura.sql. ******/
USE [Base_De_Datos_Swappit]
GO
/****** Object:  StoredProcedure [dbo].[RegistrarArticulo]    Script Date: 23/10/2026 09:04:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RegistrarArticulo]
	@nombre varchar(50),
	@descripcion varchar(50),
	@estado varchar(50),
    @usuario VARCHAR(50),
    @categoria VARCHAR(50)
AS
BEGIN
	    IF EXISTS (SELECT Usuario FROM Usuarios WHERE Usuario = @usuario)
        BEGIN
            IF EXISTS (SELECT Nombre FROM Categorias WHERE Nombre = @categoria)
            BEGIN
                INSERT INTO Articulos (Nombre, Descripcion, Estado, IdUsuarios, IdCategorias)
                VALUES(@nombre, @descripcion, @estado, (SELECT IdUsuarios FROM Usuarios WHERE Usuario = @usuario), (SELECT IdCategorias
                FROM Categorias WHERE Nombre = @categoria))
            END
        END
END
GO
/****** Object:  StoredProcedure [dbo].[RegistrarIntercambio]    Script Date: 23/10/2026 09:04:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RegistrarIntercambio]
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
                    IF @fecha < GETDATE()
                    BEGIN
                        INSERT INTO Intercambios (Fecha, Estado, IdUsuarios1, IdUsuarios2, IdArticulos1, IdArticulos2)
                        VALUES
                            (@fecha, @estado,
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
/****** Object:  StoredProcedure [dbo].[RegistrarMensaje]    Script Date: 23/10/2026 09:04:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RegistrarMensaje]
	@texto varchar(50),
	@fueVisto bit,
	@fechaEnviado date,
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
/****** Object:  StoredProcedure [dbo].[RegistrarUsuario]    Script Date: 23/10/2026 09:04:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RegistrarUsuario]
	@nombre varchar(50),
	@apellido varchar(50),
	@usuario varchar(50),
	@mail varchar(50),
	@telefono int,
	@contraseña varchar(50),
	@barrio varchar(50),
	@fechaNacimiento date,
	@idProvincia int
AS
BEGIN
	IF NOT EXISTS (SELECT Usuario FROM Usuarios WHERE Usuario = @usuario)
	BEGIN
		IF NOT EXISTS (SELECT Telefono FROM Usuarios WHERE Telefono = @telefono)
		BEGIN
			IF NOT EXISTS (SELECT Contraseña FROM Usuarios WHERE Contraseña = @contraseña)
			BEGIN
				INSERT INTO Usuarios (Nombre, Apellido, Usuario, Mail, Telefono, Contraseña, Barrio, [Fecha nacimiento], IdProvincias)
				VALUES(@nombre, @apellido, @usuario, @mail, @telefono, @contraseña, @barrio, @fechaNacimiento, @idProvincia)
			END
		END
	END
END
GO
