/****** 3 de 3: Stored procedures. Ejecutar después de Estructura.sql. ******/
USE [Base_De_Datos_Swappit]
GO
/****** Object:  StoredProcedure [dbo].[ActualizarArticulo]    Script Date: 18/11/2026 12:00:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ActualizarArticulo]
	@idArticulo int,
	@idUsuario int,
	@nombre varchar(50),
	@descripcion varchar(500),
	@idEstado int,
	@idCategoria int,
	@ubicacion varchar(100),
	@idCategoriaACambio int = NULL,
	@rutasEliminar varchar(max) = NULL,
	@rutasNuevas varchar(max) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;
	DECLARE @borradas TABLE (Ruta varchar(100))
	DECLARE @ruta varchar(max), @pos int

	BEGIN TRANSACTION
	UPDATE Articulos
	SET Nombre = @nombre, Descripcion = @descripcion, IdEstado = @idEstado, IdCategorias = @idCategoria,
		Ubicacion = @ubicacion, IdCategoriaACambio = @idCategoriaACambio
	WHERE IdArticulos = @idArticulo AND IdUsuarios = @idUsuario

	IF @@ROWCOUNT = 0
	BEGIN
		ROLLBACK TRANSACTION
		SELECT CAST(0 AS bit) AS Actualizado
		SELECT Ruta FROM @borradas
		RETURN
	END

	DELETE FROM Imagenes
	OUTPUT deleted.Ruta INTO @borradas
	WHERE IdArticulos = @idArticulo AND Ruta IN (SELECT value FROM STRING_SPLIT(@rutasEliminar, '|'))

	WHILE LEN(@rutasNuevas) > 0
	BEGIN
		SET @pos = CHARINDEX('|', @rutasNuevas)
		IF @pos = 0 SET @pos = LEN(@rutasNuevas) + 1
		SET @ruta = LEFT(@rutasNuevas, @pos - 1)
		SET @rutasNuevas = SUBSTRING(@rutasNuevas, @pos + 1, LEN(@rutasNuevas))
		IF @ruta <> '' INSERT INTO Imagenes (Ruta, IdArticulos) VALUES (@ruta, @idArticulo)
	END
	COMMIT TRANSACTION

	SELECT CAST(1 AS bit) AS Actualizado
	SELECT Ruta FROM @borradas
END
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
/****** Object:  StoredProcedure [dbo].[CrearNotificacion]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CrearNotificacion]
	@idUsuario int,
	@idIntercambio int,
	@tipo varchar(50),
	@siNoHayOtraSinLeer bit = 0,
	@idCambio int = NULL
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO Notificaciones (IdUsuario, IdIntercambio, IdTipoNotificacion, Leida, Fecha, IdCambio)
	SELECT @idUsuario, @idIntercambio, t.Id, 0, GETDATE(), @idCambio
	FROM TipoNotificaciones t
	WHERE t.Nombre = @tipo
		AND (@siNoHayOtraSinLeer = 0 OR NOT EXISTS (SELECT 1 FROM Notificaciones n
			WHERE n.IdUsuario = @idUsuario AND n.IdIntercambio = @idIntercambio AND n.IdTipoNotificacion = t.Id AND n.Leida = 0));

	IF @@ROWCOUNT > 0 AND OBJECT_ID('tempdb..#Creadas') IS NOT NULL
		INSERT INTO #Creadas (IdUsuario, IdIntercambio, Tipo, IdCambio) VALUES (@idUsuario, @idIntercambio, @tipo, @idCambio);
END
GO
/****** Object:  StoredProcedure [dbo].[RechazarPendientesDeArticulos]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RechazarPendientesDeArticulos]
	@idIntercambio int,
	@idUsuario int
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @rechazadas TABLE (IdIntercambio int PRIMARY KEY, IdAutor int);
	DECLARE @idRechazada int, @idAutor int;

	UPDATE o SET o.IdEstado = rechazado.IdEstadosIntercambios
	OUTPUT INSERTED.IdIntercambios, INSERTED.IdUsuarios1 INTO @rechazadas (IdIntercambio, IdAutor)
	FROM Intercambios o
	INNER JOIN EstadosIntercambios e ON e.IdEstadosIntercambios = o.IdEstado
	INNER JOIN EstadosIntercambios rechazado ON rechazado.Nombre = 'Rechazado'
	WHERE e.Nombre = 'Pendiente' AND o.IdIntercambios <> @idIntercambio
		AND EXISTS (SELECT 1 FROM ArticulosIntercambios acep
			INNER JOIN ArticulosIntercambios otro ON otro.IdArticulo = acep.IdArticulo
			WHERE acep.IdIntercambio = @idIntercambio AND otro.IdIntercambio = o.IdIntercambios);

	SELECT @idRechazada = MIN(IdIntercambio) FROM @rechazadas WHERE IdAutor <> @idUsuario;
	WHILE @idRechazada IS NOT NULL
	BEGIN
		SELECT @idAutor = IdAutor FROM @rechazadas WHERE IdIntercambio = @idRechazada;
		EXEC CrearNotificacion @idAutor, @idRechazada, 'Propuesta rechazada';
		SELECT @idRechazada = MIN(IdIntercambio) FROM @rechazadas WHERE IdAutor <> @idUsuario AND IdIntercambio > @idRechazada;
	END
END
GO
/****** Object:  StoredProcedure [dbo].[AgregarArticulos]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AgregarArticulos]
	@idIntercambio int,
	@idUsuario int,
	@idsArticulos varchar(max)
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;
	CREATE TABLE #Creadas (IdUsuario int, IdIntercambio int, Tipo varchar(50), IdCambio int NULL);
	DECLARE @pedidos TABLE (IdArticulo int PRIMARY KEY);
	DECLARE @agregados TABLE (IdArticulo int PRIMARY KEY);
	DECLARE @cambios TABLE (Id int PRIMARY KEY);
	DECLARE @idOtro int, @estado varchar(50), @cantidad int, @agregadosOk int = 0, @idCambio int, @ahora datetime = GETDATE();

	INSERT INTO @pedidos (IdArticulo)
	SELECT DISTINCT CAST(value AS int) FROM STRING_SPLIT(@idsArticulos, ',') WHERE value <> '';
	SELECT @cantidad = COUNT(*) FROM @pedidos;

	BEGIN TRANSACTION;
	SELECT @idOtro = CASE WHEN i.IdUsuarios1 = @idUsuario THEN i.IdUsuarios2 ELSE i.IdUsuarios1 END, @estado = e.Nombre
	FROM Intercambios i WITH (UPDLOCK, HOLDLOCK)
	INNER JOIN EstadosIntercambios e ON e.IdEstadosIntercambios = i.IdEstado
	WHERE i.IdIntercambios = @idIntercambio AND e.Nombre IN ('Pendiente', 'Aceptado')
		AND (i.IdUsuarios1 = @idUsuario OR i.IdUsuarios2 = @idUsuario);

	IF @idOtro IS NOT NULL AND @cantidad > 0
	BEGIN
		INSERT INTO ArticulosIntercambios (IdArticulo, IdIntercambio)
		OUTPUT INSERTED.IdArticulo INTO @agregados (IdArticulo)
		SELECT a.IdArticulos, @idIntercambio
		FROM Articulos a
		WHERE a.IdArticulos IN (SELECT IdArticulo FROM @pedidos) AND a.IdUsuarios = @idUsuario
			AND NOT EXISTS (SELECT 1 FROM ArticulosIntercambios ae WHERE ae.IdIntercambio = @idIntercambio AND ae.IdArticulo = a.IdArticulos)
			AND NOT EXISTS (SELECT 1 FROM CambiosIntercambios cx
				INNER JOIN EstadosIntercambios ex ON ex.IdEstadosIntercambios = cx.IdEstado
				WHERE cx.IdIntercambio = @idIntercambio AND cx.IdArticulo = a.IdArticulos AND ex.Nombre = 'Pendiente')
			AND NOT EXISTS (SELECT 1 FROM ArticulosIntercambios aic
				INNER JOIN Intercambios ic ON ic.IdIntercambios = aic.IdIntercambio
				INNER JOIN EstadosIntercambios eic ON eic.IdEstadosIntercambios = ic.IdEstado
				WHERE eic.Nombre IN ('Aceptado', 'Realizado') AND aic.IdArticulo = a.IdArticulos)
			AND (SELECT COUNT(*) FROM ArticulosIntercambios ac
					INNER JOIN Articulos xa ON xa.IdArticulos = ac.IdArticulo
					WHERE ac.IdIntercambio = @idIntercambio AND xa.IdUsuarios = @idUsuario)
				+ (SELECT COUNT(*) FROM CambiosIntercambios cp
					INNER JOIN Articulos xp ON xp.IdArticulos = cp.IdArticulo
					INNER JOIN TipoCambios tp ON tp.Id = cp.IdTipoCambio
					INNER JOIN EstadosIntercambios ep ON ep.IdEstadosIntercambios = cp.IdEstado
					WHERE cp.IdIntercambio = @idIntercambio AND xp.IdUsuarios = @idUsuario AND tp.Nombre = 'Pedir' AND ep.Nombre = 'Pendiente')
				+ @cantidad <= 3;
		SELECT @agregadosOk = COUNT(*) FROM @agregados;
	END

	IF @agregadosOk = 0 OR @agregadosOk <> @cantidad
	BEGIN
		ROLLBACK TRANSACTION;
		SET @agregadosOk = 0;
	END
	ELSE
	BEGIN
		INSERT INTO CambiosIntercambios (IdIntercambio, IdArticulo, IdUsuario, IdTipoCambio, IdEstado, Fecha)
		OUTPUT INSERTED.Id INTO @cambios (Id)
		SELECT @idIntercambio, a.IdArticulos, @idUsuario,
			(SELECT t.Id FROM TipoCambios t WHERE t.Nombre = 'Agregar'),
			(SELECT e.IdEstadosIntercambios FROM EstadosIntercambios e WHERE e.Nombre = 'Aceptado'),
			@ahora
		FROM Articulos a
		WHERE a.IdArticulos IN (SELECT IdArticulo FROM @agregados)
		ORDER BY a.IdArticulos;

		SELECT @idCambio = MIN(Id) FROM @cambios;
		EXEC CrearNotificacion @idOtro, @idIntercambio, 'Artículo agregado', @idCambio = @idCambio;
		IF @estado = 'Aceptado'
			EXEC RechazarPendientesDeArticulos @idIntercambio, @idUsuario;
		COMMIT TRANSACTION;
	END

	SELECT @agregadosOk AS Agregados;
	SELECT IdUsuario, IdIntercambio, Tipo, IdCambio FROM #Creadas;
END
GO
/****** Object:  StoredProcedure [dbo].[AlternarFavorito]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AlternarFavorito]
	@idUsuario int,
	@idArticulo int
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @idFavorito int = (SELECT Id FROM TipoInteracciones WHERE Nombre = 'Favorito');

	IF EXISTS (SELECT 1 FROM Interacciones WHERE IdUsuario = @idUsuario AND IdArticulo = @idArticulo AND IdTipoInteraccion = @idFavorito)
	BEGIN
		DELETE FROM Interacciones WHERE IdUsuario = @idUsuario AND IdArticulo = @idArticulo AND IdTipoInteraccion = @idFavorito;
		SELECT CAST(0 AS bit) AS EsFavorito;
	END
	ELSE IF EXISTS (SELECT 1 FROM Articulos WHERE IdArticulos = @idArticulo AND IdUsuarios <> @idUsuario)
	BEGIN
		INSERT INTO Interacciones (IdUsuario, IdTipoInteraccion, IdArticulo, Fecha) VALUES (@idUsuario, @idFavorito, @idArticulo, GETDATE());
		SELECT CAST(1 AS bit) AS EsFavorito;
	END
	ELSE
		SELECT CAST(NULL AS bit) AS EsFavorito;
END
GO
/****** Object:  StoredProcedure [dbo].[ArticuloComprometido]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ArticuloComprometido]
	@idArticulo int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT CAST(CASE WHEN EXISTS (SELECT 1 FROM ArticulosIntercambios aic
			INNER JOIN Intercambios ic ON ic.IdIntercambios = aic.IdIntercambio
			INNER JOIN EstadosIntercambios eic ON eic.IdEstadosIntercambios = ic.IdEstado
			WHERE eic.Nombre IN ('Aceptado', 'Realizado') AND aic.IdArticulo = a.IdArticulos) THEN 1 ELSE 0 END AS bit)
	FROM Articulos a
	WHERE a.IdArticulos = @idArticulo
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
/****** Object:  StoredProcedure [dbo].[CambiarEstadoIntercambio]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CambiarEstadoIntercambio]
	@idIntercambio int,
	@idUsuario int,
	@estadoActual varchar(50),
	@estadoNuevo varchar(50),
	@soloQuienRecibe bit,
	@tipoNotificacion varchar(50) = NULL,
	@ultimoCambioVisto int = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;
	CREATE TABLE #Creadas (IdUsuario int, IdIntercambio int, Tipo varchar(50), IdCambio int NULL);
	DECLARE @idOtro int, @idEstadoNuevo int;

	BEGIN TRANSACTION;
	SELECT @idOtro = CASE WHEN i.IdUsuarios1 = @idUsuario THEN i.IdUsuarios2 ELSE i.IdUsuarios1 END,
		@idEstadoNuevo = nuevo.IdEstadosIntercambios
	FROM Intercambios i WITH (UPDLOCK, HOLDLOCK)
	INNER JOIN EstadosIntercambios actual ON actual.IdEstadosIntercambios = i.IdEstado
	INNER JOIN EstadosIntercambios nuevo ON nuevo.Nombre = @estadoNuevo
	WHERE i.IdIntercambios = @idIntercambio AND actual.Nombre = @estadoActual
		AND (i.IdUsuarios2 = @idUsuario OR (@soloQuienRecibe = 0 AND i.IdUsuarios1 = @idUsuario))
		AND (@estadoNuevo <> 'Aceptado' OR NOT EXISTS (SELECT 1 FROM ArticulosIntercambios mio
			INNER JOIN ArticulosIntercambios otro ON otro.IdArticulo = mio.IdArticulo AND otro.IdIntercambio <> mio.IdIntercambio
			INNER JOIN Intercambios io ON io.IdIntercambios = otro.IdIntercambio
			INNER JOIN EstadosIntercambios eio ON eio.IdEstadosIntercambios = io.IdEstado
			WHERE mio.IdIntercambio = @idIntercambio AND eio.Nombre IN ('Aceptado', 'Realizado')))
		AND (@estadoNuevo <> 'Realizado' OR NOT EXISTS (SELECT 1 FROM CambiosIntercambios cr
			INNER JOIN EstadosIntercambios er ON er.IdEstadosIntercambios = cr.IdEstado
			WHERE cr.IdIntercambio = i.IdIntercambios AND er.Nombre = 'Pendiente'))
		AND (@estadoNuevo <> 'Aceptado' OR (NOT EXISTS (SELECT 1 FROM CambiosIntercambios cr
				INNER JOIN EstadosIntercambios er ON er.IdEstadosIntercambios = cr.IdEstado
				WHERE cr.IdIntercambio = i.IdIntercambios AND er.Nombre = 'Pendiente' AND cr.IdUsuario <> @idUsuario)
			AND NOT EXISTS (SELECT 1 FROM CambiosIntercambios cu
				WHERE cu.IdIntercambio = i.IdIntercambios AND cu.Id > ISNULL(@ultimoCambioVisto, 0))));

	IF @idOtro IS NOT NULL
	BEGIN
		UPDATE Intercambios SET IdEstado = @idEstadoNuevo WHERE IdIntercambios = @idIntercambio;
		IF @tipoNotificacion IS NOT NULL
			EXEC CrearNotificacion @idOtro, @idIntercambio, @tipoNotificacion;
		IF @estadoNuevo = 'Aceptado'
			EXEC RechazarPendientesDeArticulos @idIntercambio, @idUsuario;
	END
	COMMIT TRANSACTION;

	SELECT CAST(CASE WHEN @idOtro IS NULL THEN 0 ELSE 1 END AS bit) AS Cambiado;
	SELECT IdUsuario, IdIntercambio, Tipo, IdCambio FROM #Creadas;
END
GO
/****** Object:  StoredProcedure [dbo].[CambiarPlanUsuario]    Script Date: 18/11/2026 12:00:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CambiarPlanUsuario]
	@idUsuario int,
	@idPlan int
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE Usuarios SET IdPlan = @idPlan
	WHERE IdUsuarios = @idUsuario AND EXISTS (SELECT 1 FROM Planes WHERE Id = @idPlan)
	SELECT @@ROWCOUNT
END
GO
/****** Object:  StoredProcedure [dbo].[CancelarCambio]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CancelarCambio]
	@idCambio int,
	@idUsuario int
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE c SET c.IdEstado = (SELECT e.IdEstadosIntercambios FROM EstadosIntercambios e WHERE e.Nombre = 'Cancelado'),
		c.FechaRespuesta = GETDATE()
	FROM CambiosIntercambios c
	INNER JOIN EstadosIntercambios ec ON ec.IdEstadosIntercambios = c.IdEstado
	INNER JOIN Intercambios i ON i.IdIntercambios = c.IdIntercambio
	INNER JOIN EstadosIntercambios ei ON ei.IdEstadosIntercambios = i.IdEstado
	WHERE c.Id = @idCambio AND c.IdUsuario = @idUsuario AND ec.Nombre = 'Pendiente' AND ei.Nombre IN ('Pendiente', 'Aceptado');

	SELECT CAST(CASE WHEN @@ROWCOUNT > 0 THEN 1 ELSE 0 END AS bit) AS Cancelado;
END
GO
/****** Object:  StoredProcedure [dbo].[CancelarIntercambio]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CancelarIntercambio]
	@idIntercambio int,
	@idUsuario int
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;
	CREATE TABLE #Creadas (IdUsuario int, IdIntercambio int, Tipo varchar(50), IdCambio int NULL);
	DECLARE @idOtro int;

	BEGIN TRANSACTION;
	SELECT @idOtro = CASE WHEN i.IdUsuarios1 = @idUsuario THEN i.IdUsuarios2 ELSE i.IdUsuarios1 END
	FROM Intercambios i WITH (UPDLOCK, HOLDLOCK)
	INNER JOIN EstadosIntercambios actual ON actual.IdEstadosIntercambios = i.IdEstado
	WHERE i.IdIntercambios = @idIntercambio
		AND ((actual.Nombre = 'Pendiente' AND i.IdUsuarios1 = @idUsuario)
			OR (actual.Nombre = 'Aceptado' AND (i.IdUsuarios1 = @idUsuario OR i.IdUsuarios2 = @idUsuario)))
		AND EXISTS (SELECT 1 FROM EstadosIntercambios WHERE Nombre = 'Cancelado');

	IF @idOtro IS NOT NULL
	BEGIN
		UPDATE Intercambios SET IdEstado = (SELECT IdEstadosIntercambios FROM EstadosIntercambios WHERE Nombre = 'Cancelado')
		WHERE IdIntercambios = @idIntercambio;
		EXEC CrearNotificacion @idOtro, @idIntercambio, 'Intercambio cancelado';
	END
	COMMIT TRANSACTION;

	SELECT CAST(CASE WHEN @idOtro IS NULL THEN 0 ELSE 1 END AS bit) AS Cancelado;
	SELECT IdUsuario, IdIntercambio, Tipo, IdCambio FROM #Creadas;
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
CREATE PROCEDURE [dbo].[ContarArticulosActivos]
	@idUsuario int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT COUNT(*)
	FROM Articulos a
	WHERE a.IdUsuarios = @idUsuario
		AND NOT EXISTS (SELECT 1 FROM ArticulosIntercambios air
			INNER JOIN Intercambios ir ON ir.IdIntercambios = air.IdIntercambio
			INNER JOIN EstadosIntercambios eir ON eir.IdEstadosIntercambios = ir.IdEstado
			WHERE eir.Nombre = 'Realizado' AND air.IdArticulo = a.IdArticulos)
END
GO
/****** Object:  StoredProcedure [dbo].[ContarCambiosPendientes]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ContarCambiosPendientes]
	@idIntercambio int,
	@idUsuario int,
	@soloDelOtro bit = 0
AS
BEGIN
	SET NOCOUNT ON;
	SELECT COUNT(*)
	FROM CambiosIntercambios c
	INNER JOIN Intercambios i ON i.IdIntercambios = c.IdIntercambio
	INNER JOIN EstadosIntercambios ei ON ei.IdEstadosIntercambios = i.IdEstado
	INNER JOIN EstadosIntercambios ec ON ec.IdEstadosIntercambios = c.IdEstado
	WHERE c.IdIntercambio = @idIntercambio AND (i.IdUsuarios1 = @idUsuario OR i.IdUsuarios2 = @idUsuario)
		AND ec.Nombre = 'Pendiente' AND ei.Nombre IN ('Pendiente', 'Aceptado')
		AND (@soloDelOtro = 0 OR c.IdUsuario <> @idUsuario)
END
GO
/****** Object:  StoredProcedure [dbo].[ContarIntercambiosActivos]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ContarIntercambiosActivos]
	@idUsuario int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT COUNT(*)
	FROM Intercambios i
	INNER JOIN EstadosIntercambios e ON e.IdEstadosIntercambios = i.IdEstado
	WHERE i.IdUsuarios1 = @idUsuario AND e.Nombre IN ('Pendiente', 'Aceptado')
END
GO
/****** Object:  StoredProcedure [dbo].[ContarIntercambiosPorEstado]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ContarIntercambiosPorEstado]
	@idUsuario int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT e.Nombre AS Estado, COUNT(*) AS Cantidad,
		SUM(CASE WHEN i.IdUsuarios2 = @idUsuario AND e.Nombre = 'Pendiente' THEN 1 ELSE 0 END) AS PorResponder
	FROM Intercambios i
	INNER JOIN EstadosIntercambios e ON e.IdEstadosIntercambios = i.IdEstado
	WHERE (i.IdUsuarios1 = @idUsuario OR i.IdUsuarios2 = @idUsuario)
		AND EXISTS (SELECT 1 FROM ArticulosIntercambios aim
			INNER JOIN Articulos xm ON xm.IdArticulos = aim.IdArticulo
			WHERE aim.IdIntercambio = i.IdIntercambios AND xm.IdUsuarios = @idUsuario)
		AND EXISTS (SELECT 1 FROM ArticulosIntercambios ais
			INNER JOIN Articulos xs ON xs.IdArticulos = ais.IdArticulo
			WHERE ais.IdIntercambio = i.IdIntercambios
				AND xs.IdUsuarios = CASE WHEN i.IdUsuarios1 = @idUsuario THEN i.IdUsuarios2 ELSE i.IdUsuarios1 END)
	GROUP BY e.Nombre
END
GO
/****** Object:  StoredProcedure [dbo].[ContarMensajesNoLeidos]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ContarMensajesNoLeidos]
	@idUsuario int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT COUNT(*)
	FROM Mensajes m
	INNER JOIN Intercambios i ON i.IdIntercambios = m.IdIntercambio
	WHERE (i.IdUsuarios1 = @idUsuario OR i.IdUsuarios2 = @idUsuario)
		AND m.IdUsuariosManda <> @idUsuario AND m.fueVisto = 0
END
GO
/****** Object:  StoredProcedure [dbo].[ContarPendientesDeArticulos]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ContarPendientesDeArticulos]
	@idIntercambio int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT COUNT(*)
	FROM Intercambios o
	INNER JOIN EstadosIntercambios e ON e.IdEstadosIntercambios = o.IdEstado
	WHERE e.Nombre = 'Pendiente' AND o.IdIntercambios <> @idIntercambio
		AND EXISTS (SELECT 1 FROM ArticulosIntercambios acep
			INNER JOIN ArticulosIntercambios otro ON otro.IdArticulo = acep.IdArticulo
			WHERE acep.IdIntercambio = @idIntercambio AND otro.IdIntercambio = o.IdIntercambios)
END
GO
/****** Object:  StoredProcedure [dbo].[CrearPedido]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CrearPedido]
	@idIntercambio int,
	@idUsuario int,
	@idArticulo int,
	@tipo varchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;
	CREATE TABLE #Creadas (IdUsuario int, IdIntercambio int, Tipo varchar(50), IdCambio int NULL);
	DECLARE @idOtro int, @idCambio int, @tipoNotificacion varchar(50);

	BEGIN TRANSACTION;
	SELECT @idOtro = CASE WHEN i.IdUsuarios1 = @idUsuario THEN i.IdUsuarios2 ELSE i.IdUsuarios1 END
	FROM Intercambios i WITH (UPDLOCK, HOLDLOCK)
	INNER JOIN EstadosIntercambios e ON e.IdEstadosIntercambios = i.IdEstado
	WHERE i.IdIntercambios = @idIntercambio AND e.Nombre IN ('Pendiente', 'Aceptado')
		AND (i.IdUsuarios1 = @idUsuario OR i.IdUsuarios2 = @idUsuario);

	IF @idOtro IS NOT NULL
	BEGIN
		INSERT INTO CambiosIntercambios (IdIntercambio, IdArticulo, IdUsuario, IdTipoCambio, IdEstado, Fecha)
		SELECT @idIntercambio, a.IdArticulos, @idUsuario,
			(SELECT t.Id FROM TipoCambios t WHERE t.Nombre = @tipo),
			(SELECT e.IdEstadosIntercambios FROM EstadosIntercambios e WHERE e.Nombre = 'Pendiente'),
			GETDATE()
		FROM Articulos a
		WHERE a.IdArticulos = @idArticulo
			AND NOT EXISTS (SELECT 1 FROM CambiosIntercambios cx
				INNER JOIN EstadosIntercambios ex ON ex.IdEstadosIntercambios = cx.IdEstado
				WHERE cx.IdIntercambio = @idIntercambio AND cx.IdArticulo = a.IdArticulos AND ex.Nombre = 'Pendiente')
			AND ((@tipo = 'Pedir' AND a.IdUsuarios = @idOtro
					AND NOT EXISTS (SELECT 1 FROM ArticulosIntercambios ae WHERE ae.IdIntercambio = @idIntercambio AND ae.IdArticulo = a.IdArticulos)
					AND NOT EXISTS (SELECT 1 FROM ArticulosIntercambios aic
						INNER JOIN Intercambios ic ON ic.IdIntercambios = aic.IdIntercambio
						INNER JOIN EstadosIntercambios eic ON eic.IdEstadosIntercambios = ic.IdEstado
						WHERE eic.Nombre IN ('Aceptado', 'Realizado') AND aic.IdArticulo = a.IdArticulos)
					AND (SELECT COUNT(*) FROM ArticulosIntercambios ac
							INNER JOIN Articulos xa ON xa.IdArticulos = ac.IdArticulo
							WHERE ac.IdIntercambio = @idIntercambio AND xa.IdUsuarios = @idOtro)
						+ (SELECT COUNT(*) FROM CambiosIntercambios cp
							INNER JOIN Articulos xp ON xp.IdArticulos = cp.IdArticulo
							INNER JOIN TipoCambios tp ON tp.Id = cp.IdTipoCambio
							INNER JOIN EstadosIntercambios ep ON ep.IdEstadosIntercambios = cp.IdEstado
							WHERE cp.IdIntercambio = @idIntercambio AND xp.IdUsuarios = @idOtro AND tp.Nombre = 'Pedir' AND ep.Nombre = 'Pendiente') < 3)
				OR (@tipo = 'Sacar' AND a.IdUsuarios = @idUsuario
					AND EXISTS (SELECT 1 FROM ArticulosIntercambios ae WHERE ae.IdIntercambio = @idIntercambio AND ae.IdArticulo = a.IdArticulos)
					AND (SELECT COUNT(*) FROM ArticulosIntercambios ac
							INNER JOIN Articulos xa ON xa.IdArticulos = ac.IdArticulo
							WHERE ac.IdIntercambio = @idIntercambio AND xa.IdUsuarios = @idUsuario)
						- (SELECT COUNT(*) FROM CambiosIntercambios cp
							INNER JOIN Articulos xp ON xp.IdArticulos = cp.IdArticulo
							INNER JOIN TipoCambios tp ON tp.Id = cp.IdTipoCambio
							INNER JOIN EstadosIntercambios ep ON ep.IdEstadosIntercambios = cp.IdEstado
							WHERE cp.IdIntercambio = @idIntercambio AND xp.IdUsuarios = @idUsuario AND tp.Nombre = 'Sacar' AND ep.Nombre = 'Pendiente') >= 2));

		IF @@ROWCOUNT > 0
		BEGIN
			SET @idCambio = SCOPE_IDENTITY();
			SET @tipoNotificacion = CASE WHEN @tipo = 'Pedir' THEN 'Pedido de artículo' ELSE 'Pedido para sacar' END;
			EXEC CrearNotificacion @idOtro, @idIntercambio, @tipoNotificacion, @idCambio = @idCambio;
		END
	END
	COMMIT TRANSACTION;

	SELECT CAST(CASE WHEN @idCambio IS NULL THEN 0 ELSE 1 END AS bit) AS Creado;
	SELECT IdUsuario, IdIntercambio, Tipo, IdCambio FROM #Creadas;
END
GO
/****** Object:  StoredProcedure [dbo].[EliminarArticulo]    Script Date: 18/11/2026 12:00:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[EliminarArticulo]
	@idArticulo int,
	@idUsuario int
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	BEGIN TRANSACTION
	IF NOT EXISTS (SELECT 1 FROM Articulos WHERE IdArticulos = @idArticulo AND IdUsuarios = @idUsuario)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 0 AS Resultado
		RETURN
	END

	IF EXISTS (SELECT 1 FROM ArticulosIntercambios WHERE IdArticulo = @idArticulo)
		OR EXISTS (SELECT 1 FROM CambiosIntercambios WHERE IdArticulo = @idArticulo)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 2 AS Resultado
		RETURN
	END

	DELETE FROM Interacciones WHERE IdArticulo = @idArticulo
	DELETE FROM Imagenes WHERE IdArticulos = @idArticulo
	DELETE FROM Articulos WHERE IdArticulos = @idArticulo AND IdUsuarios = @idUsuario
	COMMIT TRANSACTION

	SELECT 1 AS Resultado
END
GO
/****** Object:  StoredProcedure [dbo].[EnviarMensaje]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[EnviarMensaje]
	@idIntercambio int,
	@idUsuario int,
	@texto varchar(500)
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;
	CREATE TABLE #Creadas (IdUsuario int, IdIntercambio int, Tipo varchar(50), IdCambio int NULL);
	DECLARE @idOtro int;

	BEGIN TRANSACTION;
	SELECT @idOtro = CASE WHEN i.IdUsuarios1 = @idUsuario THEN i.IdUsuarios2 ELSE i.IdUsuarios1 END
	FROM Intercambios i
	INNER JOIN EstadosIntercambios e ON e.IdEstadosIntercambios = i.IdEstado
	WHERE i.IdIntercambios = @idIntercambio AND (i.IdUsuarios1 = @idUsuario OR i.IdUsuarios2 = @idUsuario)
		AND (e.Nombre = 'Aceptado'
			OR (e.Nombre = 'Pendiente' AND (i.IdUsuarios2 = @idUsuario
				OR EXISTS (SELECT 1 FROM Mensajes mr WHERE mr.IdIntercambio = i.IdIntercambios AND mr.IdUsuariosManda = i.IdUsuarios2))));

	IF @idOtro IS NOT NULL
	BEGIN
		INSERT INTO Mensajes (Texto, fueVisto, FechaEnviado, FechaRecibido, IdUsuariosManda, IdIntercambio)
		VALUES (@texto, 0, GETDATE(), NULL, @idUsuario, @idIntercambio);
		EXEC CrearNotificacion @idOtro, @idIntercambio, 'Mensaje nuevo', @siNoHayOtraSinLeer = 1;
	END
	COMMIT TRANSACTION;

	SELECT CAST(CASE WHEN @idOtro IS NULL THEN 0 ELSE 1 END AS bit) AS Enviado;
	SELECT IdUsuario, IdIntercambio, Tipo, IdCambio FROM #Creadas;
END
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
/****** Object:  StoredProcedure [dbo].[GetArticulosCatalogo]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetArticulosCatalogo]
	@busqueda varchar(150) = NULL,
	@cantidad int = NULL,
	@categorias varchar(max) = NULL,
	@estados varchar(max) = NULL,
	@idUsuario int = NULL,
	@excluirUsuario int = NULL,
	@excluirArticulo int = NULL,
	@fueraDeIntercambio int = NULL,
	@incluirEnIntercambio bit = 0,
	@orden varchar(20) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SET @busqueda = REPLACE(REPLACE(REPLACE(NULLIF(LTRIM(RTRIM(@busqueda)), ''), '[', '[[]'), '%', '[%]'), '_', '[_]');
	SELECT TOP (ISNULL(@cantidad, 2147483647)) a.IdArticulos, a.Nombre, e.Nombre AS Estado, COALESCE(NULLIF(a.Ubicacion, ''), u.Barrio) AS Barrio,
		(SELECT TOP 1 i.Ruta FROM Imagenes i WHERE i.IdArticulos = a.IdArticulos ORDER BY i.IdImagenes) AS Imagen,
		a.IdUsuarios, a.IdCategorias, a.IdCategoriaACambio, pl.Prioridad AS PrioridadPlan,
		CAST(CASE WHEN EXISTS (SELECT 1 FROM ArticulosIntercambios aic
			INNER JOIN Intercambios ic ON ic.IdIntercambios = aic.IdIntercambio
			INNER JOIN EstadosIntercambios eic ON eic.IdEstadosIntercambios = ic.IdEstado
			WHERE eic.Nombre IN ('Aceptado', 'Realizado') AND aic.IdArticulo = a.IdArticulos) THEN 1 ELSE 0 END AS bit) AS EnIntercambio
	FROM Articulos a
	INNER JOIN Usuarios u ON u.IdUsuarios = a.IdUsuarios
	INNER JOIN Planes pl ON pl.Id = u.IdPlan
	INNER JOIN EstadosArticulos e ON e.IdEstadosArticulos = a.IdEstado
	OUTER APPLY (SELECT SUM(CASE WHEN t.Nombre = 'Vista' THEN 1 WHEN t.Nombre = 'Favorito' THEN 3 ELSE 0 END) AS Puntos
		FROM Interacciones it
		INNER JOIN TipoInteracciones t ON t.Id = it.IdTipoInteraccion
		WHERE @orden = 'populares' AND it.IdArticulo = a.IdArticulos AND it.Fecha >= DATEADD(DAY, -30, GETDATE())) pop
	WHERE (@busqueda IS NULL OR a.Nombre LIKE '%' + @busqueda + '%')
		AND (NULLIF(@categorias, '') IS NULL OR a.IdCategorias IN (SELECT CAST(value AS int) FROM STRING_SPLIT(@categorias, ',')))
		AND (NULLIF(@estados, '') IS NULL OR a.IdEstado IN (SELECT CAST(value AS int) FROM STRING_SPLIT(@estados, ',')))
		AND (@idUsuario IS NULL OR a.IdUsuarios = @idUsuario)
		AND (@excluirUsuario IS NULL OR a.IdUsuarios <> @excluirUsuario)
		AND (@excluirArticulo IS NULL OR a.IdArticulos <> @excluirArticulo)
		AND NOT EXISTS (SELECT 1 FROM ArticulosIntercambios aic
			INNER JOIN Intercambios ic ON ic.IdIntercambios = aic.IdIntercambio
			INNER JOIN EstadosIntercambios eic ON eic.IdEstadosIntercambios = ic.IdEstado
			WHERE aic.IdArticulo = a.IdArticulos
				AND (eic.Nombre = 'Realizado' OR (@incluirEnIntercambio = 0 AND eic.Nombre = 'Aceptado')))
		AND (@fueraDeIntercambio IS NULL OR (NOT EXISTS (SELECT 1 FROM ArticulosIntercambios ae
				WHERE ae.IdIntercambio = @fueraDeIntercambio AND ae.IdArticulo = a.IdArticulos)
			AND NOT EXISTS (SELECT 1 FROM CambiosIntercambios cx
				INNER JOIN EstadosIntercambios ex ON ex.IdEstadosIntercambios = cx.IdEstado
				WHERE cx.IdIntercambio = @fueraDeIntercambio AND cx.IdArticulo = a.IdArticulos AND ex.Nombre = 'Pendiente')))
	ORDER BY CASE WHEN @orden = 'populares' THEN ISNULL(pop.Puntos, 0) END DESC,
		CASE WHEN @orden = 'az' THEN a.Nombre END COLLATE Modern_Spanish_CI_AS,
		a.IdArticulos DESC
END
GO
/****** Object:  StoredProcedure [dbo].[GetArticulosDeIntercambio]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetArticulosDeIntercambio]
	@idIntercambio int,
	@idUsuario int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT a.IdArticulos, a.Nombre, e.Nombre AS Estado,
		(SELECT TOP 1 im.Ruta FROM Imagenes im WHERE im.IdArticulos = a.IdArticulos ORDER BY im.IdImagenes) AS Imagen,
		a.IdUsuarios, a.IdCategorias, a.IdCategoriaACambio
	FROM ArticulosIntercambios ai
	INNER JOIN Intercambios i ON i.IdIntercambios = ai.IdIntercambio
	INNER JOIN Articulos a ON a.IdArticulos = ai.IdArticulo
	INNER JOIN EstadosArticulos e ON e.IdEstadosArticulos = a.IdEstado
	WHERE ai.IdIntercambio = @idIntercambio AND (i.IdUsuarios1 = @idUsuario OR i.IdUsuarios2 = @idUsuario)
	ORDER BY ai.Id
END
GO
/****** Object:  StoredProcedure [dbo].[GetBeneficiosPlanes]    Script Date: 18/11/2026 12:00:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetBeneficiosPlanes]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT IdPlan, Texto FROM BeneficiosPlanes ORDER BY IdPlan, Id
END
GO
/****** Object:  StoredProcedure [dbo].[GetCambiosIntercambio]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCambiosIntercambio]
	@idIntercambio int,
	@idUsuario int,
	@soloPendientes bit = 0
AS
BEGIN
	SET NOCOUNT ON;
	SELECT c.Id, c.IdArticulo, a.Nombre AS ArticuloNombre,
		(SELECT TOP 1 im.Ruta FROM Imagenes im WHERE im.IdArticulos = a.IdArticulos ORDER BY im.IdImagenes) AS ArticuloImagen,
		ea.Nombre AS ArticuloEstado, a.IdUsuarios AS IdDuenoArticulo, c.IdUsuario, u.Nombre AS UsuarioNombre,
		tc.Nombre AS Tipo, ec.Nombre AS Estado, c.Fecha, c.FechaRespuesta,
		CAST(CASE WHEN ei.Nombre IN ('Pendiente', 'Aceptado') THEN 1 ELSE 0 END AS bit) AS Vigente
	FROM CambiosIntercambios c
	INNER JOIN Intercambios i ON i.IdIntercambios = c.IdIntercambio
	INNER JOIN EstadosIntercambios ei ON ei.IdEstadosIntercambios = i.IdEstado
	INNER JOIN Articulos a ON a.IdArticulos = c.IdArticulo
	INNER JOIN EstadosArticulos ea ON ea.IdEstadosArticulos = a.IdEstado
	INNER JOIN Usuarios u ON u.IdUsuarios = c.IdUsuario
	INNER JOIN TipoCambios tc ON tc.Id = c.IdTipoCambio
	INNER JOIN EstadosIntercambios ec ON ec.IdEstadosIntercambios = c.IdEstado
	WHERE c.IdIntercambio = @idIntercambio AND (i.IdUsuarios1 = @idUsuario OR i.IdUsuarios2 = @idUsuario)
		AND (@soloPendientes = 0 OR (ec.Nombre = 'Pendiente' AND ei.Nombre IN ('Pendiente', 'Aceptado')))
	ORDER BY c.Fecha DESC, c.Id DESC
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
/****** Object:  StoredProcedure [dbo].[GetCategoriasDeUsuario]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCategoriasDeUsuario]
	@idUsuario int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT DISTINCT a.IdCategorias
	FROM Articulos a
	WHERE a.IdUsuarios = @idUsuario
		AND NOT EXISTS (SELECT 1 FROM ArticulosIntercambios aic
			INNER JOIN Intercambios ic ON ic.IdIntercambios = aic.IdIntercambio
			INNER JOIN EstadosIntercambios eic ON eic.IdEstadosIntercambios = ic.IdEstado
			WHERE eic.Nombre IN ('Aceptado', 'Realizado') AND aic.IdArticulo = a.IdArticulos)
END
GO
/****** Object:  StoredProcedure [dbo].[GetDatosMailNotificacion]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDatosMailNotificacion]
	@idUsuario int,
	@idIntercambio int,
	@idCambio int = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SELECT d.Mail, d.Nombre, o.Nombre AS OtroNombre
	FROM Intercambios i
	INNER JOIN Usuarios d ON d.IdUsuarios = @idUsuario
	INNER JOIN Usuarios o ON o.IdUsuarios = CASE WHEN i.IdUsuarios1 = @idUsuario THEN i.IdUsuarios2 ELSE i.IdUsuarios1 END
	WHERE i.IdIntercambios = @idIntercambio AND (i.IdUsuarios1 = @idUsuario OR i.IdUsuarios2 = @idUsuario);

	SELECT a.Nombre
	FROM ArticulosIntercambios ai
	INNER JOIN Articulos a ON a.IdArticulos = ai.IdArticulo
	WHERE ai.IdIntercambio = @idIntercambio AND a.IdUsuarios = @idUsuario
	ORDER BY ai.Id;

	SELECT a.Nombre
	FROM ArticulosIntercambios ai
	INNER JOIN Articulos a ON a.IdArticulos = ai.IdArticulo
	WHERE ai.IdIntercambio = @idIntercambio AND a.IdUsuarios <> @idUsuario
	ORDER BY ai.Id;

	SELECT tcn.Nombre AS CambioTipo, artcambio.Nombres AS CambioArticulos
	FROM CambiosIntercambios cn
	INNER JOIN TipoCambios tcn ON tcn.Id = cn.IdTipoCambio
	OUTER APPLY (SELECT STRING_AGG(ag.Nombre, ', ') WITHIN GROUP (ORDER BY cg.Id) AS Nombres
		FROM CambiosIntercambios cg
		INNER JOIN Articulos ag ON ag.IdArticulos = cg.IdArticulo
		WHERE cg.Id = cn.Id OR (tcn.Nombre = 'Agregar' AND cg.IdIntercambio = cn.IdIntercambio AND cg.IdUsuario = cn.IdUsuario
			AND cg.IdTipoCambio = cn.IdTipoCambio AND cg.Fecha = cn.Fecha)) artcambio
	WHERE cn.Id = @idCambio AND cn.IdIntercambio = @idIntercambio;
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
/****** Object:  StoredProcedure [dbo].[GetFavoritos]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFavoritos]
	@idUsuario int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT a.IdArticulos, a.Nombre, e.Nombre AS Estado, COALESCE(NULLIF(a.Ubicacion, ''), u.Barrio) AS Barrio,
		(SELECT TOP 1 i.Ruta FROM Imagenes i WHERE i.IdArticulos = a.IdArticulos ORDER BY i.IdImagenes) AS Imagen,
		a.IdUsuarios, a.IdCategorias, a.IdCategoriaACambio
	FROM Interacciones f
	INNER JOIN TipoInteracciones t ON t.Id = f.IdTipoInteraccion
	INNER JOIN Articulos a ON a.IdArticulos = f.IdArticulo
	INNER JOIN Usuarios u ON u.IdUsuarios = a.IdUsuarios
	INNER JOIN EstadosArticulos e ON e.IdEstadosArticulos = a.IdEstado
	WHERE f.IdUsuario = @idUsuario AND t.Nombre = 'Favorito'
		AND NOT EXISTS (SELECT 1 FROM ArticulosIntercambios aic
			INNER JOIN Intercambios ic ON ic.IdIntercambios = aic.IdIntercambio
			INNER JOIN EstadosIntercambios eic ON eic.IdEstadosIntercambios = ic.IdEstado
			WHERE eic.Nombre IN ('Aceptado', 'Realizado') AND aic.IdArticulo = a.IdArticulos)
	ORDER BY f.Fecha DESC, f.Id DESC
END
GO
/****** Object:  StoredProcedure [dbo].[GetFiltroCategorias]    Script Date: 17/11/2026 19:10:00 ******/
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
	SET @busqueda = REPLACE(REPLACE(REPLACE(NULLIF(LTRIM(RTRIM(@busqueda)), ''), '[', '[[]'), '%', '[%]'), '_', '[_]');
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
/****** Object:  StoredProcedure [dbo].[GetFiltroEstados]    Script Date: 17/11/2026 19:10:00 ******/
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
	SET @busqueda = REPLACE(REPLACE(REPLACE(NULLIF(LTRIM(RTRIM(@busqueda)), ''), '[', '[[]'), '%', '[%]'), '_', '[_]');
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
/****** Object:  StoredProcedure [dbo].[GetIdPropuestaEnCurso]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetIdPropuestaEnCurso]
	@idUsuario int,
	@idArticulo int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT TOP 1 i.IdIntercambios
	FROM Intercambios i
	INNER JOIN EstadosIntercambios e ON e.IdEstadosIntercambios = i.IdEstado
	INNER JOIN ArticulosIntercambios ai ON ai.IdIntercambio = i.IdIntercambios
	WHERE i.IdUsuarios1 = @idUsuario AND ai.IdArticulo = @idArticulo AND e.Nombre IN ('Pendiente', 'Aceptado')
	ORDER BY i.IdIntercambios DESC
END
GO
/****** Object:  StoredProcedure [dbo].[GetIdsFavoritos]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetIdsFavoritos]
	@idUsuario int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT f.IdArticulo
	FROM Interacciones f
	INNER JOIN TipoInteracciones t ON t.Id = f.IdTipoInteraccion
	WHERE f.IdUsuario = @idUsuario AND t.Nombre = 'Favorito'
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
/****** Object:  StoredProcedure [dbo].[GetIntercambios]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetIntercambios]
	@idUsuario int,
	@idIntercambio int = NULL,
	@estado varchar(50) = NULL,
	@enCurso bit = 0,
	@conChat bit = 0,
	@cantidad int = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SELECT TOP (ISNULL(@cantidad, 2147483647)) i.IdIntercambios, i.Fecha, e.Nombre AS Estado,
		CAST(CASE WHEN i.IdUsuarios2 = @idUsuario THEN 1 ELSE 0 END AS bit) AS EsRecibido,
		am.IdArticulos AS MiArticuloId, am.Nombre AS MiArticuloNombre, eam.Nombre AS MiArticuloEstado,
		(SELECT TOP 1 im.Ruta FROM Imagenes im WHERE im.IdArticulos = am.IdArticulos ORDER BY im.IdImagenes) AS MiArticuloImagen,
		mios.Cantidad AS CantidadMios,
		asu.IdArticulos AS SuArticuloId, asu.Nombre AS SuArticuloNombre, easu.Nombre AS SuArticuloEstado,
		(SELECT TOP 1 isu.Ruta FROM Imagenes isu WHERE isu.IdArticulos = asu.IdArticulos ORDER BY isu.IdImagenes) AS SuArticuloImagen,
		suyos.Cantidad AS CantidadSuyos,
		u.IdUsuarios AS OtroIdUsuario, u.Nombre AS OtroNombre, u.Apellido AS OtroApellido, u.Usuario AS OtroUsuario,
		u.Barrio AS OtroBarrio, p.Nombre AS OtroProvincia
	FROM Intercambios i
	INNER JOIN EstadosIntercambios e ON e.IdEstadosIntercambios = i.IdEstado
	CROSS APPLY (SELECT CASE WHEN i.IdUsuarios1 = @idUsuario THEN i.IdUsuarios2 ELSE i.IdUsuarios1 END AS IdOtro) lado
	CROSS APPLY (SELECT TOP 1 aim.IdArticulo, COUNT(*) OVER () AS Cantidad FROM ArticulosIntercambios aim
		INNER JOIN Articulos xm ON xm.IdArticulos = aim.IdArticulo
		WHERE aim.IdIntercambio = i.IdIntercambios AND xm.IdUsuarios = @idUsuario ORDER BY aim.Id) mios
	CROSS APPLY (SELECT TOP 1 ais.IdArticulo, COUNT(*) OVER () AS Cantidad FROM ArticulosIntercambios ais
		INNER JOIN Articulos xs ON xs.IdArticulos = ais.IdArticulo
		WHERE ais.IdIntercambio = i.IdIntercambios AND xs.IdUsuarios = lado.IdOtro ORDER BY ais.Id) suyos
	INNER JOIN Articulos am ON am.IdArticulos = mios.IdArticulo
	INNER JOIN EstadosArticulos eam ON eam.IdEstadosArticulos = am.IdEstado
	INNER JOIN Articulos asu ON asu.IdArticulos = suyos.IdArticulo
	INNER JOIN EstadosArticulos easu ON easu.IdEstadosArticulos = asu.IdEstado
	INNER JOIN Usuarios u ON u.IdUsuarios = lado.IdOtro
	LEFT JOIN Provincias p ON p.IdProvincia = u.IdProvincias
	OUTER APPLY (SELECT TOP 1 m.FechaEnviado FROM Mensajes m
		WHERE @conChat = 1 AND m.IdIntercambio = i.IdIntercambios ORDER BY m.IdMensajes DESC) ult
	WHERE (i.IdUsuarios1 = @idUsuario OR i.IdUsuarios2 = @idUsuario)
		AND (@idIntercambio IS NULL OR i.IdIntercambios = @idIntercambio)
		AND (@estado IS NULL OR e.Nombre = @estado)
		AND (@enCurso = 0 OR e.Nombre IN ('Pendiente', 'Aceptado'))
		AND (@conChat = 0 OR e.Nombre = 'Aceptado' OR (e.Nombre = 'Pendiente' AND i.IdUsuarios2 = @idUsuario)
			OR ult.FechaEnviado IS NOT NULL)
	ORDER BY CASE WHEN @enCurso = 1 AND i.IdUsuarios2 = @idUsuario AND e.Nombre = 'Pendiente' THEN 0 ELSE 1 END,
		CASE WHEN @conChat = 1 THEN ISNULL(ult.FechaEnviado, CAST(i.Fecha AS datetime)) END DESC,
		i.Fecha DESC, i.IdIntercambios DESC
END
GO
/****** Object:  StoredProcedure [dbo].[GetMensajes]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetMensajes]
	@idIntercambio int,
	@idUsuario int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT m.IdMensajes, m.Texto, m.fueVisto, m.FechaEnviado, m.FechaRecibido, m.IdUsuariosManda, m.IdIntercambio
	FROM Mensajes m
	INNER JOIN Intercambios i ON i.IdIntercambios = m.IdIntercambio
	WHERE m.IdIntercambio = @idIntercambio AND (i.IdUsuarios1 = @idUsuario OR i.IdUsuarios2 = @idUsuario)
	ORDER BY m.IdMensajes
END
GO
/****** Object:  StoredProcedure [dbo].[GetNotificaciones]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetNotificaciones]
	@idUsuario int,
	@cantidad int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT TOP (@cantidad) n.Id, t.Nombre AS Tipo, n.Leida, n.Fecha, n.IdIntercambio,
		u.Nombre AS OtroNombre, a.Nombre AS ArticuloNombre, tcn.Nombre AS CambioTipo, artcambio.Nombres AS CambioArticulos
	FROM Notificaciones n
	INNER JOIN TipoNotificaciones t ON t.Id = n.IdTipoNotificacion
	INNER JOIN Intercambios i ON i.IdIntercambios = n.IdIntercambio
	INNER JOIN Usuarios u ON u.IdUsuarios = CASE WHEN i.IdUsuarios1 = n.IdUsuario THEN i.IdUsuarios2 ELSE i.IdUsuarios1 END
	CROSS APPLY (SELECT TOP 1 ap.Nombre FROM ArticulosIntercambios ai
		INNER JOIN Articulos ap ON ap.IdArticulos = ai.IdArticulo
		WHERE ai.IdIntercambio = i.IdIntercambios AND ap.IdUsuarios = i.IdUsuarios2
		ORDER BY ai.Id) a
	LEFT JOIN CambiosIntercambios cn ON cn.Id = n.IdCambio
	LEFT JOIN TipoCambios tcn ON tcn.Id = cn.IdTipoCambio
	OUTER APPLY (SELECT STRING_AGG(ag.Nombre, ', ') WITHIN GROUP (ORDER BY cg.Id) AS Nombres
		FROM CambiosIntercambios cg
		INNER JOIN Articulos ag ON ag.IdArticulos = cg.IdArticulo
		WHERE cg.Id = cn.Id OR (tcn.Nombre = 'Agregar' AND cg.IdIntercambio = cn.IdIntercambio AND cg.IdUsuario = cn.IdUsuario
			AND cg.IdTipoCambio = cn.IdTipoCambio AND cg.Fecha = cn.Fecha)) artcambio
	WHERE n.IdUsuario = @idUsuario
	ORDER BY n.Fecha DESC, n.Id DESC
END
GO
/****** Object:  StoredProcedure [dbo].[GetPlanDeUsuario]    Script Date: 18/11/2026 12:00:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPlanDeUsuario]
	@idUsuario int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT p.Id, p.Nombre, p.Etiqueta, p.PrecioMensual, p.MaxArticulos, p.MaxIntercambios, p.Prioridad
	FROM Usuarios u
	INNER JOIN Planes p ON p.Id = u.IdPlan
	WHERE u.IdUsuarios = @idUsuario
END
GO
/****** Object:  StoredProcedure [dbo].[GetPlanes]    Script Date: 18/11/2026 12:00:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPlanes]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT Id, Nombre, Etiqueta, PrecioMensual, MaxArticulos, MaxIntercambios, Prioridad FROM Planes ORDER BY PrecioMensual, Id
END
GO
/****** Object:  StoredProcedure [dbo].[GetPopularidad]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPopularidad]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT i.IdArticulo, SUM(CASE WHEN t.Nombre = 'Vista' THEN 1 WHEN t.Nombre = 'Favorito' THEN 3 ELSE 0 END) AS Puntos
	FROM Interacciones i
	INNER JOIN TipoInteracciones t ON t.Id = i.IdTipoInteraccion
	WHERE i.IdArticulo IS NOT NULL AND i.Fecha >= DATEADD(DAY, -30, GETDATE())
	GROUP BY i.IdArticulo
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
/****** Object:  StoredProcedure [dbo].[GetResumenesChat]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetResumenesChat]
	@idUsuario int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT i.IdIntercambios AS IdIntercambio, ult.Texto AS UltimoTexto, ult.FechaEnviado AS UltimaFecha,
		CAST(CASE WHEN ult.IdUsuariosManda = @idUsuario THEN 1 ELSE 0 END AS bit) AS UltimoEsMio,
		(SELECT COUNT(*) FROM Mensajes m
			WHERE m.IdIntercambio = i.IdIntercambios AND m.IdUsuariosManda <> @idUsuario AND m.fueVisto = 0) AS NoLeidos
	FROM Intercambios i
	CROSS APPLY (SELECT TOP 1 m.Texto, m.FechaEnviado, m.IdUsuariosManda FROM Mensajes m
		WHERE m.IdIntercambio = i.IdIntercambios ORDER BY m.IdMensajes DESC) ult
	WHERE i.IdUsuarios1 = @idUsuario OR i.IdUsuarios2 = @idUsuario
END
GO
/****** Object:  StoredProcedure [dbo].[GetSenalesGustos]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSenalesGustos]
	@idsUsuarios varchar(max),
	@desde datetime
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @usuarios TABLE (IdUsuario int PRIMARY KEY);
	INSERT INTO @usuarios (IdUsuario)
	SELECT DISTINCT CAST(value AS int) FROM STRING_SPLIT(@idsUsuarios, ',') WHERE value <> '';

	SELECT i.IdUsuario, t.Nombre AS Tipo, COALESCE(i.IdCategoria, ai.IdCategorias) AS IdCategoria,
		i.Texto, i.Segundos, i.Fecha
	FROM Interacciones i
	INNER JOIN TipoInteracciones t ON t.Id = i.IdTipoInteraccion
	LEFT JOIN Articulos ai ON ai.IdArticulos = i.IdArticulo
	WHERE i.IdUsuario IN (SELECT IdUsuario FROM @usuarios) AND i.Fecha >= @desde

	UNION ALL

	SELECT ic.IdUsuarios1, 'Propuesta', ap.IdCategorias, NULL, NULL, CAST(ic.Fecha AS datetime)
	FROM Intercambios ic
	INNER JOIN ArticulosIntercambios aip ON aip.IdIntercambio = ic.IdIntercambios
	INNER JOIN Articulos ap ON ap.IdArticulos = aip.IdArticulo AND ap.IdUsuarios = ic.IdUsuarios2
	WHERE ic.IdUsuarios1 IN (SELECT IdUsuario FROM @usuarios) AND ic.Fecha >= CAST(@desde AS date)

	UNION ALL

	SELECT a.IdUsuarios, 'Pide a cambio', a.IdCategoriaACambio, NULL, NULL, GETDATE()
	FROM Articulos a
	WHERE a.IdUsuarios IN (SELECT IdUsuario FROM @usuarios) AND a.IdCategoriaACambio IS NOT NULL
		AND NOT EXISTS (SELECT 1 FROM ArticulosIntercambios aic
			INNER JOIN Intercambios ic ON ic.IdIntercambios = aic.IdIntercambio
			INNER JOIN EstadosIntercambios eic ON eic.IdEstadosIntercambios = ic.IdEstado
			WHERE eic.Nombre IN ('Aceptado', 'Realizado') AND aic.IdArticulo = a.IdArticulos)
END
GO
/****** Object:  StoredProcedure [dbo].[GetUltimoCambio]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUltimoCambio]
	@idIntercambio int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT ISNULL(MAX(Id), 0) FROM CambiosIntercambios WHERE IdIntercambio = @idIntercambio
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
        [Fecha nacimiento] AS FechaNacimiento, Edad, IdProvincias, Descripcion, IdPlan
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
        [Fecha nacimiento] AS FechaNacimiento, Edad, IdProvincias, Descripcion, IdPlan FROM Usuarios
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
/****** Object:  StoredProcedure [dbo].[GuardarSegundosVista]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GuardarSegundosVista]
	@idInteraccion int,
	@idUsuario int,
	@segundos int
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE Interacciones SET Segundos = @segundos
	WHERE Id = @idInteraccion AND IdUsuario = @idUsuario
		AND IdTipoInteraccion = (SELECT Id FROM TipoInteracciones WHERE Nombre = 'Vista')
END
GO
/****** Object:  StoredProcedure [dbo].[ImportarFavoritos]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ImportarFavoritos]
	@idUsuario int,
	@idsArticulos varchar(max)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @idFavorito int = (SELECT Id FROM TipoInteracciones WHERE Nombre = 'Favorito');

	INSERT INTO Interacciones (IdUsuario, IdTipoInteraccion, IdArticulo, Fecha)
	SELECT @idUsuario, @idFavorito, a.IdArticulos, GETDATE()
	FROM Articulos a
	WHERE a.IdArticulos IN (SELECT CAST(value AS int) FROM STRING_SPLIT(@idsArticulos, ',') WHERE value <> '')
		AND a.IdUsuarios <> @idUsuario
		AND NOT EXISTS (SELECT 1 FROM Interacciones f
			WHERE f.IdUsuario = @idUsuario AND f.IdArticulo = a.IdArticulos AND f.IdTipoInteraccion = @idFavorito)
END
GO
/****** Object:  StoredProcedure [dbo].[IntercambioConArticuloComprometido]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[IntercambioConArticuloComprometido]
	@idIntercambio int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT CAST(CASE WHEN EXISTS (SELECT 1 FROM ArticulosIntercambios mio
			INNER JOIN ArticulosIntercambios otro ON otro.IdArticulo = mio.IdArticulo AND otro.IdIntercambio <> mio.IdIntercambio
			INNER JOIN Intercambios io ON io.IdIntercambios = otro.IdIntercambio
			INNER JOIN EstadosIntercambios eio ON eio.IdEstadosIntercambios = io.IdEstado
			WHERE mio.IdIntercambio = @idIntercambio AND eio.Nombre IN ('Aceptado', 'Realizado')) THEN 1 ELSE 0 END AS bit)
END
GO
/****** Object:  StoredProcedure [dbo].[MarcarMensajesVistos]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MarcarMensajesVistos]
	@idIntercambio int,
	@idUsuario int
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE m SET m.fueVisto = 1, m.FechaRecibido = GETDATE()
	FROM Mensajes m
	INNER JOIN Intercambios i ON i.IdIntercambios = m.IdIntercambio
	WHERE m.IdIntercambio = @idIntercambio AND m.IdUsuariosManda <> @idUsuario AND m.fueVisto = 0
		AND (i.IdUsuarios1 = @idUsuario OR i.IdUsuarios2 = @idUsuario);

	UPDATE n SET n.Leida = 1
	FROM Notificaciones n
	INNER JOIN TipoNotificaciones t ON t.Id = n.IdTipoNotificacion
	WHERE n.IdUsuario = @idUsuario AND n.IdIntercambio = @idIntercambio AND t.Nombre = 'Mensaje nuevo' AND n.Leida = 0;
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
/****** Object:  StoredProcedure [dbo].[MarcarNotificacionLeida]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MarcarNotificacionLeida]
	@idNotificacion int,
	@idUsuario int
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE Notificaciones SET Leida = 1 WHERE Id = @idNotificacion AND IdUsuario = @idUsuario;

	SELECT n.Id, n.IdIntercambio, t.Nombre AS Tipo
	FROM Notificaciones n
	INNER JOIN TipoNotificaciones t ON t.Id = n.IdTipoNotificacion
	WHERE n.Id = @idNotificacion AND n.IdUsuario = @idUsuario
END
GO
/****** Object:  StoredProcedure [dbo].[ProponerIntercambio]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ProponerIntercambio]
	@idUsuario int,
	@idsOfrecidos varchar(max),
	@idDueno int,
	@idArticuloPedido int
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;
	CREATE TABLE #Creadas (IdUsuario int, IdIntercambio int, Tipo varchar(50), IdCambio int NULL);
	DECLARE @idIntercambio int;
	DECLARE @ofrecidos TABLE (IdArticulo int PRIMARY KEY);
	INSERT INTO @ofrecidos (IdArticulo)
	SELECT DISTINCT CAST(value AS int) FROM STRING_SPLIT(@idsOfrecidos, ',') WHERE value <> '';

	BEGIN TRANSACTION;
	INSERT INTO Intercambios (Fecha, IdEstado, IdUsuarios1, IdUsuarios2)
	SELECT CAST(GETDATE() AS date), e.IdEstadosIntercambios, @idUsuario, @idDueno
	FROM EstadosIntercambios e
	WHERE e.Nombre = 'Pendiente'
		AND NOT EXISTS (SELECT 1 FROM Intercambios i
			INNER JOIN EstadosIntercambios ei ON ei.IdEstadosIntercambios = i.IdEstado
			INNER JOIN ArticulosIntercambios ai ON ai.IdIntercambio = i.IdIntercambios
			WHERE i.IdUsuarios1 = @idUsuario AND ai.IdArticulo = @idArticuloPedido AND ei.Nombre IN ('Pendiente', 'Aceptado'))
		AND NOT EXISTS (SELECT 1 FROM ArticulosIntercambios aic
			INNER JOIN Intercambios ic ON ic.IdIntercambios = aic.IdIntercambio
			INNER JOIN EstadosIntercambios eic ON eic.IdEstadosIntercambios = ic.IdEstado
			WHERE eic.Nombre IN ('Aceptado', 'Realizado')
				AND (aic.IdArticulo = @idArticuloPedido OR aic.IdArticulo IN (SELECT IdArticulo FROM @ofrecidos)));

	IF @@ROWCOUNT > 0
	BEGIN
		SET @idIntercambio = SCOPE_IDENTITY();
		INSERT INTO ArticulosIntercambios (IdArticulo, IdIntercambio)
		SELECT a.IdArticulos, @idIntercambio
		FROM Articulos a
		WHERE (a.IdArticulos IN (SELECT IdArticulo FROM @ofrecidos) AND a.IdUsuarios = @idUsuario)
			OR (a.IdArticulos = @idArticuloPedido AND a.IdUsuarios = @idDueno)
		ORDER BY CASE WHEN a.IdUsuarios = @idUsuario THEN 0 ELSE 1 END, a.IdArticulos;
		EXEC CrearNotificacion @idDueno, @idIntercambio, 'Propuesta recibida';
	END
	COMMIT TRANSACTION;

	SELECT @idIntercambio AS IdIntercambio;
	SELECT IdUsuario, IdIntercambio, Tipo, IdCambio FROM #Creadas;
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
/****** Object:  StoredProcedure [dbo].[RegistrarBusqueda]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RegistrarBusqueda]
	@idUsuario int,
	@texto varchar(100) = NULL,
	@categorias varchar(max) = NULL,
	@minutosSinRepetir int
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @idBusqueda int = (SELECT Id FROM TipoInteracciones WHERE Nombre = 'Búsqueda');
	DECLARE @idFiltro int = (SELECT Id FROM TipoInteracciones WHERE Nombre = 'Filtro por categoría');

	IF LTRIM(RTRIM(ISNULL(@texto, ''))) <> ''
		INSERT INTO Interacciones (IdUsuario, IdTipoInteraccion, Texto, Fecha)
		SELECT @idUsuario, @idBusqueda, @texto, GETDATE()
		WHERE NOT EXISTS (SELECT 1 FROM Interacciones r
			WHERE r.IdUsuario = @idUsuario AND r.IdTipoInteraccion = @idBusqueda AND r.Texto = @texto
				AND r.Fecha >= DATEADD(MINUTE, -@minutosSinRepetir, GETDATE()));

	INSERT INTO Interacciones (IdUsuario, IdTipoInteraccion, IdCategoria, Fecha)
	SELECT @idUsuario, @idFiltro, c.IdCategorias, GETDATE()
	FROM Categorias c
	WHERE c.IdCategorias IN (SELECT CAST(value AS int) FROM STRING_SPLIT(@categorias, ',') WHERE value <> '')
		AND NOT EXISTS (SELECT 1 FROM Interacciones r
			WHERE r.IdUsuario = @idUsuario AND r.IdTipoInteraccion = @idFiltro AND r.IdCategoria = c.IdCategorias
				AND r.Fecha >= DATEADD(MINUTE, -@minutosSinRepetir, GETDATE()))
	ORDER BY c.IdCategorias;
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
/****** Object:  StoredProcedure [dbo].[RegistrarUsuario]    Script Date: 17/11/2026 19:10:00 ******/
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
	@edad int,
	@idProvincia int,
	@idPlan int
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO Usuarios (Nombre, Apellido, Usuario, Mail, Telefono, Contraseña, Barrio, [Fecha nacimiento], Edad, IdProvincias, IdPlan)
	VALUES (@nombre, @apellido, @usuario, @mail, @telefono, @contraseña, @barrio, @fechaNacimiento, @edad, @idProvincia, @idPlan)
