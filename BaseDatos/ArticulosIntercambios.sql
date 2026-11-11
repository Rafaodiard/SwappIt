/****** Para una base que ya existe: pasa los artículos de Intercambios (IdArticulos1 e IdArticulos2) a la tabla ArticulosIntercambios y actualiza los SP que los usaban. Se puede volver a ejecutar. ******/
USE [Base_De_Datos_Swappit]
GO
SET NOEXEC OFF
GO
IF COL_LENGTH('dbo.Intercambios', 'IdArticulos1') IS NOT NULL
BEGIN
	DECLARE @cruzados int
	EXEC sp_executesql N'SELECT @n = COUNT(*) FROM Intercambios i
		INNER JOIN Articulos a1 ON a1.IdArticulos = i.IdArticulos1
		INNER JOIN Articulos a2 ON a2.IdArticulos = i.IdArticulos2
		WHERE a1.IdUsuarios <> i.IdUsuarios1 OR a2.IdUsuarios <> i.IdUsuarios2',
		N'@n int OUTPUT', @n = @cruzados OUTPUT
	IF @cruzados > 0
	BEGIN
		RAISERROR(N'Hay %d intercambios con un artículo que no es de su usuario. No se cambió nada: corregilos y volvé a ejecutar el script.', 16, 1, @cruzados)
		SET NOEXEC ON
	END
END
GO
IF OBJECT_ID('dbo.ArticulosIntercambios', 'U') IS NULL
BEGIN
	CREATE TABLE [dbo].[ArticulosIntercambios](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[IdArticulo] [int] NOT NULL,
		[IdIntercambio] [int] NOT NULL,
	 CONSTRAINT [PK_ArticulosIntercambios] PRIMARY KEY CLUSTERED ([Id] ASC)
	) ON [PRIMARY]
END
GO
IF OBJECT_ID('dbo.UQ_ArticulosIntercambios', 'UQ') IS NULL
	ALTER TABLE [dbo].[ArticulosIntercambios] ADD CONSTRAINT [UQ_ArticulosIntercambios] UNIQUE NONCLUSTERED ([IdIntercambio], [IdArticulo])
GO
IF OBJECT_ID('dbo.FK_ArticulosIntercambios_Articulos', 'F') IS NULL
	ALTER TABLE [dbo].[ArticulosIntercambios] WITH CHECK ADD CONSTRAINT [FK_ArticulosIntercambios_Articulos] FOREIGN KEY([IdArticulo])
	REFERENCES [dbo].[Articulos] ([IdArticulos])
GO
IF OBJECT_ID('dbo.FK_ArticulosIntercambios_Intercambios', 'F') IS NULL
	ALTER TABLE [dbo].[ArticulosIntercambios] WITH CHECK ADD CONSTRAINT [FK_ArticulosIntercambios_Intercambios] FOREIGN KEY([IdIntercambio])
	REFERENCES [dbo].[Intercambios] ([IdIntercambios])
