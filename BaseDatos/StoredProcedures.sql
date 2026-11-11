/****** 3 de 3: Stored procedures. Ejecutar después de Estructura.sql. ******/
USE [Base_De_Datos_Swappit]
GO
/****** Object:  StoredProcedure [dbo].[ActualizarContrasena]    Script Date: 29/10/2026 13:39:32 ******/
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
/****** Object:  StoredProcedure [dbo].[BorrarFotoUsuario]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[BorrarFotoUsuario]
	@idUsuario int
AS
BEGIN
	SET NOCOUNT ON;
	DELETE FROM Imagenes WHERE IdUsuarios = @idUsuario AND IdArticulos IS NULL
END
GO
/****** Object:  StoredProcedure [dbo].[Complejos_Ejecucion]    Script Date: 6/11/2026 08:55:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Complejos_Ejecucion]

AS
BEGIN

EXEC Complejos_EstadisticasUsuario @IdUsuario = 3
EXEC Complejos_RankingCategoriasIntercambiadas @MinIntercambios = 1
EXEC Complejos_RecomendarUsuariosIntercambio @IdUsuarioConsultado = 4
EXEC Complejos_SeguimientoIntercambiosPendientes @AntiguedadMinimaDias = 0
EXEC Complejos_RendimientoPlataformaPorPeriodo @FechaDesde = '2025-01-01', @FechaHasta = '2026-12-31'
EXEC Complejos_Personalizado_GestionarPropuestaYNotificacion @IdIntercambio = 1

END
GO
/****** Object:  StoredProcedure [dbo].[Complejos_EstadisticasUsuario]    Script Date: 6/11/2026 08:55:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Complejos_EstadisticasUsuario]
    @IdUsuario INT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM dbo.Usuarios WHERE IdUsuarios = @IdUsuario)
    BEGIN
        PRINT 'Error: El usuario no existe.';
        RETURN;
    END

    DECLARE @ArticulosPublicados INT;
    DECLARE @CategoriasDiferentes INT;
    DECLARE @IntercambiosParticipo INT;
    DECLARE @OperacionesConcretadas INT;
    DECLARE @PorcentajeConcrecion DECIMAL(5,2);
    DECLARE @Clasificacion VARCHAR(20);

    SELECT 
        @ArticulosPublicados = COUNT(IdArticulos),
        @CategoriasDiferentes = COUNT(DISTINCT IdCategorias)
    FROM dbo.Articulos
    WHERE IdUsuarios = @IdUsuario;

    SELECT 
        @IntercambiosParticipo = COUNT(*),
        @OperacionesConcretadas = ISNULL(SUM(CASE WHEN IdEstado = 4 THEN 1 ELSE 0 END), 0)
    FROM dbo.Intercambios
    WHERE IdUsuarios1 = @IdUsuario OR IdUsuarios2 = @IdUsuario;

    IF @IntercambiosParticipo = 0
    BEGIN
        SELECT 
            @ArticulosPublicados AS ArticulosPublicados,
            @CategoriasDiferentes AS CategoriasDiferentes,
            0 AS IntercambiosParticipo,
            0 AS OperacionesConcretadas,
            0.00 AS PorcentajeConcrecion,
            'Principiante' AS Clasificacion;
        RETURN;
    END

    SET @PorcentajeConcrecion = (CAST(@OperacionesConcretadas AS DECIMAL(10,2)) / @IntercambiosParticipo) * 100.0;

    IF @PorcentajeConcrecion >= 70.0
        SET @Clasificacion = 'Experto';
    ELSE IF @PorcentajeConcrecion >= 40.0
        SET @Clasificacion = 'Activo';
    ELSE
        SET @Clasificacion = 'Principiante';

    SELECT 
        @ArticulosPublicados AS ArticulosPublicados,
        @CategoriasDiferentes AS CategoriasDiferentes,
        @IntercambiosParticipo AS IntercambiosParticipo,
        @OperacionesConcretadas AS OperacionesConcretadas,
        @PorcentajeConcrecion AS PorcentajeConcrecion,
        @Clasificacion AS Clasificacion;
END;
GO
/****** Object:  StoredProcedure [dbo].[Complejos_Personalizado_GestionarPropuestaYNotificacion]    Script Date: 6/11/2026 08:55:40 ******/
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
/****** Object:  StoredProcedure [dbo].[Complejos_RecomendarUsuariosIntercambio]    Script Date: 6/11/2026 08:55:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Complejos_RecomendarUsuariosIntercambio]
    @IdUsuarioConsultado INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE IdUsuarios = @IdUsuarioConsultado)
    BEGIN
        PRINT 'El usuario consultado no existe';
        RETURN;
    END

    DECLARE @IdProvincia INT;
    SELECT @IdProvincia = IdProvincias FROM dbo.Usuarios WHERE IdUsuarios = @IdUsuarioConsultado;

    SELECT 
        Usuarios.IdUsuarios,
        Usuarios.Usuario,
        COUNT(DISTINCT a.IdArticulos) AS ArticulosDisponibles,
        COUNT(DISTINCT a.IdCategorias) AS VariedadCategorias
    FROM dbo.Usuarios 
    INNER JOIN dbo.Articulos a ON Usuarios.IdUsuarios = a.IdUsuarios
    WHERE Usuarios.IdProvincias = @IdProvincia
      AND Usuarios.IdUsuarios <> @IdUsuarioConsultado
      AND a.IdCategorias NOT IN (
          SELECT DISTINCT IdCategorias 
          FROM dbo.Articulos
          WHERE IdUsuarios = @IdUsuarioConsultado
      )
    GROUP BY Usuarios.IdUsuarios, Usuarios.Usuario
    ORDER BY VariedadCategorias DESC, ArticulosDisponibles DESC;

    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'No se encontraron usuarios recomendados para intercambiar';
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[Complejos_RendimientoPlataformaPorPeriodo]    Script Date: 6/11/2026 08:55:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Complejos_RendimientoPlataformaPorPeriodo]
    @FechaDesde DATE,
    @FechaHasta DATE
AS
BEGIN
    SET NOCOUNT ON;

    IF @FechaDesde IS NULL OR @FechaHasta IS NULL OR @FechaDesde > @FechaHasta
    BEGIN
        PRINT 'Error: Rango de fechas inválido.';
        RETURN;
    END

    DECLARE @Totales INT, @Completados INT, @Pendientes INT;
    DECLARE @UsuariosUnicos INT;
    DECLARE @PromedioPorUsuario DECIMAL(10,2);
    DECLARE @ProvinciaMasActiva VARCHAR(50);
    DECLARE @PorcentajeCompletados DECIMAL(5,2);
    DECLARE @Clasificacion VARCHAR(20);

    SELECT 
        @Totales = COUNT(*),
        @Completados = ISNULL(SUM(CASE WHEN IdEstado = 4 THEN 1 ELSE 0 END), 0), -- 4: Realizado
        @Pendientes = ISNULL(SUM(CASE WHEN IdEstado = 1 THEN 1 ELSE 0 END), 0)   -- 1: Pendiente
    FROM dbo.Intercambios
    WHERE Fecha BETWEEN @FechaDesde AND @FechaHasta;

    IF @Totales = 0 OR @Totales IS NULL
    BEGIN
        PRINT 'No se registraron datos en el período ingresado.';
        RETURN;
    END

    SELECT @UsuariosUnicos = COUNT(DISTINCT IdUsuario)
    FROM (
        SELECT IdUsuarios1 AS IdUsuario FROM dbo.Intercambios WHERE Fecha BETWEEN @FechaDesde AND @FechaHasta
        UNION
        SELECT IdUsuarios2 AS IdUsuario FROM dbo.Intercambios WHERE Fecha BETWEEN @FechaDesde AND @FechaHasta
    ) AS Participantes;

    SET @PromedioPorUsuario = CAST(@Totales AS DECIMAL(10,2)) / @UsuariosUnicos;

    SELECT TOP 1 @ProvinciaMasActiva = p.Nombre
    FROM dbo.Provincias p
    INNER JOIN dbo.Usuarios u ON p.IdProvincia = u.IdProvincias
    INNER JOIN (
        SELECT IdUsuarios1 AS IdUsuario FROM dbo.Intercambios WHERE Fecha BETWEEN @FechaDesde AND @FechaHasta
        UNION
        SELECT IdUsuarios2 AS IdUsuario FROM dbo.Intercambios WHERE Fecha BETWEEN @FechaDesde AND @FechaHasta
    ) AS Part ON u.IdUsuarios = Part.IdUsuario
    GROUP BY p.IdProvincia, p.Nombre
    ORDER BY COUNT(DISTINCT u.IdUsuarios) DESC;

    SET @PorcentajeCompletados = (CAST(@Completados AS DECIMAL(10,2)) / @Totales) * 100.0;

    IF @PorcentajeCompletados >= 70.0
        SET @Clasificacion = 'Excelente';
    ELSE IF @PorcentajeCompletados >= 40.0
        SET @Clasificacion = 'Aceptable';
    ELSE
        SET @Clasificacion = 'Bajo';

    SELECT 
        @Totales AS IntercambiosTotales,
        @Completados AS IntercambiosCompletados,
        @Pendientes AS IntercambiosPendientes,
        @UsuariosUnicos AS UsuariosParticipantesDiferentes,
        @PromedioPorUsuario AS PromedioIntercambiosPorUsuario,
        ISNULL(@ProvinciaMasActiva, 'Sin datos') AS ProvinciaMasParticipantes,
        @PorcentajeCompletados AS PorcentajeCompletados,
        @Clasificacion AS ClasificacionRendimiento;
END;
GO
/****** Object:  StoredProcedure [dbo].[Complejos_SeguimientoIntercambiosPendientes]    Script Date: 6/11/2026 08:55:40 ******/
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
/****** Object:  StoredProcedure [dbo].[GetArticuloById]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetArticuloById]
	@id int
AS
BEGIN
	SET NOCOUNT ON;

		SELECT IdArticulos, Nombre, Descripcion, IdEstado, IdUsuarios, IdCategorias, Ubicacion, FechaPublicacion, IdCategoriaACambio
        FROM Articulos WHERE IdArticulos = @id
END
GO
/****** Object:  StoredProcedure [dbo].[GetArticulosCatalogo]    Script Date: 29/10/2026 13:39:32 ******/
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
/****** Object:  StoredProcedure [dbo].[GetCantidadNotificacionesNoLeidas]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCantidadNotificacionesNoLeidas]
	@idUsuario int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT COUNT(*) FROM Notificaciones WHERE IdUsuario = @idUsuario AND Leida = 0
END
GO
/****** Object:  StoredProcedure [dbo].[GetCategoriaById]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCategoriaById]
	@id int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT IdCategorias, Nombre FROM Categorias WHERE IdCategorias = @id
END
GO
/****** Object:  StoredProcedure [dbo].[GetCategorias]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCategorias]
	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT IdCategorias, Nombre FROM Categorias ORDER BY Nombre
END
GO
/****** Object:  StoredProcedure [dbo].[GetEstadoArticuloById]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEstadoArticuloById]
	@id int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT IdEstadosArticulos, Nombre FROM EstadosArticulos WHERE IdEstadosArticulos = @id
END
GO
/****** Object:  StoredProcedure [dbo].[GetEstadosArticulos]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEstadosArticulos]
	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT IdEstadosArticulos, Nombre FROM EstadosArticulos ORDER BY IdEstadosArticulos
END
GO
/****** Object:  StoredProcedure [dbo].[GetEstadosIntercambios]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEstadosIntercambios]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT IdEstadosIntercambios, Nombre FROM EstadosIntercambios ORDER BY IdEstadosIntercambios
END
GO
/****** Object:  StoredProcedure [dbo].[GetFiltroCategorias]    Script Date: 29/10/2026 13:39:32 ******/
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
/****** Object:  StoredProcedure [dbo].[GetFiltroEstados]    Script Date: 29/10/2026 13:39:32 ******/
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
/****** Object:  StoredProcedure [dbo].[GetFotoUsuario]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFotoUsuario]
	@idUsuario int
	AS
BEGIN
	SELECT TOP 1 Ruta FROM Imagenes WHERE IdUsuarios = @idUsuario AND IdArticulos IS NULL ORDER BY IdImagenes DESC
END
GO
/****** Object:  StoredProcedure [dbo].[GetImagenesArticulo]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetImagenesArticulo]
	@idArticulo int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT Ruta FROM Imagenes WHERE IdArticulos = @idArticulo ORDER BY IdImagenes
END
GO
/****** Object:  StoredProcedure [dbo].[GetProvinciaById]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetProvinciaById]
	@id int
AS
BEGIN
	SELECT IdProvincia, Nombre 
	FROM Provincias 
	WHERE IdProvincia = @id
END
GO
/****** Object:  StoredProcedure [dbo].[GetProvincias]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetProvincias] 

AS
BEGIN
	SELECT IdProvincia, Nombre FROM Provincias ORDER BY Nombre
END
GO
/****** Object:  StoredProcedure [dbo].[GetUsuarioById]    Script Date: 29/10/2026 13:39:32 ******/
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
/****** Object:  StoredProcedure [dbo].[GetUsuarioByMail]    Script Date: 29/10/2026 13:39:32 ******/
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
/****** Object:  StoredProcedure [dbo].[GuardarFotoUsuario]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  StoredProcedure [dbo].[MarcarNotificacionesLeidas]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MarcarNotificacionesLeidas]
	@idUsuario int
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE Notificaciones SET Leida = 1 WHERE IdUsuario = @idUsuario AND Leida = 0
END
GO
/****** Object:  StoredProcedure [dbo].[PublicarArticulo]    Script Date: 29/10/2026 13:39:32 ******/
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
	@idCategoriaACambio int = NULL,
	@rutasFotos varchar(max) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;
	DECLARE @idArticulo int, @ruta varchar(max), @pos int

	BEGIN TRANSACTION
	INSERT INTO Articulos (Nombre, Descripcion, IdEstado, IdUsuarios, IdCategorias, Ubicacion, FechaPublicacion, IdCategoriaACambio)
	VALUES (@nombre, @descripcion, @idEstado, @idUsuario, @idCategoria, @ubicacion, CAST(GETDATE() AS date), @idCategoriaACambio)
	SET @idArticulo = SCOPE_IDENTITY()

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
/****** Object:  StoredProcedure [dbo].[RegistrarArticulo]    Script Date: 29/10/2026 13:39:32 ******/
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
                INSERT INTO Articulos (Nombre, Descripcion, IdEstado, IdUsuarios, IdCategorias, FechaPublicacion)
                VALUES(@nombre, @descripcion, (SELECT IdEstadosArticulos FROM EstadosArticulos WHERE Nombre = @estado), (SELECT IdUsuarios FROM Usuarios WHERE Usuario = @usuario), (SELECT IdCategorias
                FROM Categorias WHERE Nombre = @categoria), CAST(GETDATE() AS date))
            END
        END
END

GO
/****** Object:  StoredProcedure [dbo].[RegistrarIntercambio]    Script Date: 29/10/2026 13:39:32 ******/
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
/****** Object:  StoredProcedure [dbo].[RegistrarMensaje]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RegistrarMensaje]
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
/****** Object:  StoredProcedure [dbo].[RegistrarUsuario]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RegistrarUsuario]
	@nombre varchar(50),
	@apellido varchar(50),
	@usuario varchar(50),
	@mail varchar(50),
	@telefono varchar(20),
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
/****** Object:  StoredProcedure [dbo].[UpdateUsuario]    Script Date: 29/10/2026 13:39:32 ******/
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
	@telefono varchar(20),
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
/****** Object:  StoredProcedure [dbo].[UsuarioExiste]    Script Date: 29/10/2026 13:39:32 ******/
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