END
GO
/****** Object:  StoredProcedure [dbo].[RegistrarVista]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RegistrarVista]
	@idUsuario int,
	@idArticulo int
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO Interacciones (IdUsuario, IdTipoInteraccion, IdArticulo, Segundos, Fecha)
	VALUES (@idUsuario, (SELECT Id FROM TipoInteracciones WHERE Nombre = 'Vista'), @idArticulo, 0, GETDATE());

	SELECT CAST(SCOPE_IDENTITY() AS int) AS IdInteraccion
END
GO
/****** Object:  StoredProcedure [dbo].[ResponderCambio]    Script Date: 17/11/2026 19:10:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ResponderCambio]
	@idCambio int,
	@idUsuario int,
	@aceptar bit
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;
	CREATE TABLE #Creadas (IdUsuario int, IdIntercambio int, Tipo varchar(50), IdCambio int NULL);
	DECLARE @idIntercambio int, @bloqueo int, @idArticulo int, @idAutor int, @tipo varchar(50), @idDueno int,
		@estadoIntercambio varchar(50), @filas int = 1, @respondido bit = 0, @tipoNotificacion varchar(50);

	BEGIN TRANSACTION;
	SELECT @idIntercambio = IdIntercambio FROM CambiosIntercambios WHERE Id = @idCambio;
	SELECT @bloqueo = IdIntercambios FROM Intercambios WITH (UPDLOCK, HOLDLOCK) WHERE IdIntercambios = @idIntercambio;

	SELECT @idArticulo = c.IdArticulo, @idAutor = c.IdUsuario, @tipo = tc.Nombre, @idDueno = a.IdUsuarios, @estadoIntercambio = ei.Nombre
	FROM CambiosIntercambios c
	INNER JOIN EstadosIntercambios ec ON ec.IdEstadosIntercambios = c.IdEstado
	INNER JOIN TipoCambios tc ON tc.Id = c.IdTipoCambio
	INNER JOIN Articulos a ON a.IdArticulos = c.IdArticulo
	INNER JOIN Intercambios i ON i.IdIntercambios = c.IdIntercambio
	INNER JOIN EstadosIntercambios ei ON ei.IdEstadosIntercambios = i.IdEstado
	WHERE c.Id = @idCambio AND ec.Nombre = 'Pendiente' AND ei.Nombre IN ('Pendiente', 'Aceptado')
		AND c.IdUsuario <> @idUsuario AND (i.IdUsuarios1 = @idUsuario OR i.IdUsuarios2 = @idUsuario);

	IF @idAutor IS NOT NULL
	BEGIN
		UPDATE CambiosIntercambios
		SET IdEstado = (SELECT e.IdEstadosIntercambios FROM EstadosIntercambios e
				WHERE e.Nombre = CASE WHEN @aceptar = 1 THEN 'Aceptado' ELSE 'Rechazado' END),
			FechaRespuesta = GETDATE()
		WHERE Id = @idCambio;

		IF @aceptar = 1 AND @tipo = 'Pedir'
		BEGIN
			INSERT INTO ArticulosIntercambios (IdArticulo, IdIntercambio)
			SELECT a.IdArticulos, @idIntercambio
			FROM Articulos a
			WHERE a.IdArticulos = @idArticulo AND a.IdUsuarios = @idDueno
				AND NOT EXISTS (SELECT 1 FROM ArticulosIntercambios ae WHERE ae.IdIntercambio = @idIntercambio AND ae.IdArticulo = a.IdArticulos)
				AND NOT EXISTS (SELECT 1 FROM ArticulosIntercambios aic
					INNER JOIN Intercambios ic ON ic.IdIntercambios = aic.IdIntercambio
					INNER JOIN EstadosIntercambios eic ON eic.IdEstadosIntercambios = ic.IdEstado
					WHERE eic.Nombre IN ('Aceptado', 'Realizado') AND aic.IdArticulo = a.IdArticulos)
				AND (SELECT COUNT(*) FROM ArticulosIntercambios ac
					INNER JOIN Articulos xa ON xa.IdArticulos = ac.IdArticulo
					WHERE ac.IdIntercambio = @idIntercambio AND xa.IdUsuarios = @idDueno) < 3;
			SET @filas = @@ROWCOUNT;
		END
		ELSE IF @aceptar = 1
		BEGIN
			DELETE ai FROM ArticulosIntercambios ai
			WHERE ai.IdIntercambio = @idIntercambio AND ai.IdArticulo = @idArticulo
				AND (SELECT COUNT(*) FROM ArticulosIntercambios ac
					INNER JOIN Articulos xa ON xa.IdArticulos = ac.IdArticulo
					WHERE ac.IdIntercambio = @idIntercambio AND xa.IdUsuarios = @idDueno) >= 2;
			SET @filas = @@ROWCOUNT;
		END
	END

	IF @idAutor IS NULL OR @filas = 0
		ROLLBACK TRANSACTION;
	ELSE
	BEGIN
		IF @aceptar = 1 AND @tipo = 'Pedir' AND @estadoIntercambio = 'Aceptado'
			EXEC RechazarPendientesDeArticulos @idIntercambio, @idUsuario;
		SET @tipoNotificacion = CASE WHEN @aceptar = 1 THEN 'Cambio aceptado' ELSE 'Cambio rechazado' END;
		EXEC CrearNotificacion @idAutor, @idIntercambio, @tipoNotificacion, @idCambio = @idCambio;
		COMMIT TRANSACTION;
		SET @respondido = 1;
	END

	SELECT @respondido AS Respondido;
	SELECT IdUsuario, IdIntercambio, Tipo, IdCambio FROM #Creadas;
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