GO
IF COL_LENGTH('dbo.Intercambios', 'IdArticulos1') IS NOT NULL
BEGIN
	SET XACT_ABORT ON
	BEGIN TRANSACTION
	EXEC('INSERT INTO ArticulosIntercambios (IdArticulo, IdIntercambio)
		SELECT x.IdArticulo, x.IdIntercambio
		FROM (SELECT IdIntercambios AS IdIntercambio, IdArticulos1 AS IdArticulo, 1 AS Orden FROM Intercambios
			UNION ALL
			SELECT IdIntercambios, IdArticulos2, 2 FROM Intercambios) x
		WHERE NOT EXISTS (SELECT 1 FROM ArticulosIntercambios ai WHERE ai.IdIntercambio = x.IdIntercambio AND ai.IdArticulo = x.IdArticulo)
		ORDER BY x.IdIntercambio, x.Orden')
	IF OBJECT_ID('dbo.FK_Intercambios_Articulos', 'F') IS NOT NULL
		ALTER TABLE [dbo].[Intercambios] DROP CONSTRAINT [FK_Intercambios_Articulos]
	IF OBJECT_ID('dbo.FK_Intercambios_Articulos1', 'F') IS NOT NULL
		ALTER TABLE [dbo].[Intercambios] DROP CONSTRAINT [FK_Intercambios_Articulos1]
	EXEC('ALTER TABLE [dbo].[Intercambios] DROP COLUMN [IdArticulos1], [IdArticulos2]')
	COMMIT TRANSACTION
END
GO
IF OBJECT_ID('dbo.Complejos_Personalizado_GestionarPropuestaYNotificacion', 'P') IS NOT NULL
	DROP PROCEDURE [dbo].[Complejos_Personalizado_GestionarPropuestaYNotificacion]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Complejos_Personalizado_GestionarPropuestaYNotificacion]
    @IdIntercambio INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @IdIntercambio IS NULL OR NOT EXISTS (SELECT 1 FROM dbo.Intercambios WHERE IdIntercambios = @IdIntercambio)
    BEGIN
        PRINT 'Error: El código de intercambio especificado no existe.';
        RETURN;
    END

    DECLARE @IdUsuarioRecibe INT, @EstadoIntercambio INT;
    DECLARE @Prioridad VARCHAR(20) = 'Prioridad Normal';

    SELECT 
        @IdUsuarioRecibe = IdUsuarios2,
        @EstadoIntercambio = Intercambios.IdEstado
    FROM Intercambios 
    WHERE Intercambios.IdIntercambios = @IdIntercambio;

    IF @EstadoIntercambio <> 1
    BEGIN
        PRINT 'El intercambio no está en estado Pendiente.';
        RETURN;
    END

    IF EXISTS (
        SELECT 1 FROM dbo.ArticulosIntercambios ai
        INNER JOIN dbo.Articulos ofrecido ON ofrecido.IdArticulos = ai.IdArticulo AND ofrecido.IdUsuarios <> @IdUsuarioRecibe
        INNER JOIN dbo.Articulos a ON a.IdUsuarios = @IdUsuarioRecibe AND a.IdCategorias = ofrecido.IdCategorias
        WHERE ai.IdIntercambio = @IdIntercambio
    )
    BEGIN
        SET @Prioridad = 'Alta Prioridad';
    END

    IF NOT EXISTS (
        SELECT 1 FROM dbo.Notificaciones 
        WHERE IdIntercambio = @IdIntercambio AND IdTipoNotificacion = 1
    )
    BEGIN
        INSERT INTO dbo.Notificaciones (IdUsuario, IdIntercambio, IdTipoNotificacion, Leida, Fecha)
        VALUES (@IdUsuarioRecibe, @IdIntercambio, 1, 0, GETDATE());
    END

    SELECT 
        Intercambios.IdIntercambios,
        u1.Usuario AS UsuarioEmisor,
        u2.Usuario AS UsuarioReceptor,
        @Prioridad AS PrioridadIntercambio,
        'Notificación procesada correctamente' AS EstadoProceso
    FROM dbo.Intercambios 
    INNER JOIN dbo.Usuarios u1 ON Intercambios.IdUsuarios1 = u1.IdUsuarios
    INNER JOIN dbo.Usuarios u2 ON Intercambios.IdUsuarios2 = u2.IdUsuarios
    WHERE Intercambios.IdIntercambios = @IdIntercambio;
END;
GO
IF OBJECT_ID('dbo.Complejos_SeguimientoIntercambiosPendientes', 'P') IS NOT NULL
	DROP PROCEDURE [dbo].[Complejos_SeguimientoIntercambiosPendientes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Complejos_SeguimientoIntercambiosPendientes]
    @AntiguedadMinimaDias INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @AntiguedadMinimaDias IS NULL OR @AntiguedadMinimaDias < 0
    BEGIN
        PRINT 'Error: Ingrese una antigüedad válida en días.';
        RETURN;
    END

    SELECT 
        Intercambios.IdIntercambios,
        u1.Usuario AS Usuario1,
        u2.Usuario AS Usuario2,
        a1.Nombre AS Articulo1,
        a1.Cantidad AS CantidadOfrecidos,
        a2.Nombre AS Articulo2,
        DATEDIFF(DAY, Intercambios.Fecha, GETDATE()) AS DiasTranscurridos,
        COUNT(m.IdMensajes) AS MensajesTotales,
        ISNULL(SUM(CASE WHEN m.fueVisto = 0 THEN 1 ELSE 0 END), 0) AS MensajesNoVistos,
        CASE 
            WHEN COUNT(m.IdMensajes) = 0 THEN 'Sin comunicación'
            WHEN ISNULL(SUM(CASE WHEN m.fueVisto = 1 THEN 1 ELSE 0 END), 0) = 0 THEN 'Sin respuesta registrada'
            ELSE 'Con actividad'
        END AS Clasificacion
    FROM dbo.Intercambios 
    INNER JOIN Usuarios u1 ON Intercambios.IdUsuarios1 = u1.IdUsuarios
    INNER JOIN Usuarios u2 ON Intercambios.IdUsuarios2 = u2.IdUsuarios
    CROSS APPLY (SELECT TOP 1 a.Nombre, COUNT(*) OVER () AS Cantidad
        FROM ArticulosIntercambios ai
        INNER JOIN Articulos a ON a.IdArticulos = ai.IdArticulo
        WHERE ai.IdIntercambio = Intercambios.IdIntercambios AND a.IdUsuarios = Intercambios.IdUsuarios1
        ORDER BY ai.Id) a1
    CROSS APPLY (SELECT TOP 1 a.Nombre
        FROM ArticulosIntercambios ai
        INNER JOIN Articulos a ON a.IdArticulos = ai.IdArticulo
        WHERE ai.IdIntercambio = Intercambios.IdIntercambios AND a.IdUsuarios = Intercambios.IdUsuarios2
        ORDER BY ai.Id) a2
    LEFT JOIN Mensajes m ON Intercambios.IdIntercambios = m.IdIntercambio
    WHERE Intercambios.IdEstado = 1 -- Estado 1 = Pendiente
      AND DATEDIFF(DAY, Intercambios.Fecha, GETDATE()) >= @AntiguedadMinimaDias
    GROUP BY Intercambios.IdIntercambios, Intercambios.Fecha, u1.Usuario, u2.Usuario, a1.Nombre, a1.Cantidad, a2.Nombre
    ORDER BY DiasTranscurridos DESC;

    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'No hay intercambios pendientes que superen el límite de días ingresado.';
    END
