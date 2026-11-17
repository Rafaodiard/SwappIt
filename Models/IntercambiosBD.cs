using Dapper;
using Microsoft.Data.SqlClient;
using System.Data;
using Swappit.Models.ViewModels;

namespace Swappit.Models;

public static class IntercambiosBD
{
    private static string _connectionString = //@"Server=localhost; DataBase=Base_De_Datos_Swappit; Integrated Security=True; TrustServerCertificate=True;";
    @"Server=.\SQLEXPRESS;Database=Base_De_Datos_Swappit;Integrated Security=True;TrustServerCertificate=True;";

    public static int ContarIntercambiosActivos(int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = @"SELECT COUNT(*)
                FROM Intercambios i
                INNER JOIN EstadosIntercambios e ON e.IdEstadosIntercambios = i.IdEstado
                WHERE i.IdUsuarios1 = @pIdUsuario
                    AND e.Nombre IN @pEnCurso";
            return connection.ExecuteScalar<int>(query, new
            {
                pIdUsuario = idUsuario,
                pEnCurso = new[] { EstadosIntercambios.Pendiente, EstadosIntercambios.Aceptado }
            });
        }
    }

    private const string ConsultaIntercambios = @"i.IdIntercambios, i.Fecha, e.Nombre AS Estado,
            CAST(CASE WHEN i.IdUsuarios2 = @pIdUsuario THEN 1 ELSE 0 END AS bit) AS EsRecibido,
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
        CROSS APPLY (SELECT CASE WHEN i.IdUsuarios1 = @pIdUsuario THEN i.IdUsuarios2 ELSE i.IdUsuarios1 END AS IdOtro) lado
        CROSS APPLY (SELECT TOP 1 aim.IdArticulo, COUNT(*) OVER () AS Cantidad FROM ArticulosIntercambios aim
            INNER JOIN Articulos xm ON xm.IdArticulos = aim.IdArticulo
            WHERE aim.IdIntercambio = i.IdIntercambios AND xm.IdUsuarios = @pIdUsuario ORDER BY aim.Id) mios
        CROSS APPLY (SELECT TOP 1 ais.IdArticulo, COUNT(*) OVER () AS Cantidad FROM ArticulosIntercambios ais
            INNER JOIN Articulos xs ON xs.IdArticulos = ais.IdArticulo
            WHERE ais.IdIntercambio = i.IdIntercambios AND xs.IdUsuarios = lado.IdOtro ORDER BY ais.Id) suyos
        INNER JOIN Articulos am ON am.IdArticulos = mios.IdArticulo
        INNER JOIN EstadosArticulos eam ON eam.IdEstadosArticulos = am.IdEstado
        INNER JOIN Articulos asu ON asu.IdArticulos = suyos.IdArticulo
        INNER JOIN EstadosArticulos easu ON easu.IdEstadosArticulos = asu.IdEstado
        INNER JOIN Usuarios u ON u.IdUsuarios = lado.IdOtro
        LEFT JOIN Provincias p ON p.IdProvincia = u.IdProvincias
        WHERE (i.IdUsuarios1 = @pIdUsuario OR i.IdUsuarios2 = @pIdUsuario)";

    public static List<IntercambioViewModel> GetIntercambios(int idUsuario, int? cantidad = null)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string top = cantidad.HasValue ? "TOP (@pCantidad) " : "";
            string query = $"SELECT {top}{ConsultaIntercambios} ORDER BY i.Fecha DESC, i.IdIntercambios DESC";
            return connection.Query<IntercambioViewModel>(query, new { pIdUsuario = idUsuario, pCantidad = cantidad }).ToList();
        }
    }

    public static IntercambioViewModel? GetIntercambio(int idIntercambio, int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = $"SELECT {ConsultaIntercambios} AND i.IdIntercambios = @pId";
            return connection.QueryFirstOrDefault<IntercambioViewModel>(query, new { pId = idIntercambio, pIdUsuario = idUsuario });
        }
    }

    public static int? GetIdPropuestaEnCurso(int idUsuario, int idArticuloPedido)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = @"SELECT TOP 1 i.IdIntercambios FROM Intercambios i
                INNER JOIN EstadosIntercambios e ON e.IdEstadosIntercambios = i.IdEstado
                INNER JOIN ArticulosIntercambios ai ON ai.IdIntercambio = i.IdIntercambios
                WHERE i.IdUsuarios1 = @pIdUsuario AND ai.IdArticulo = @pIdArticulo AND e.Nombre IN @pEnCurso
                ORDER BY i.IdIntercambios DESC";
            return connection.QueryFirstOrDefault<int?>(query, new
            {
                pIdUsuario = idUsuario,
                pIdArticulo = idArticuloPedido,
                pEnCurso = new[] { EstadosIntercambios.Pendiente, EstadosIntercambios.Aceptado }
            });
        }
    }

    public static bool ArticuloComprometido(int idArticulo)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = "SELECT CAST(CASE WHEN " + ArticuloDisponible + " THEN 0 ELSE 1 END AS bit) FROM Articulos a WHERE a.IdArticulos = @pId";
            return connection.QueryFirstOrDefault<bool>(query, new { pId = idArticulo, pComprometidos = EstadosComprometidos });
        }
    }

    private const string ArticuloComprometidoEnOtro = @"EXISTS (SELECT 1 FROM ArticulosIntercambios mio
        INNER JOIN ArticulosIntercambios otro ON otro.IdArticulo = mio.IdArticulo AND otro.IdIntercambio <> mio.IdIntercambio
        INNER JOIN Intercambios io ON io.IdIntercambios = otro.IdIntercambio
        INNER JOIN EstadosIntercambios eio ON eio.IdEstadosIntercambios = io.IdEstado
        WHERE mio.IdIntercambio = @pId AND eio.Nombre IN @pComprometidos)";

    public static bool IntercambioConArticuloComprometido(int idIntercambio)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = $"SELECT CAST(CASE WHEN {ArticuloComprometidoEnOtro} THEN 1 ELSE 0 END AS bit)";
            return connection.QuerySingle<bool>(query, new { pId = idIntercambio, pComprometidos = EstadosComprometidos });
        }
    }

    public static List<ArticuloCardViewModel> GetArticulosDeIntercambio(int idIntercambio, int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = @"SELECT a.IdArticulos, a.Nombre, e.Nombre AS Estado,
                    (SELECT TOP 1 im.Ruta FROM Imagenes im WHERE im.IdArticulos = a.IdArticulos ORDER BY im.IdImagenes) AS Imagen,
                    a.IdUsuarios, a.IdCategorias, a.IdCategoriaACambio
                FROM ArticulosIntercambios ai
                INNER JOIN Intercambios i ON i.IdIntercambios = ai.IdIntercambio
                INNER JOIN Articulos a ON a.IdArticulos = ai.IdArticulo
                INNER JOIN EstadosArticulos e ON e.IdEstadosArticulos = a.IdEstado
                WHERE ai.IdIntercambio = @pId AND (i.IdUsuarios1 = @pIdUsuario OR i.IdUsuarios2 = @pIdUsuario)
                ORDER BY ai.Id";
            return connection.Query<ArticuloCardViewModel>(query, new { pId = idIntercambio, pIdUsuario = idUsuario }).ToList();
        }
    }

    public static int? ProponerIntercambio(int idUsuario, IReadOnlyCollection<int> idsOfrecidos, int idDueno, int idArticuloPedido,
        List<NotificacionCreada>? creadas = null)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            connection.Open();
            using (SqlTransaction transaccion = connection.BeginTransaction())
            {
                string query = @"INSERT INTO Intercambios (Fecha, IdEstado, IdUsuarios1, IdUsuarios2)
                    OUTPUT INSERTED.IdIntercambios
                    SELECT CAST(GETDATE() AS date), e.IdEstadosIntercambios, @pIdUsuario, @pIdDueno
                    FROM EstadosIntercambios e
                    WHERE e.Nombre = @pPendiente
                        AND NOT EXISTS (SELECT 1 FROM Intercambios i
                            INNER JOIN EstadosIntercambios ei ON ei.IdEstadosIntercambios = i.IdEstado
                            INNER JOIN ArticulosIntercambios ai ON ai.IdIntercambio = i.IdIntercambios
                            WHERE i.IdUsuarios1 = @pIdUsuario AND ai.IdArticulo = @pIdPedido AND ei.Nombre IN @pEnCurso)
                        AND NOT EXISTS (SELECT 1 FROM ArticulosIntercambios aic
                            INNER JOIN Intercambios ic ON ic.IdIntercambios = aic.IdIntercambio
                            INNER JOIN EstadosIntercambios eic ON eic.IdEstadosIntercambios = ic.IdEstado
                            WHERE eic.Nombre IN @pComprometidos AND aic.IdArticulo IN @pIdsArticulos)";
                int? idIntercambio = connection.QueryFirstOrDefault<int?>(query, new
                {
                    pIdUsuario = idUsuario,
                    pIdDueno = idDueno,
                    pIdPedido = idArticuloPedido,
                    pIdsArticulos = idsOfrecidos.Append(idArticuloPedido).ToList(),
                    pPendiente = EstadosIntercambios.Pendiente,
                    pEnCurso = new[] { EstadosIntercambios.Pendiente, EstadosIntercambios.Aceptado },
                    pComprometidos = EstadosComprometidos
                }, transaccion);

                List<NotificacionCreada> nuevas = new List<NotificacionCreada>();
                if (idIntercambio.HasValue)
                {
                    string queryArticulos = @"INSERT INTO ArticulosIntercambios (IdArticulo, IdIntercambio)
                        SELECT a.IdArticulos, @pIdIntercambio FROM Articulos a
                        WHERE (a.IdArticulos IN @pIdsOfrecidos AND a.IdUsuarios = @pIdUsuario)
                            OR (a.IdArticulos = @pIdPedido AND a.IdUsuarios = @pIdDueno)
                        ORDER BY CASE WHEN a.IdUsuarios = @pIdUsuario THEN 0 ELSE 1 END, a.IdArticulos";
                    connection.Execute(queryArticulos, new
                    {
                        pIdIntercambio = idIntercambio.Value,
                        pIdsOfrecidos = idsOfrecidos,
                        pIdUsuario = idUsuario,
                        pIdPedido = idArticuloPedido,
                        pIdDueno = idDueno
                    }, transaccion);
                    CrearNotificacion(connection, transaccion, nuevas, idDueno, idIntercambio.Value, TipoNotificaciones.PropuestaRecibida);
                }

                transaccion.Commit();
                creadas?.AddRange(nuevas);
                return idIntercambio;
            }
        }
    }

    public static bool CambiarEstadoIntercambio(int idIntercambio, int idUsuario, string estadoActual, string estadoNuevo,
        bool soloQuienRecibe, string? tipoNotificacion = null, List<NotificacionCreada>? creadas = null, int? ultimoCambioVisto = null)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            connection.Open();
            using (SqlTransaction transaccion = connection.BeginTransaction())
            {
                connection.Execute("SELECT 1 FROM Intercambios WITH (UPDLOCK, HOLDLOCK) WHERE IdIntercambios = @pId",
                    new { pId = idIntercambio }, transaccion);

                string query = $@"UPDATE i SET i.IdEstado = nuevo.IdEstadosIntercambios
                    OUTPUT CASE WHEN INSERTED.IdUsuarios1 = @pIdUsuario THEN INSERTED.IdUsuarios2 ELSE INSERTED.IdUsuarios1 END
                    FROM Intercambios i
                    INNER JOIN EstadosIntercambios actual ON actual.IdEstadosIntercambios = i.IdEstado
                    INNER JOIN EstadosIntercambios nuevo ON nuevo.Nombre = @pNuevo
                    WHERE i.IdIntercambios = @pId AND actual.Nombre = @pActual
                        AND (i.IdUsuarios2 = @pIdUsuario OR (@pSoloQuienRecibe = 0 AND i.IdUsuarios1 = @pIdUsuario))
                        AND (@pNuevo <> @pAceptado OR NOT {ArticuloComprometidoEnOtro})
                        AND (@pNuevo <> @pRealizado OR NOT EXISTS (SELECT 1 FROM CambiosIntercambios cr
                            INNER JOIN EstadosIntercambios er ON er.IdEstadosIntercambios = cr.IdEstado
                            WHERE cr.IdIntercambio = i.IdIntercambios AND er.Nombre = @pPendiente))
                        AND (@pNuevo <> @pAceptado OR (NOT EXISTS (SELECT 1 FROM CambiosIntercambios cr
                                INNER JOIN EstadosIntercambios er ON er.IdEstadosIntercambios = cr.IdEstado
                                WHERE cr.IdIntercambio = i.IdIntercambios AND er.Nombre = @pPendiente AND cr.IdUsuario <> @pIdUsuario)
                            AND NOT EXISTS (SELECT 1 FROM CambiosIntercambios cu
                                WHERE cu.IdIntercambio = i.IdIntercambios AND cu.Id > ISNULL(@pUltimoCambio, 0))))";
                int? idOtro = connection.QueryFirstOrDefault<int?>(query, new
                {
                    pId = idIntercambio,
                    pIdUsuario = idUsuario,
                    pActual = estadoActual,
                    pNuevo = estadoNuevo,
                    pSoloQuienRecibe = soloQuienRecibe,
                    pAceptado = EstadosIntercambios.Aceptado,
                    pRealizado = EstadosIntercambios.Realizado,
                    pPendiente = EstadosIntercambios.Pendiente,
                    pUltimoCambio = ultimoCambioVisto,
                    pComprometidos = EstadosComprometidos
                }, transaccion);

                List<NotificacionCreada> nuevas = new List<NotificacionCreada>();
                if (idOtro.HasValue && tipoNotificacion != null)
                {
                    CrearNotificacion(connection, transaccion, nuevas, idOtro.Value, idIntercambio, tipoNotificacion);
                }

                if (idOtro.HasValue && estadoNuevo == EstadosIntercambios.Aceptado)
                {
                    RechazarPendientesDeArticulos(connection, transaccion, nuevas, idIntercambio, idUsuario);
                }

                transaccion.Commit();
                creadas?.AddRange(nuevas);
                return idOtro.HasValue;
            }
        }
    }

    public static bool CancelarIntercambio(int idIntercambio, int idUsuario, List<NotificacionCreada>? creadas = null)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            connection.Open();
            using (SqlTransaction transaccion = connection.BeginTransaction())
            {
                string query = @"UPDATE i SET i.IdEstado = cancelado.IdEstadosIntercambios
                    OUTPUT CASE WHEN INSERTED.IdUsuarios1 = @pIdUsuario THEN INSERTED.IdUsuarios2 ELSE INSERTED.IdUsuarios1 END
                    FROM Intercambios i
                    INNER JOIN EstadosIntercambios actual ON actual.IdEstadosIntercambios = i.IdEstado
                    INNER JOIN EstadosIntercambios cancelado ON cancelado.Nombre = @pCancelado
                    WHERE i.IdIntercambios = @pId
                        AND ((actual.Nombre = @pPendiente AND i.IdUsuarios1 = @pIdUsuario)
                            OR (actual.Nombre = @pAceptado AND (i.IdUsuarios1 = @pIdUsuario OR i.IdUsuarios2 = @pIdUsuario)))";
                int? idOtro = connection.QueryFirstOrDefault<int?>(query, new
                {
                    pId = idIntercambio,
                    pIdUsuario = idUsuario,
                    pCancelado = EstadosIntercambios.Cancelado,
                    pPendiente = EstadosIntercambios.Pendiente,
                    pAceptado = EstadosIntercambios.Aceptado
                }, transaccion);

                List<NotificacionCreada> nuevas = new List<NotificacionCreada>();
                if (idOtro.HasValue)
                {
                    CrearNotificacion(connection, transaccion, nuevas, idOtro.Value, idIntercambio, TipoNotificaciones.IntercambioCancelado);
                }

                transaccion.Commit();
                creadas?.AddRange(nuevas);
                return idOtro.HasValue;
            }
        }
    }

    private const string CondicionPendientesDeArticulos = @"o.IdIntercambios <> @pId
        AND EXISTS (SELECT 1 FROM ArticulosIntercambios acep
            INNER JOIN ArticulosIntercambios otro ON otro.IdArticulo = acep.IdArticulo
            WHERE acep.IdIntercambio = @pId AND otro.IdIntercambio = o.IdIntercambios)";

    public static int ContarPendientesDeArticulos(int idIntercambio)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = @"SELECT COUNT(*) FROM Intercambios o
                INNER JOIN EstadosIntercambios e ON e.IdEstadosIntercambios = o.IdEstado
                WHERE e.Nombre = @pPendiente AND " + CondicionPendientesDeArticulos;
            return connection.ExecuteScalar<int>(query, new { pId = idIntercambio, pPendiente = EstadosIntercambios.Pendiente });
        }
    }

    private static void RechazarPendientesDeArticulos(SqlConnection connection, SqlTransaction transaccion,
        List<NotificacionCreada> nuevas, int idIntercambio, int idUsuario)
    {
        string query = @"UPDATE o SET o.IdEstado = rechazado.IdEstadosIntercambios
            OUTPUT INSERTED.IdIntercambios, INSERTED.IdUsuarios1
            FROM Intercambios o
            INNER JOIN EstadosIntercambios e ON e.IdEstadosIntercambios = o.IdEstado
            INNER JOIN EstadosIntercambios rechazado ON rechazado.Nombre = @pRechazado
            WHERE e.Nombre = @pPendiente AND " + CondicionPendientesDeArticulos;
        var rechazadas = connection.Query<(int IdIntercambios, int IdUsuarios1)>(query, new
        {
            pId = idIntercambio,
            pPendiente = EstadosIntercambios.Pendiente,
            pRechazado = EstadosIntercambios.Rechazado
        }, transaccion).ToList();

        foreach (var r in rechazadas.Where(r => r.IdUsuarios1 != idUsuario))
        {
            CrearNotificacion(connection, transaccion, nuevas, r.IdUsuarios1, r.IdIntercambios, TipoNotificaciones.PropuestaRechazada);
        }
    }

    // ---------- Cambios de un intercambio ----------

    private static readonly string[] EstadosVigentes = { EstadosIntercambios.Pendiente, EstadosIntercambios.Aceptado };

    private const string SinCambioPendiente = @"NOT EXISTS (SELECT 1 FROM CambiosIntercambios cx
        INNER JOIN EstadosIntercambios ex ON ex.IdEstadosIntercambios = cx.IdEstado
        WHERE cx.IdIntercambio = @pId AND cx.IdArticulo = a.IdArticulos AND ex.Nombre = @pPendiente)";

    private const string EnElIntercambio = "EXISTS (SELECT 1 FROM ArticulosIntercambios ae WHERE ae.IdIntercambio = @pId AND ae.IdArticulo = a.IdArticulos)";

    private static string ConfirmadosDe(string dueno) => $@"(SELECT COUNT(*) FROM ArticulosIntercambios ac
        INNER JOIN Articulos xa ON xa.IdArticulos = ac.IdArticulo
        WHERE ac.IdIntercambio = @pId AND xa.IdUsuarios = {dueno})";

    private static string PendientesDe(string dueno, string tipo) => $@"(SELECT COUNT(*) FROM CambiosIntercambios cp
        INNER JOIN Articulos xp ON xp.IdArticulos = cp.IdArticulo
        INNER JOIN TipoCambios tp ON tp.Id = cp.IdTipoCambio
        INNER JOIN EstadosIntercambios ep ON ep.IdEstadosIntercambios = cp.IdEstado
        WHERE cp.IdIntercambio = @pId AND xp.IdUsuarios = {dueno} AND tp.Nombre = {tipo} AND ep.Nombre = @pPendiente)";

    private const string InsertarCambio = @"INSERT INTO CambiosIntercambios (IdIntercambio, IdArticulo, IdUsuario, IdTipoCambio, IdEstado, Fecha)
        OUTPUT INSERTED.Id, INSERTED.IdArticulo
        SELECT @pId, a.IdArticulos, @pIdUsuario,
            (SELECT t.Id FROM TipoCambios t WHERE t.Nombre = @pTipo),
            (SELECT e.IdEstadosIntercambios FROM EstadosIntercambios e WHERE e.Nombre = @pEstadoCambio),
            @pAhora
        FROM Articulos a";

    private static (int IdOtro, string Estado)? GetIntercambioVigente(SqlConnection connection, SqlTransaction transaccion, int idIntercambio, int idUsuario)
    {
        string query = @"SELECT CASE WHEN i.IdUsuarios1 = @pIdUsuario THEN i.IdUsuarios2 ELSE i.IdUsuarios1 END AS IdOtro, e.Nombre AS Estado
            FROM Intercambios i WITH (UPDLOCK, HOLDLOCK)
            INNER JOIN EstadosIntercambios e ON e.IdEstadosIntercambios = i.IdEstado
            WHERE i.IdIntercambios = @pId AND e.Nombre IN @pVigentes AND (i.IdUsuarios1 = @pIdUsuario OR i.IdUsuarios2 = @pIdUsuario)";
        var filas = connection.Query<(int IdOtro, string Estado)>(query,
            new { pId = idIntercambio, pIdUsuario = idUsuario, pVigentes = EstadosVigentes }, transaccion).ToList();
        return filas.Count == 0 ? null : filas[0];
    }

    public static List<CambioIntercambioViewModel> GetCambiosIntercambio(int idIntercambio, int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = @"SELECT c.Id, c.IdArticulo, a.Nombre AS ArticuloNombre,
                    (SELECT TOP 1 im.Ruta FROM Imagenes im WHERE im.IdArticulos = a.IdArticulos ORDER BY im.IdImagenes) AS ArticuloImagen,
                    ea.Nombre AS ArticuloEstado, a.IdUsuarios AS IdDuenoArticulo, c.IdUsuario, u.Nombre AS UsuarioNombre,
                    tc.Nombre AS Tipo, ec.Nombre AS Estado, c.Fecha, c.FechaRespuesta,
                    CAST(CASE WHEN ei.Nombre IN @pVigentes THEN 1 ELSE 0 END AS bit) AS Vigente
                FROM CambiosIntercambios c
                INNER JOIN Intercambios i ON i.IdIntercambios = c.IdIntercambio
                INNER JOIN EstadosIntercambios ei ON ei.IdEstadosIntercambios = i.IdEstado
                INNER JOIN Articulos a ON a.IdArticulos = c.IdArticulo
                INNER JOIN EstadosArticulos ea ON ea.IdEstadosArticulos = a.IdEstado
                INNER JOIN Usuarios u ON u.IdUsuarios = c.IdUsuario
                INNER JOIN TipoCambios tc ON tc.Id = c.IdTipoCambio
                INNER JOIN EstadosIntercambios ec ON ec.IdEstadosIntercambios = c.IdEstado
                WHERE c.IdIntercambio = @pId AND (i.IdUsuarios1 = @pIdUsuario OR i.IdUsuarios2 = @pIdUsuario)
                ORDER BY c.Fecha DESC, c.Id DESC";
            return connection.Query<CambioIntercambioViewModel>(query,
                new { pId = idIntercambio, pIdUsuario = idUsuario, pVigentes = EstadosVigentes }).ToList();
        }
    }

    public static int GetUltimoCambio(int idIntercambio)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            return connection.ExecuteScalar<int>("SELECT ISNULL(MAX(Id), 0) FROM CambiosIntercambios WHERE IdIntercambio = @pId",
                new { pId = idIntercambio });
        }
    }

    public static int AgregarArticulos(int idIntercambio, int idUsuario, IReadOnlyCollection<int> idsArticulos,
        List<NotificacionCreada>? creadas = null)
    {
        List<int> ids = idsArticulos.Distinct().ToList();
        if (ids.Count == 0)
        {
            return 0;
        }

        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            connection.Open();
            using (SqlTransaction transaccion = connection.BeginTransaction())
            {
                var intercambio = GetIntercambioVigente(connection, transaccion, idIntercambio, idUsuario);
                if (intercambio == null)
                {
                    return 0;
                }

                string queryArticulos = $@"INSERT INTO ArticulosIntercambios (IdArticulo, IdIntercambio)
                    OUTPUT INSERTED.IdArticulo
                    SELECT a.IdArticulos, @pId FROM Articulos a
                    WHERE a.IdArticulos IN @pIds AND a.IdUsuarios = @pIdUsuario
                        AND NOT {EnElIntercambio} AND {SinCambioPendiente} AND {ArticuloDisponible}
                        AND {ConfirmadosDe("@pIdUsuario")} + {PendientesDe("@pIdUsuario", "@pPedir")} + @pCantidad <= @pMax";
                List<int> agregados = connection.Query<int>(queryArticulos, new
                {
                    pId = idIntercambio,
                    pIdUsuario = idUsuario,
                    pIds = ids,
                    pCantidad = ids.Count,
                    pMax = Intercambios.MaxArticulosOfrecidos,
                    pPedir = TipoCambios.Pedir,
                    pPendiente = EstadosIntercambios.Pendiente,
                    pComprometidos = EstadosComprometidos
                }, transaccion).ToList();
                if (agregados.Count != ids.Count)
                {
                    return 0;
                }

                var cambios = connection.Query<(int Id, int IdArticulo)>(InsertarCambio + " WHERE a.IdArticulos IN @pAgregados ORDER BY a.IdArticulos", new
                {
                    pId = idIntercambio,
                    pIdUsuario = idUsuario,
                    pTipo = TipoCambios.Agregar,
                    pEstadoCambio = EstadosIntercambios.Aceptado,
                    pAhora = DateTime.Now,
                    pAgregados = agregados
                }, transaccion).ToList();

                List<NotificacionCreada> nuevas = new List<NotificacionCreada>();
                CrearNotificacion(connection, transaccion, nuevas, intercambio.Value.IdOtro, idIntercambio,
                    TipoNotificaciones.ArticuloAgregado, idCambio: cambios.Min(c => c.Id));
                if (intercambio.Value.Estado == EstadosIntercambios.Aceptado)
                {
                    RechazarPendientesDeArticulos(connection, transaccion, nuevas, idIntercambio, idUsuario);
                }

                transaccion.Commit();
                creadas?.AddRange(nuevas);
                return agregados.Count;
            }
        }
    }

    public static bool PedirArticulo(int idIntercambio, int idUsuario, int idArticulo, List<NotificacionCreada>? creadas = null)
    {
        return CrearPedido(idIntercambio, idUsuario, idArticulo, TipoCambios.Pedir, creadas);
    }

    public static bool PedirSacarArticulo(int idIntercambio, int idUsuario, int idArticulo, List<NotificacionCreada>? creadas = null)
    {
        return CrearPedido(idIntercambio, idUsuario, idArticulo, TipoCambios.Sacar, creadas);
    }

    private static bool CrearPedido(int idIntercambio, int idUsuario, int idArticulo, string tipo, List<NotificacionCreada>? creadas)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            connection.Open();
            using (SqlTransaction transaccion = connection.BeginTransaction())
            {
                var intercambio = GetIntercambioVigente(connection, transaccion, idIntercambio, idUsuario);
                if (intercambio == null)
                {
                    return false;
                }

                string condicion = tipo == TipoCambios.Pedir
                    ? $@"a.IdUsuarios = @pIdOtro AND NOT {EnElIntercambio} AND {ArticuloDisponible}
                        AND {ConfirmadosDe("@pIdOtro")} + {PendientesDe("@pIdOtro", "@pPedir")} < @pMax"
                    : $@"a.IdUsuarios = @pIdUsuario AND {EnElIntercambio}
                        AND {ConfirmadosDe("@pIdUsuario")} - {PendientesDe("@pIdUsuario", "@pSacar")} >= 2";
                string query = $"{InsertarCambio} WHERE a.IdArticulos = @pIdArticulo AND {SinCambioPendiente} AND {condicion}";
                var cambios = connection.Query<(int Id, int IdArticulo)>(query, new
                {
                    pId = idIntercambio,
                    pIdUsuario = idUsuario,
                    pIdOtro = intercambio.Value.IdOtro,
                    pIdArticulo = idArticulo,
                    pTipo = tipo,
                    pEstadoCambio = EstadosIntercambios.Pendiente,
                    pAhora = DateTime.Now,
                    pMax = Intercambios.MaxArticulosOfrecidos,
                    pPedir = TipoCambios.Pedir,
                    pSacar = TipoCambios.Sacar,
                    pPendiente = EstadosIntercambios.Pendiente,
                    pComprometidos = EstadosComprometidos
                }, transaccion).ToList();
                if (cambios.Count == 0)
                {
                    return false;
                }

                List<NotificacionCreada> nuevas = new List<NotificacionCreada>();
                CrearNotificacion(connection, transaccion, nuevas, intercambio.Value.IdOtro, idIntercambio,
                    tipo == TipoCambios.Pedir ? TipoNotificaciones.PedidoArticulo : TipoNotificaciones.PedidoSacar,
                    idCambio: cambios[0].Id);

                transaccion.Commit();
                creadas?.AddRange(nuevas);
                return true;
            }
        }
    }

    public static bool ResponderCambio(int idCambio, int idUsuario, bool aceptar, List<NotificacionCreada>? creadas = null)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            connection.Open();
            using (SqlTransaction transaccion = connection.BeginTransaction())
            {
                List<int> delCambio = connection.Query<int>("SELECT IdIntercambio FROM CambiosIntercambios WHERE Id = @pIdCambio",
                    new { pIdCambio = idCambio }, transaccion).ToList();
                if (delCambio.Count == 0)
                {
                    return false;
                }
                connection.Execute("SELECT 1 FROM Intercambios WITH (UPDLOCK, HOLDLOCK) WHERE IdIntercambios = @pId",
                    new { pId = delCambio[0] }, transaccion);

                string query = @"UPDATE c SET c.IdEstado = (SELECT e.IdEstadosIntercambios FROM EstadosIntercambios e WHERE e.Nombre = @pNuevo),
                        c.FechaRespuesta = GETDATE()
                    OUTPUT INSERTED.IdIntercambio, INSERTED.IdArticulo, INSERTED.IdUsuario, tc.Nombre, a.IdUsuarios, ei.Nombre
                    FROM CambiosIntercambios c
                    INNER JOIN EstadosIntercambios ec ON ec.IdEstadosIntercambios = c.IdEstado
                    INNER JOIN TipoCambios tc ON tc.Id = c.IdTipoCambio
                    INNER JOIN Articulos a ON a.IdArticulos = c.IdArticulo
                    INNER JOIN Intercambios i ON i.IdIntercambios = c.IdIntercambio
                    INNER JOIN EstadosIntercambios ei ON ei.IdEstadosIntercambios = i.IdEstado
                    WHERE c.Id = @pIdCambio AND ec.Nombre = @pPendiente AND ei.Nombre IN @pVigentes
                        AND c.IdUsuario <> @pIdUsuario AND (i.IdUsuarios1 = @pIdUsuario OR i.IdUsuarios2 = @pIdUsuario)";
                var filas = connection.Query<(int IdIntercambio, int IdArticulo, int IdAutor, string Tipo, int IdDueno, string EstadoIntercambio)>(query, new
                {
                    pIdCambio = idCambio,
                    pIdUsuario = idUsuario,
                    pNuevo = aceptar ? EstadosIntercambios.Aceptado : EstadosIntercambios.Rechazado,
                    pPendiente = EstadosIntercambios.Pendiente,
                    pVigentes = EstadosVigentes
                }, transaccion).ToList();
                if (filas.Count == 0)
                {
                    return false;
                }

                var c = filas[0];
                List<NotificacionCreada> nuevas = new List<NotificacionCreada>();
                if (aceptar)
                {
                    var parametros = new
                    {
                        pId = c.IdIntercambio,
                        pIdArticulo = c.IdArticulo,
                        pIdDueno = c.IdDueno,
                        pMax = Intercambios.MaxArticulosOfrecidos,
                        pComprometidos = EstadosComprometidos
                    };
                    string queryEfecto = c.Tipo == TipoCambios.Pedir
                        ? $@"INSERT INTO ArticulosIntercambios (IdArticulo, IdIntercambio)
                            SELECT a.IdArticulos, @pId FROM Articulos a
                            WHERE a.IdArticulos = @pIdArticulo AND a.IdUsuarios = @pIdDueno
                                AND NOT {EnElIntercambio} AND {ArticuloDisponible} AND {ConfirmadosDe("@pIdDueno")} < @pMax"
                        : $@"DELETE ai FROM ArticulosIntercambios ai
                            WHERE ai.IdIntercambio = @pId AND ai.IdArticulo = @pIdArticulo AND {ConfirmadosDe("@pIdDueno")} >= 2";
                    if (connection.Execute(queryEfecto, parametros, transaccion) == 0)
                    {
                        transaccion.Rollback();
                        return false;
                    }
                    if (c.Tipo == TipoCambios.Pedir && c.EstadoIntercambio == EstadosIntercambios.Aceptado)
                    {
                        RechazarPendientesDeArticulos(connection, transaccion, nuevas, c.IdIntercambio, idUsuario);
                    }
                }

                CrearNotificacion(connection, transaccion, nuevas, c.IdAutor, c.IdIntercambio,
                    aceptar ? TipoNotificaciones.CambioAceptado : TipoNotificaciones.CambioRechazado, idCambio: idCambio);

                transaccion.Commit();
                creadas?.AddRange(nuevas);
                return true;
            }
        }
    }

    public static bool CancelarCambio(int idCambio, int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = @"UPDATE c SET c.IdEstado = (SELECT e.IdEstadosIntercambios FROM EstadosIntercambios e WHERE e.Nombre = @pCancelado),
                    c.FechaRespuesta = GETDATE()
                FROM CambiosIntercambios c
                INNER JOIN EstadosIntercambios ec ON ec.IdEstadosIntercambios = c.IdEstado
                INNER JOIN Intercambios i ON i.IdIntercambios = c.IdIntercambio
                INNER JOIN EstadosIntercambios ei ON ei.IdEstadosIntercambios = i.IdEstado
                WHERE c.Id = @pIdCambio AND c.IdUsuario = @pIdUsuario AND ec.Nombre = @pPendiente AND ei.Nombre IN @pVigentes";
            return connection.Execute(query, new
            {
                pIdCambio = idCambio,
                pIdUsuario = idUsuario,
                pCancelado = EstadosIntercambios.Cancelado,
                pPendiente = EstadosIntercambios.Pendiente,
                pVigentes = EstadosVigentes
            }) > 0;
        }
    }

    private const string ArticulosDelCambio = @"OUTER APPLY (SELECT STRING_AGG(ag.Nombre, ', ') WITHIN GROUP (ORDER BY cg.Id) AS Nombres
            FROM CambiosIntercambios cg
            INNER JOIN Articulos ag ON ag.IdArticulos = cg.IdArticulo
            WHERE cg.Id = cn.Id OR (tcn.Nombre = @pAgregar AND cg.IdIntercambio = cn.IdIntercambio AND cg.IdUsuario = cn.IdUsuario
                AND cg.IdTipoCambio = cn.IdTipoCambio AND cg.Fecha = cn.Fecha)) artcambio";

    public static List<EstadosIntercambios> GetEstadosIntercambios()
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            return connection.Query<EstadosIntercambios>("GetEstadosIntercambios", commandType: CommandType.StoredProcedure).ToList();
        }
    }

    // ---------- Notificaciones ----------

    private static void CrearNotificacion(SqlConnection connection, SqlTransaction transaccion, List<NotificacionCreada> nuevas,
        int idUsuario, int idIntercambio, string tipo, bool siNoHayOtraSinLeer = false, int? idCambio = null)
    {
        string query = @"INSERT INTO Notificaciones (IdUsuario, IdIntercambio, IdTipoNotificacion, Leida, Fecha, IdCambio)
            SELECT @pIdUsuario, @pIdIntercambio, t.Id, 0, GETDATE(), @pIdCambio
            FROM TipoNotificaciones t WHERE t.Nombre = @pTipo
                AND (@pSiNoHayOtra = 0 OR NOT EXISTS (SELECT 1 FROM Notificaciones n
                    WHERE n.IdUsuario = @pIdUsuario AND n.IdIntercambio = @pIdIntercambio AND n.IdTipoNotificacion = t.Id AND n.Leida = 0))";
        int filas = connection.Execute(query, new
        {
            pIdUsuario = idUsuario,
            pIdIntercambio = idIntercambio,
            pTipo = tipo,
            pSiNoHayOtra = siNoHayOtraSinLeer,
            pIdCambio = idCambio
        }, transaccion);

        if (filas > 0)
        {
            nuevas.Add(new NotificacionCreada(idUsuario, idIntercambio, tipo, idCambio));
        }
    }


}
