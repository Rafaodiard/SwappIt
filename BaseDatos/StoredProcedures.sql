/****** 3 de 3: Stored procedures. Ejecutar después de Estructura.sql. ******/
USE [Base_De_Datos_Swappit]
GO
/****** Object:  StoredProcedure [dbo].[ActualizarContrasena]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ActualizarContrasena]
	@idUsuario int,
	@contrasenaHash varchar(100)
AS
BEGIN
	UPDATE Usuarios SET Contraseña = @contrasenaHash 
	WHERE IdUsuarios = @idUsuario
END
GO
/****** Object:  StoredProcedure [dbo].[BorrarFotoUsuario]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[BorrarFotoUsuario]
	@idUsuario int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DELETE FROM Imagenes WHERE IdUsuarios = @idUsuario AND IdArticulos IS NULL
END
GO
/****** Object:  StoredProcedure [dbo].[GetArticuloById]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetArticuloById]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		SELECT IdArticulos, Nombre, Descripcion, IdEstado, IdUsuarios, IdCategorias, Ubicacion, ACambio
        FROM Articulos WHERE IdArticulos = @id
END
GO
/****** Object:  StoredProcedure [dbo].[GetArticulosCatalogo]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetArticulosCatalogo]
	@busqueda varchar(150) = NULL,
	@cantidad int = NULL,
	@categorias varchar(max) = NULL,
	@estados varchar(max) = NULL,
	@idUsuario int = NULL
AS
BEGIN
	-- @busqueda llega ya escapada para LIKE (BD.PatronBusqueda), por eso entra hasta el triple de Articulos.Nombre.
	-- @categorias y @estados: Ids separados por coma ('1,4'); NULL o vacío no filtra.
	-- Barrio: la ubicación que cargó el dueño al publicar; si no tiene, el barrio de su perfil.
	SET NOCOUNT ON;
	SELECT TOP (ISNULL(@cantidad, 2147483647)) a.IdArticulos, a.Nombre, e.Nombre AS Estado, COALESCE(NULLIF(a.Ubicacion, ''), u.Barrio) AS Barrio,
		(SELECT TOP 1 i.Ruta FROM Imagenes i WHERE i.IdArticulos = a.IdArticulos ORDER BY i.IdImagenes) AS Imagen
	FROM Articulos a
	INNER JOIN Usuarios u ON u.IdUsuarios = a.IdUsuarios
	INNER JOIN EstadosArticulos e ON e.IdEstadosArticulos = a.IdEstado
	WHERE (@busqueda IS NULL OR a.Nombre LIKE '%' + @busqueda + '%')
		AND (NULLIF(@categorias, '') IS NULL OR a.IdCategorias IN (SELECT CAST(value AS int) FROM STRING_SPLIT(@categorias, ',')))
		AND (NULLIF(@estados, '') IS NULL OR a.IdEstado IN (SELECT CAST(value AS int) FROM STRING_SPLIT(@estados, ',')))
		AND (@idUsuario IS NULL OR a.IdUsuarios = @idUsuario)
	ORDER BY a.IdArticulos DESC
END
GO
/****** Object:  StoredProcedure [dbo].[GetCategoriaById]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetCategoriaById]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT IdCategorias, Nombre FROM Categorias WHERE IdCategorias = @id
END
GO
/****** Object:  StoredProcedure [dbo].[GetCategorias]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetCategorias]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT IdCategorias, Nombre FROM Categorias ORDER BY Nombre
END
GO
/****** Object:  StoredProcedure [dbo].[GetEstadoArticuloById]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetEstadoArticuloById]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT IdEstadosArticulos, Nombre FROM EstadosArticulos WHERE IdEstadosArticulos = @id
END
GO
/****** Object:  StoredProcedure [dbo].[GetEstadosArticulos]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetEstadosArticulos]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT IdEstadosArticulos, Nombre FROM EstadosArticulos ORDER BY IdEstadosArticulos
END
GO
/****** Object:  StoredProcedure [dbo].[GetFiltroCategorias]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFiltroCategorias]
	@busqueda varchar(150) = NULL
AS
BEGIN
	-- @busqueda llega ya escapada para LIKE (BD.PatronBusqueda).
	SET NOCOUNT ON;
	SELECT CAST(c.IdCategorias AS varchar(10)) AS Valor, c.Nombre AS Texto, COUNT(a.IdArticulos) AS Cantidad
	FROM Categorias c
	LEFT JOIN Articulos a ON a.IdCategorias = c.IdCategorias
		AND (@busqueda IS NULL OR a.Nombre LIKE '%' + @busqueda + '%')
	GROUP BY c.IdCategorias, c.Nombre
	ORDER BY c.Nombre
END
GO
/****** Object:  StoredProcedure [dbo].[GetFiltroEstados]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFiltroEstados]
	@busqueda varchar(150) = NULL
AS
BEGIN
	-- @busqueda llega ya escapada para LIKE (BD.PatronBusqueda). Estados de mejor a peor.
	SET NOCOUNT ON;
	SELECT CAST(e.IdEstadosArticulos AS varchar(10)) AS Valor, e.Nombre AS Texto, COUNT(a.IdArticulos) AS Cantidad
	FROM EstadosArticulos e
	LEFT JOIN Articulos a ON a.IdEstado = e.IdEstadosArticulos
		AND (@busqueda IS NULL OR a.Nombre LIKE '%' + @busqueda + '%')
	GROUP BY e.IdEstadosArticulos, e.Nombre
	ORDER BY e.IdEstadosArticulos
END
GO
/****** Object:  StoredProcedure [dbo].[GetFotoUsuario]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetFotoUsuario]
	-- Add the parameters for the stored procedure here
	@idUsuario int
	AS
BEGIN
	SELECT TOP 1 Ruta FROM Imagenes WHERE IdUsuarios = @idUsuario AND IdArticulos IS NULL ORDER BY IdImagenes DESC
END
GO
/****** Object:  StoredProcedure [dbo].[GetImagenesArticulo]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetImagenesArticulo]
	-- Add the parameters for the stored procedure here
	@idArticulo int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT Ruta FROM Imagenes WHERE IdArticulos = @idArticulo ORDER BY IdImagenes
END
GO
/****** Object:  StoredProcedure [dbo].[GetProvinciaById]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetProvinciaById]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
	SELECT IdProvincia, Nombre 
	FROM Provincias 
	WHERE IdProvincia = @id
END
GO
/****** Object:  StoredProcedure [dbo].[GetProvincias]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetProvincias] 

AS
BEGIN
	SELECT IdProvincia, Nombre FROM Provincias ORDER BY Nombre
END
GO
/****** Object:  StoredProcedure [dbo].[GetUsuarioById]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[GetUsuarioById]
	@id int
AS
BEGIN
	SELECT IdUsuarios, Nombre, Apellido, Usuario, Mail, Telefono, Contraseña, Barrio,
        [Fecha nacimiento] AS FechaNacimiento, Edad, IdProvincias, Descripcion 
		FROM Usuarios
		 WHERE IdUsuarios = @id
END
GO
/****** Object:  StoredProcedure [dbo].[GetUsuarioByMail]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUsuarioByMail]
	@Mail varchar(50)
AS
BEGIN
 SELECT IdUsuarios, Nombre, Apellido, Usuario, Mail, Telefono, Contraseña, Barrio,
        [Fecha nacimiento] AS FechaNacimiento, Edad, IdProvincias, Descripcion FROM Usuarios
		WHERE Mail = @Mail
END
GO
/****** Object:  StoredProcedure [dbo].[GuardarFotoUsuario]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GuardarFotoUsuario]
	@idUsuario int,
	@ruta varchar(100)
	
	AS
BEGIN
	DELETE FROM Imagenes 
	WHERE IdUsuarios = @idUsuario AND IdArticulos IS NULL;
    INSERT INTO Imagenes (Ruta, IdUsuarios) VALUES (@ruta, @idUsuario)
END
GO
/****** Object:  StoredProcedure [dbo].[PublicarArticulo]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PublicarArticulo]
	@nombre varchar(50),
	@descripcion varchar(500),
	@idEstado int,
	@idUsuario int,
	@idCategoria int,
	@ubicacion varchar(100),
	@aCambio varchar(100) = NULL,
	@rutasFotos varchar(max) = NULL
AS
BEGIN
	-- Guarda el artículo y sus fotos en una transacción: si falla algo, no queda un artículo a medias.
	-- @rutasFotos: rutas separadas por '|' (no puede aparecer en un nombre de archivo); la primera es la portada.
	-- Devuelve el IdArticulos nuevo.
	SET NOCOUNT ON;
	SET XACT_ABORT ON;
	DECLARE @idArticulo int, @ruta varchar(max), @pos int

	BEGIN TRANSACTION
	INSERT INTO Articulos (Nombre, Descripcion, IdEstado, IdUsuarios, IdCategorias, Ubicacion, ACambio)
	VALUES (@nombre, @descripcion, @idEstado, @idUsuario, @idCategoria, @ubicacion, @aCambio)
	SET @idArticulo = SCOPE_IDENTITY()

	-- Se recorren en orden (STRING_SPLIT no lo garantiza): la portada es la foto de menor IdImagenes.
	WHILE LEN(@rutasFotos) > 0
	BEGIN
		SET @pos = CHARINDEX('|', @rutasFotos)
		IF @pos = 0 SET @pos = LEN(@rutasFotos) + 1
		SET @ruta = LEFT(@rutasFotos, @pos - 1)
		SET @rutasFotos = SUBSTRING(@rutasFotos, @pos + 1, LEN(@rutasFotos))
		IF @ruta <> '' INSERT INTO Imagenes (Ruta, IdArticulos) VALUES (@ruta, @idArticulo)
	END
	COMMIT TRANSACTION

	SELECT @idArticulo AS IdArticulos
END
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
            IF EXISTS (SELECT Nombre FROM Categorias WHERE Nombre = @categoria) AND EXISTS (SELECT Nombre FROM EstadosArticulos WHERE Nombre = @estado)
            BEGIN
                INSERT INTO Articulos (Nombre, Descripcion, IdEstado, IdUsuarios, IdCategorias)
                VALUES(@nombre, @descripcion, (SELECT IdEstadosArticulos FROM EstadosArticulos WHERE Nombre = @estado), (SELECT IdUsuarios FROM Usuarios WHERE Usuario = @usuario), (SELECT IdCategorias
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
/****** Object:  StoredProcedure [dbo].[UpdateUsuario]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateUsuario]
	@idUsuario int,
	@nombre varchar(50),
	@apellido varchar(50),
	@usuario varchar(50),
	@mail varchar(50),
	@telefono int,
	@contraseña varchar(100),
	@barrio varchar(50),
	@fechaNacimiento date,
	@edad int,
	@idProvincia int,
	@descripcion varchar(500)
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE Usuarios SET Nombre = @nombre, Apellido = @apellido, Usuario = @usuario, Mail = @mail,
		Telefono = @telefono, Contraseña = @contraseña, Barrio = @barrio, [Fecha nacimiento] = @fechaNacimiento,
		Edad = @edad, IdProvincias = @idProvincia, Descripcion = @descripcion
	WHERE IdUsuarios = @idUsuario
END
GO
/****** Object:  StoredProcedure [dbo].[UsuarioExiste]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UsuarioExiste]
	@mail varchar(50)
AS
BEGIN
	SELECT COUNT(*) FROM Usuarios WHERE Mail = @mail
END
GO