END;
GO
IF OBJECT_ID('dbo.GetFiltroCategorias', 'P') IS NOT NULL
	DROP PROCEDURE [dbo].[GetFiltroCategorias]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFiltroCategorias]
	@busqueda varchar(150) = NULL,
	@excluirUsuario int = NULL,
	@comprometidos varchar(200) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SELECT CAST(c.IdCategorias AS varchar(10)) AS Valor, c.Nombre AS Texto, COUNT(a.IdArticulos) AS Cantidad
	FROM Categorias c
	LEFT JOIN Articulos a ON a.IdCategorias = c.IdCategorias
		AND (@busqueda IS NULL OR a.Nombre LIKE '%' + @busqueda + '%')
		AND (@excluirUsuario IS NULL OR a.IdUsuarios <> @excluirUsuario)
		AND NOT EXISTS (SELECT 1 FROM ArticulosIntercambios ai
			INNER JOIN Intercambios ic ON ic.IdIntercambios = ai.IdIntercambio
			INNER JOIN EstadosIntercambios eic ON eic.IdEstadosIntercambios = ic.IdEstado
			WHERE eic.Nombre IN (SELECT value FROM STRING_SPLIT(@comprometidos, ','))
				AND ai.IdArticulo = a.IdArticulos)
	GROUP BY c.IdCategorias, c.Nombre
	ORDER BY c.Nombre
END
GO
IF OBJECT_ID('dbo.GetFiltroEstados', 'P') IS NOT NULL
	DROP PROCEDURE [dbo].[GetFiltroEstados]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFiltroEstados]
	@busqueda varchar(150) = NULL,
	@excluirUsuario int = NULL,
	@comprometidos varchar(200) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SELECT CAST(e.IdEstadosArticulos AS varchar(10)) AS Valor, e.Nombre AS Texto, COUNT(a.IdArticulos) AS Cantidad
	FROM EstadosArticulos e
	LEFT JOIN Articulos a ON a.IdEstado = e.IdEstadosArticulos
		AND (@busqueda IS NULL OR a.Nombre LIKE '%' + @busqueda + '%')
		AND (@excluirUsuario IS NULL OR a.IdUsuarios <> @excluirUsuario)
		AND NOT EXISTS (SELECT 1 FROM ArticulosIntercambios ai
			INNER JOIN Intercambios ic ON ic.IdIntercambios = ai.IdIntercambio
			INNER JOIN EstadosIntercambios eic ON eic.IdEstadosIntercambios = ic.IdEstado
			WHERE eic.Nombre IN (SELECT value FROM STRING_SPLIT(@comprometidos, ','))
				AND ai.IdArticulo = a.IdArticulos)
	GROUP BY e.IdEstadosArticulos, e.Nombre
	ORDER BY e.IdEstadosArticulos
END
GO
IF OBJECT_ID('dbo.RegistrarIntercambio', 'P') IS NOT NULL
	DROP PROCEDURE [dbo].[RegistrarIntercambio]
GO
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
                        SET XACT_ABORT ON
                        BEGIN TRANSACTION
                        INSERT INTO Intercambios (Fecha, IdEstado, IdUsuarios1, IdUsuarios2)
                        VALUES
                            (@fecha, (SELECT IdEstadosIntercambios FROM EstadosIntercambios WHERE Nombre = @estado),
                             (SELECT IdUsuarios FROM Usuarios WHERE Usuario = @Usuario1),
                             (SELECT IdUsuarios FROM Usuarios WHERE Usuario = @Usuario2))
                        DECLARE @idIntercambio int = SCOPE_IDENTITY()
                        INSERT INTO ArticulosIntercambios (IdArticulo, IdIntercambio)
                        VALUES
                            ((SELECT IdArticulos FROM Articulos WHERE Nombre = @Articulo1), @idIntercambio),
                            ((SELECT IdArticulos FROM Articulos WHERE Nombre = @Articulo2), @idIntercambio)
                        COMMIT TRANSACTION
                    END
                END
            END
        END
    END
END
GO
SELECT i.IdIntercambios, e.Nombre AS Estado, ai.IdArticulo, a.Nombre AS Articulo,
	CASE WHEN a.IdUsuarios = i.IdUsuarios1 THEN 'Ofrecido' WHEN a.IdUsuarios = i.IdUsuarios2 THEN 'Pedido' ELSE 'De otro usuario' END AS Lado
FROM Intercambios i
INNER JOIN EstadosIntercambios e ON e.IdEstadosIntercambios = i.IdEstado
INNER JOIN ArticulosIntercambios ai ON ai.IdIntercambio = i.IdIntercambios
INNER JOIN Articulos a ON a.IdArticulos = ai.IdArticulo
ORDER BY i.IdIntercambios, ai.Id
GO
SET NOEXEC OFF
GO
