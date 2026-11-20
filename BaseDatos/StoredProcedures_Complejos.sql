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
        a2.Cantidad AS CantidadPedidos,
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
    CROSS APPLY (SELECT TOP 1 a.Nombre, COUNT(*) OVER () AS Cantidad
        FROM ArticulosIntercambios ai
        INNER JOIN Articulos a ON a.IdArticulos = ai.IdArticulo
        WHERE ai.IdIntercambio = Intercambios.IdIntercambios AND a.IdUsuarios = Intercambios.IdUsuarios2
        ORDER BY ai.Id) a2
    LEFT JOIN Mensajes m ON Intercambios.IdIntercambios = m.IdIntercambio
    WHERE Intercambios.IdEstado = 1 -- Estado 1 = Pendiente
      AND DATEDIFF(DAY, Intercambios.Fecha, GETDATE()) >= @AntiguedadMinimaDias
    GROUP BY Intercambios.IdIntercambios, Intercambios.Fecha, u1.Usuario, u2.Usuario, a1.Nombre, a1.Cantidad, a2.Nombre, a2.Cantidad
    ORDER BY DiasTranscurridos DESC;

    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'No hay intercambios pendientes que superen el límite de días ingresado.';
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[ContarArticulosActivos]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
