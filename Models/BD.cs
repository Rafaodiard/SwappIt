using Dapper;
using Microsoft.Data.SqlClient;
using System.Data;
using Swappit.Models.ViewModels;

namespace Swappit.Models;

public static class BD
{
    private static string _connectionString = @"Server=localhost; DataBase=Base_De_Datos_Swappit; Integrated Security=True; TrustServerCertificate=True;";
    //@"Server=.\SQLEXPRESS;Database=Base_De_Datos_Swappit;Integrated Security=True;TrustServerCertificate=True;";

    public static Usuarios? GetUsuarioByMail(string mail)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            return connection.QueryFirstOrDefault<Usuarios>("GetUsuarioByMail",
                new { Mail = mail },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static void ActualizarContrasena(int idUsuario, string contrasenaHash)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            connection.Execute("ActualizarContrasena",
                new { idUsuario, contrasenaHash },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static bool UsuarioExiste(string mail)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            return connection.ExecuteScalar<int>("UsuarioExiste",
                new { mail },
                commandType: CommandType.StoredProcedure) > 0;
        }
    }

    public static Usuarios? GetUsuarioById(int id)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            return connection.QueryFirstOrDefault<Usuarios>("GetUsuarioById",
                new { id },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static Provincias? GetProvinciaById(int id)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            return connection.QueryFirstOrDefault<Provincias>("GetProvinciaById",
                new { id },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static List<Provincias> GetProvincias()
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            return connection.Query<Provincias>("GetProvincias", commandType: CommandType.StoredProcedure).ToList();
        }
    }

    public static void Register(Usuarios u)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = @"INSERT INTO Usuarios (Nombre, Apellido, Usuario, Mail, Telefono, Contraseña, Barrio, [Fecha nacimiento], Edad, IdProvincias)
                VALUES (@Nombre, @Apellido, @Usuario, @Mail, @Telefono, @Contraseña, @Barrio, @FechaNacimiento, @Edad, @IdProvincias)";
            connection.Execute(query, u);
        }
    }

    public static void UpdateUsuario(Usuarios u)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            connection.Execute("UpdateUsuario",
                new
                {
                    idUsuario = u.IdUsuarios,
                    nombre = u.Nombre,
                    apellido = u.Apellido,
                    usuario = u.Usuario,
                    mail = u.Mail,
                    telefono = u.Telefono,
                    contraseña = u.Contraseña,
                    barrio = u.Barrio,
                    fechaNacimiento = u.FechaNacimiento,
                    edad = u.Edad,
                    idProvincia = u.IdProvincias,
                    descripcion = u.Descripcion
                },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static string? GetFotoUsuario(int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            return connection.QueryFirstOrDefault<string>("GetFotoUsuario",
                new { idUsuario },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static void GuardarFotoUsuario(int idUsuario, string ruta)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            connection.Execute("GuardarFotoUsuario",
                new { idUsuario, ruta },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static void BorrarFotoUsuario(int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            connection.Execute("BorrarFotoUsuario",
                new { idUsuario },
                commandType: CommandType.StoredProcedure);
        }
    }

    private const string ArticuloDisponible = @"NOT EXISTS (SELECT 1 FROM Intercambios ic
        INNER JOIN EstadosIntercambios eic ON eic.IdEstadosIntercambios = ic.IdEstado
        WHERE eic.Nombre IN @pComprometidos AND (ic.IdArticulos1 = a.IdArticulos OR ic.IdArticulos2 = a.IdArticulos))";

    private static readonly string[] EstadosComprometidos = { EstadosIntercambios.Aceptado, EstadosIntercambios.Realizado };

    public static List<ArticuloCardViewModel> GetArticulosCatalogo(string? busqueda = null, int? cantidad = null,
        IReadOnlyCollection<int>? categorias = null, IReadOnlyCollection<int>? estados = null, int? idUsuario = null,
        int? excluirUsuario = null)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            var condiciones = new List<string> { "(@pBusqueda IS NULL OR a.Nombre LIKE '%' + @pBusqueda + '%')", ArticuloDisponible };
            if (categorias is { Count: > 0 }) condiciones.Add("a.IdCategorias IN @pCategorias");
            if (estados is { Count: > 0 }) condiciones.Add("a.IdEstado IN @pEstados");
            if (idUsuario.HasValue) condiciones.Add("a.IdUsuarios = @pIdUsuario");
            if (excluirUsuario.HasValue) condiciones.Add("a.IdUsuarios <> @pExcluirUsuario");

            string top = cantidad.HasValue ? "TOP (@pCantidad) " : "";
            string query = $@"SELECT {top}a.IdArticulos, a.Nombre, e.Nombre AS Estado, COALESCE(NULLIF(a.Ubicacion, ''), u.Barrio) AS Barrio,
                    (SELECT TOP 1 i.Ruta FROM Imagenes i WHERE i.IdArticulos = a.IdArticulos ORDER BY i.IdImagenes) AS Imagen,
                    a.IdUsuarios, a.IdCategorias, a.IdCategoriaACambio
                FROM Articulos a
                INNER JOIN Usuarios u ON u.IdUsuarios = a.IdUsuarios
                INNER JOIN EstadosArticulos e ON e.IdEstadosArticulos = a.IdEstado
                WHERE {string.Join(" AND ", condiciones)}
                ORDER BY a.IdArticulos DESC";

            return connection.Query<ArticuloCardViewModel>(query, new
            {
                pBusqueda = PatronBusqueda(busqueda),
                pCantidad = cantidad,
                pCategorias = categorias,
                pEstados = estados,
                pIdUsuario = idUsuario,
                pExcluirUsuario = excluirUsuario,
                pComprometidos = EstadosComprometidos
            }).ToList();
        }
    }

    public static Articulos? GetArticuloById(int id)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            return connection.QueryFirstOrDefault<Articulos>("GetArticuloById",
                new { id },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static int PublicarArticulo(Articulos a, List<string> rutasFotos)
    {
        AsegurarFechaPublicacion();

        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            connection.Open();
            using (SqlTransaction transaccion = connection.BeginTransaction())
            {
                string query = @"INSERT INTO Articulos (Nombre, Descripcion, IdEstado, IdUsuarios, IdCategorias, Ubicacion, IdCategoriaACambio, FechaPublicacion)
                    OUTPUT INSERTED.IdArticulos
                    VALUES (@Nombre, @Descripcion, @IdEstado, @IdUsuarios, @IdCategorias, @Ubicacion, @IdCategoriaACambio, @FechaPublicacion)";
                int idArticulo = connection.QuerySingle<int>(query, a, transaccion);

                string queryFoto = "INSERT INTO Imagenes (Ruta, IdArticulos) VALUES (@pRuta, @pIdArticulo)";
                foreach (string ruta in rutasFotos)
                {
                    connection.Execute(queryFoto, new { pRuta = ruta, pIdArticulo = idArticulo }, transaccion);
                }

                transaccion.Commit();
                return idArticulo;
            }
        }
    }

    public static int ContarArticulosActivos(int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = @"SELECT COUNT(*)
                FROM Articulos a
                WHERE a.IdUsuarios = @pIdUsuario
                    AND NOT EXISTS (
                        SELECT 1 FROM Intercambios i
                        INNER JOIN EstadosIntercambios ei ON ei.IdEstadosIntercambios = i.IdEstado
                        WHERE ei.Nombre = @pRealizado
                            AND (i.IdArticulos1 = a.IdArticulos OR i.IdArticulos2 = a.IdArticulos)
                    )";
            return connection.ExecuteScalar<int>(query, new
            {
                pIdUsuario = idUsuario,
                pRealizado = EstadosIntercambios.Realizado
            });
        }
    }

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

    private static void AsegurarFechaPublicacion()
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            connection.Open();
            string query = @"IF COL_LENGTH('dbo.Articulos', 'FechaPublicacion') IS NULL
                BEGIN
                    EXEC('ALTER TABLE dbo.Articulos ADD FechaPublicacion date NULL');
                    EXEC('UPDATE dbo.Articulos SET FechaPublicacion = CAST(GETDATE() AS date) WHERE FechaPublicacion IS NULL');
                    EXEC('ALTER TABLE dbo.Articulos ALTER COLUMN FechaPublicacion date NOT NULL');
                END";
            connection.Execute(query);
        }
    }

    public static List<string> GetImagenesArticulo(int idArticulo)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            return connection.Query<string>("GetImagenesArticulo",
                new { idArticulo },
                commandType: CommandType.StoredProcedure).ToList();
        }
    }

    public static Categorias? GetCategoriaById(int id)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            return connection.QueryFirstOrDefault<Categorias>("GetCategoriaById",
                new { id },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static List<Categorias> GetCategorias()
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            return connection.Query<Categorias>("GetCategorias", commandType: CommandType.StoredProcedure).ToList();
        }
    }

    public static List<EstadosArticulos> GetEstadosArticulos()
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            return connection.Query<EstadosArticulos>("GetEstadosArticulos", commandType: CommandType.StoredProcedure).ToList();
        }
    }

    public static EstadosArticulos? GetEstadoArticuloById(int id)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            return connection.QueryFirstOrDefault<EstadosArticulos>("GetEstadoArticuloById",
                new { id },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static List<OpcionFiltroViewModel> GetFiltroCategorias(string? busqueda = null, int? excluirUsuario = null)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            return connection.Query<OpcionFiltroViewModel>("GetFiltroCategorias",
                new
                {
                    busqueda = PatronBusqueda(busqueda),
                    excluirUsuario,
                    comprometidos = string.Join(",", EstadosComprometidos)
                },
                commandType: CommandType.StoredProcedure).ToList();
        }
    }

    public static List<OpcionFiltroViewModel> GetFiltroEstados(string? busqueda = null, int? excluirUsuario = null)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            return connection.Query<OpcionFiltroViewModel>("GetFiltroEstados",
                new
                {
                    busqueda = PatronBusqueda(busqueda),
                    excluirUsuario,
                    comprometidos = string.Join(",", EstadosComprometidos)
                },
                commandType: CommandType.StoredProcedure).ToList();
        }
    }

    // ---------- Intercambios ----------

    private const string ConsultaIntercambios = @"i.IdIntercambios, i.Fecha, e.Nombre AS Estado,
            CAST(CASE WHEN i.IdUsuarios2 = @pIdUsuario THEN 1 ELSE 0 END AS bit) AS EsRecibido,
            am.IdArticulos AS MiArticuloId, am.Nombre AS MiArticuloNombre, eam.Nombre AS MiArticuloEstado,
            (SELECT TOP 1 im.Ruta FROM Imagenes im WHERE im.IdArticulos = am.IdArticulos ORDER BY im.IdImagenes) AS MiArticuloImagen,
            asu.IdArticulos AS SuArticuloId, asu.Nombre AS SuArticuloNombre, easu.Nombre AS SuArticuloEstado,
            (SELECT TOP 1 isu.Ruta FROM Imagenes isu WHERE isu.IdArticulos = asu.IdArticulos ORDER BY isu.IdImagenes) AS SuArticuloImagen,
            u.IdUsuarios AS OtroIdUsuario, u.Nombre AS OtroNombre, u.Apellido AS OtroApellido, u.Usuario AS OtroUsuario,
            u.Barrio AS OtroBarrio, p.Nombre AS OtroProvincia
        FROM Intercambios i
        INNER JOIN EstadosIntercambios e ON e.IdEstadosIntercambios = i.IdEstado
        CROSS APPLY (SELECT
            CASE WHEN i.IdUsuarios1 = @pIdUsuario THEN i.IdArticulos1 ELSE i.IdArticulos2 END AS IdMiArticulo,
            CASE WHEN i.IdUsuarios1 = @pIdUsuario THEN i.IdArticulos2 ELSE i.IdArticulos1 END AS IdSuArticulo,
            CASE WHEN i.IdUsuarios1 = @pIdUsuario THEN i.IdUsuarios2 ELSE i.IdUsuarios1 END AS IdOtro) lado
        INNER JOIN Articulos am ON am.IdArticulos = lado.IdMiArticulo
        INNER JOIN EstadosArticulos eam ON eam.IdEstadosArticulos = am.IdEstado
        INNER JOIN Articulos asu ON asu.IdArticulos = lado.IdSuArticulo
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
                WHERE i.IdUsuarios1 = @pIdUsuario AND i.IdArticulos2 = @pIdArticulo AND e.Nombre IN @pEnCurso
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

    public static int? ProponerIntercambio(int idUsuario, int idArticuloOfrecido, int idDueno, int idArticuloPedido,
        List<NotificacionCreada>? creadas = null)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            connection.Open();
            using (SqlTransaction transaccion = connection.BeginTransaction())
            {
                string query = @"INSERT INTO Intercambios (Fecha, IdEstado, IdUsuarios1, IdUsuarios2, IdArticulos1, IdArticulos2)
                    OUTPUT INSERTED.IdIntercambios
                    SELECT CAST(GETDATE() AS date), e.IdEstadosIntercambios, @pIdUsuario, @pIdDueno, @pIdOfrecido, @pIdPedido
                    FROM EstadosIntercambios e
                    WHERE e.Nombre = @pPendiente
                        AND NOT EXISTS (SELECT 1 FROM Intercambios i
                            INNER JOIN EstadosIntercambios ei ON ei.IdEstadosIntercambios = i.IdEstado
                            WHERE i.IdUsuarios1 = @pIdUsuario AND i.IdArticulos2 = @pIdPedido AND ei.Nombre IN @pEnCurso)
                        AND NOT EXISTS (SELECT 1 FROM Intercambios ic
                            INNER JOIN EstadosIntercambios eic ON eic.IdEstadosIntercambios = ic.IdEstado
                            WHERE eic.Nombre IN @pComprometidos
                                AND (ic.IdArticulos1 IN (@pIdOfrecido, @pIdPedido) OR ic.IdArticulos2 IN (@pIdOfrecido, @pIdPedido)))";
                int? idIntercambio = connection.QueryFirstOrDefault<int>(query, new
                {
                    pIdUsuario = idUsuario,
                    pIdDueno = idDueno,
                    pIdOfrecido = idArticuloOfrecido,
                    pIdPedido = idArticuloPedido,
                    pPendiente = EstadosIntercambios.Pendiente,
                    pEnCurso = new[] { EstadosIntercambios.Pendiente, EstadosIntercambios.Aceptado },
                    pComprometidos = EstadosComprometidos
                }, transaccion);

                List<NotificacionCreada> nuevas = new List<NotificacionCreada>();
                if (idIntercambio.HasValue)
                {
                    CrearNotificacion(connection, transaccion, nuevas, idDueno, idIntercambio.Value, TipoNotificaciones.PropuestaRecibida);
                }

                transaccion.Commit();
                creadas?.AddRange(nuevas);
                return idIntercambio;
            }
        }
    }

    public static bool CambiarEstadoIntercambio(int idIntercambio, int idUsuario, string estadoActual, string estadoNuevo,
        bool soloQuienRecibe, string? tipoNotificacion = null, List<NotificacionCreada>? creadas = null)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            connection.Open();
            using (SqlTransaction transaccion = connection.BeginTransaction())
            {
                string query = @"UPDATE i SET i.IdEstado = nuevo.IdEstadosIntercambios
                    OUTPUT CASE WHEN INSERTED.IdUsuarios1 = @pIdUsuario THEN INSERTED.IdUsuarios2 ELSE INSERTED.IdUsuarios1 END
                    FROM Intercambios i
                    INNER JOIN EstadosIntercambios actual ON actual.IdEstadosIntercambios = i.IdEstado
                    INNER JOIN EstadosIntercambios nuevo ON nuevo.Nombre = @pNuevo
                    WHERE i.IdIntercambios = @pId AND actual.Nombre = @pActual
                        AND (i.IdUsuarios2 = @pIdUsuario OR (@pSoloQuienRecibe = 0 AND i.IdUsuarios1 = @pIdUsuario))
                        AND (@pNuevo <> @pAceptado OR NOT EXISTS (SELECT 1 FROM Intercambios ic
                            INNER JOIN EstadosIntercambios eic ON eic.IdEstadosIntercambios = ic.IdEstado
                            WHERE eic.Nombre IN @pComprometidos AND ic.IdIntercambios <> i.IdIntercambios
                                AND (ic.IdArticulos1 IN (i.IdArticulos1, i.IdArticulos2) OR ic.IdArticulos2 IN (i.IdArticulos1, i.IdArticulos2))))";
                int? idOtro = connection.QueryFirstOrDefault<int?>(query, new
                {
                    pId = idIntercambio,
                    pIdUsuario = idUsuario,
                    pActual = estadoActual,
                    pNuevo = estadoNuevo,
                    pSoloQuienRecibe = soloQuienRecibe,
                    pAceptado = EstadosIntercambios.Aceptado,
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
        AND EXISTS (SELECT 1 FROM Intercambios acep WHERE acep.IdIntercambios = @pId
            AND (o.IdArticulos1 IN (acep.IdArticulos1, acep.IdArticulos2) OR o.IdArticulos2 IN (acep.IdArticulos1, acep.IdArticulos2)))";

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

    public static List<EstadosIntercambios> GetEstadosIntercambios()
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            return connection.Query<EstadosIntercambios>("GetEstadosIntercambios", commandType: CommandType.StoredProcedure).ToList();
        }
    }

    // ---------- Notificaciones ----------

    private static void CrearNotificacion(SqlConnection connection, SqlTransaction transaccion, List<NotificacionCreada> nuevas,
        int idUsuario, int idIntercambio, string tipo, bool siNoHayOtraSinLeer = false)
    {
        string query = @"INSERT INTO Notificaciones (IdUsuario, IdIntercambio, IdTipoNotificacion, Leida, Fecha)
            SELECT @pIdUsuario, @pIdIntercambio, t.Id, 0, GETDATE()
            FROM TipoNotificaciones t WHERE t.Nombre = @pTipo
                AND (@pSiNoHayOtra = 0 OR NOT EXISTS (SELECT 1 FROM Notificaciones n
                    WHERE n.IdUsuario = @pIdUsuario AND n.IdIntercambio = @pIdIntercambio AND n.IdTipoNotificacion = t.Id AND n.Leida = 0))";
        int filas = connection.Execute(query, new
        {
            pIdUsuario = idUsuario,
            pIdIntercambio = idIntercambio,
            pTipo = tipo,
            pSiNoHayOtra = siNoHayOtraSinLeer
        }, transaccion);

        if (filas > 0)
        {
            nuevas.Add(new NotificacionCreada(idUsuario, idIntercambio, tipo));
        }
    }

    public static DatosMailNotificacion? GetDatosMailNotificacion(int idUsuario, int idIntercambio)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = @"SELECT d.Mail, d.Nombre, o.Nombre AS OtroNombre, am.Nombre AS MiArticulo, asu.Nombre AS SuArticulo
                FROM Intercambios i
                INNER JOIN Usuarios d ON d.IdUsuarios = @pIdUsuario
                INNER JOIN Usuarios o ON o.IdUsuarios = CASE WHEN i.IdUsuarios1 = @pIdUsuario THEN i.IdUsuarios2 ELSE i.IdUsuarios1 END
                INNER JOIN Articulos am ON am.IdArticulos = CASE WHEN i.IdUsuarios1 = @pIdUsuario THEN i.IdArticulos1 ELSE i.IdArticulos2 END
                INNER JOIN Articulos asu ON asu.IdArticulos = CASE WHEN i.IdUsuarios1 = @pIdUsuario THEN i.IdArticulos2 ELSE i.IdArticulos1 END
                WHERE i.IdIntercambios = @pIdIntercambio AND (i.IdUsuarios1 = @pIdUsuario OR i.IdUsuarios2 = @pIdUsuario)";
            return connection.QueryFirstOrDefault<DatosMailNotificacion>(query, new { pIdUsuario = idUsuario, pIdIntercambio = idIntercambio });
        }
    }

    public static List<NotificacionViewModel> GetNotificaciones(int idUsuario, int cantidad)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = @"SELECT TOP (@pCantidad) n.Id, t.Nombre AS Tipo, n.Leida, n.Fecha, n.IdIntercambio,
                    u.Nombre AS OtroNombre, a.Nombre AS ArticuloNombre
                FROM Notificaciones n
                INNER JOIN TipoNotificaciones t ON t.Id = n.IdTipoNotificacion
                INNER JOIN Intercambios i ON i.IdIntercambios = n.IdIntercambio
                INNER JOIN Usuarios u ON u.IdUsuarios = CASE WHEN i.IdUsuarios1 = n.IdUsuario THEN i.IdUsuarios2 ELSE i.IdUsuarios1 END
                INNER JOIN Articulos a ON a.IdArticulos = i.IdArticulos2
                WHERE n.IdUsuario = @pIdUsuario
                ORDER BY n.Fecha DESC, n.Id DESC";
            return connection.Query<NotificacionViewModel>(query, new { pIdUsuario = idUsuario, pCantidad = cantidad }).ToList();
        }
    }

    public static int GetCantidadNotificacionesNoLeidas(int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            return connection.ExecuteScalar<int>("GetCantidadNotificacionesNoLeidas",
                new { idUsuario },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static NotificacionViewModel? MarcarNotificacionLeida(int idNotificacion, int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = @"UPDATE n SET n.Leida = 1
                OUTPUT INSERTED.Id, INSERTED.IdIntercambio, t.Nombre AS Tipo
                FROM Notificaciones n
                INNER JOIN TipoNotificaciones t ON t.Id = n.IdTipoNotificacion
                WHERE n.Id = @pId AND n.IdUsuario = @pIdUsuario";
            return connection.QueryFirstOrDefault<NotificacionViewModel>(query, new { pId = idNotificacion, pIdUsuario = idUsuario });
        }
    }

    public static void MarcarNotificacionesLeidas(int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            connection.Execute("MarcarNotificacionesLeidas",
                new { idUsuario },
                commandType: CommandType.StoredProcedure);
        }
    }

    // ---------- Chat ----------

    private const string ParteDelIntercambio = @"EXISTS (SELECT 1 FROM Intercambios ip
        WHERE ip.IdIntercambios = @pIdIntercambio AND (ip.IdUsuarios1 = @pIdUsuario OR ip.IdUsuarios2 = @pIdUsuario))";

    public static List<ConversacionViewModel> GetResumenesChat(int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = @"SELECT i.IdIntercambios AS IdIntercambio, ult.Texto AS UltimoTexto, ult.FechaEnviado AS UltimaFecha,
                    CAST(CASE WHEN ult.IdUsuariosManda = @pIdUsuario THEN 1 ELSE 0 END AS bit) AS UltimoEsMio,
                    (SELECT COUNT(*) FROM Mensajes m
                        WHERE m.IdIntercambio = i.IdIntercambios AND m.IdUsuariosManda <> @pIdUsuario AND m.fueVisto = 0) AS NoLeidos
                FROM Intercambios i
                CROSS APPLY (SELECT TOP 1 m.Texto, m.FechaEnviado, m.IdUsuariosManda FROM Mensajes m
                    WHERE m.IdIntercambio = i.IdIntercambios ORDER BY m.IdMensajes DESC) ult
                WHERE i.IdUsuarios1 = @pIdUsuario OR i.IdUsuarios2 = @pIdUsuario";
            return connection.Query<ConversacionViewModel>(query, new { pIdUsuario = idUsuario }).ToList();
        }
    }

    public static List<Mensajes> GetMensajes(int idIntercambio, int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = $@"SELECT IdMensajes, Texto, fueVisto, FechaEnviado, FechaRecibido, IdUsuariosManda, IdIntercambio
                FROM Mensajes
                WHERE IdIntercambio = @pIdIntercambio AND {ParteDelIntercambio}
                ORDER BY IdMensajes";
            return connection.Query<Mensajes>(query, new { pIdIntercambio = idIntercambio, pIdUsuario = idUsuario }).ToList();
        }
    }

    public static bool EnviarMensaje(int idIntercambio, int idUsuario, string texto, List<NotificacionCreada>? creadas = null)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            connection.Open();
            using (SqlTransaction transaccion = connection.BeginTransaction())
            {
                string query = @"DECLARE @idOtro int;
                    SELECT @idOtro = CASE WHEN i.IdUsuarios1 = @pIdUsuario THEN i.IdUsuarios2 ELSE i.IdUsuarios1 END
                    FROM Intercambios i
                    INNER JOIN EstadosIntercambios e ON e.IdEstadosIntercambios = i.IdEstado
                    WHERE i.IdIntercambios = @pIdIntercambio AND (i.IdUsuarios1 = @pIdUsuario OR i.IdUsuarios2 = @pIdUsuario)
                        AND (e.Nombre = @pAceptado
                            OR (e.Nombre = @pPendiente AND (i.IdUsuarios2 = @pIdUsuario
                                OR EXISTS (SELECT 1 FROM Mensajes mr WHERE mr.IdIntercambio = i.IdIntercambios AND mr.IdUsuariosManda = i.IdUsuarios2))));
                    IF @idOtro IS NOT NULL
                        INSERT INTO Mensajes (Texto, fueVisto, FechaEnviado, FechaRecibido, IdUsuariosManda, IdIntercambio)
                        VALUES (@pTexto, 0, GETDATE(), NULL, @pIdUsuario, @pIdIntercambio);
                    SELECT @idOtro;";
                int? idOtro = connection.QueryFirstOrDefault<int?>(query, new
                {
                    pIdIntercambio = idIntercambio,
                    pIdUsuario = idUsuario,
                    pTexto = texto,
                    pPendiente = EstadosIntercambios.Pendiente,
                    pAceptado = EstadosIntercambios.Aceptado
                }, transaccion);

                List<NotificacionCreada> nuevas = new List<NotificacionCreada>();
                if (idOtro.HasValue)
                {
                    CrearNotificacion(connection, transaccion, nuevas, idOtro.Value, idIntercambio, TipoNotificaciones.MensajeNuevo,
                        siNoHayOtraSinLeer: true);
                }

                transaccion.Commit();
                creadas?.AddRange(nuevas);
                return idOtro.HasValue;
            }
        }
    }

    public static void MarcarMensajesVistos(int idIntercambio, int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = $@"UPDATE Mensajes SET fueVisto = 1, FechaRecibido = GETDATE()
                WHERE IdIntercambio = @pIdIntercambio AND IdUsuariosManda <> @pIdUsuario AND fueVisto = 0 AND {ParteDelIntercambio};
                UPDATE n SET n.Leida = 1
                FROM Notificaciones n
                INNER JOIN TipoNotificaciones t ON t.Id = n.IdTipoNotificacion
                WHERE n.IdUsuario = @pIdUsuario AND n.IdIntercambio = @pIdIntercambio AND t.Nombre = @pTipo AND n.Leida = 0";
            connection.Execute(query, new { pIdIntercambio = idIntercambio, pIdUsuario = idUsuario, pTipo = TipoNotificaciones.MensajeNuevo });
        }
    }

    // ---------- Interacciones y favoritos ----------

    private const string IdTipo = "(SELECT Id FROM TipoInteracciones WHERE Nombre = @pTipo)";

    public static int RegistrarVista(int idUsuario, int idArticulo)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = $@"INSERT INTO Interacciones (IdUsuario, IdTipoInteraccion, IdArticulo, Segundos, Fecha)
                OUTPUT INSERTED.Id
                VALUES (@pIdUsuario, {IdTipo}, @pIdArticulo, 0, GETDATE())";
            return connection.QuerySingle<int>(query, new { pIdUsuario = idUsuario, pIdArticulo = idArticulo, pTipo = TipoInteracciones.Vista });
        }
    }

    public static void GuardarSegundosVista(int idInteraccion, int idUsuario, int segundos)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = $@"UPDATE Interacciones SET Segundos = @pSegundos
                WHERE Id = @pId AND IdUsuario = @pIdUsuario AND IdTipoInteraccion = {IdTipo}";
            connection.Execute(query, new { pId = idInteraccion, pIdUsuario = idUsuario, pSegundos = segundos, pTipo = TipoInteracciones.Vista });
        }
    }

    public static void RegistrarBusqueda(int idUsuario, string? texto, IReadOnlyCollection<int> categorias, int minutosSinRepetir)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            if (!string.IsNullOrWhiteSpace(texto))
            {
                string query = $@"INSERT INTO Interacciones (IdUsuario, IdTipoInteraccion, Texto, Fecha)
                    SELECT @pIdUsuario, {IdTipo}, @pTexto, GETDATE()
                    WHERE NOT EXISTS (SELECT 1 FROM Interacciones r
                        WHERE r.IdUsuario = @pIdUsuario AND r.IdTipoInteraccion = {IdTipo} AND r.Texto = @pTexto
                            AND r.Fecha >= DATEADD(MINUTE, -@pMinutos, GETDATE()))";
                connection.Execute(query, new { pIdUsuario = idUsuario, pTexto = texto, pTipo = TipoInteracciones.Busqueda, pMinutos = minutosSinRepetir });
            }

            foreach (int idCategoria in categorias)
            {
                string query = $@"INSERT INTO Interacciones (IdUsuario, IdTipoInteraccion, IdCategoria, Fecha)
                    SELECT @pIdUsuario, {IdTipo}, @pIdCategoria, GETDATE()
                    WHERE EXISTS (SELECT 1 FROM Categorias WHERE IdCategorias = @pIdCategoria)
                        AND NOT EXISTS (SELECT 1 FROM Interacciones r
                            WHERE r.IdUsuario = @pIdUsuario AND r.IdTipoInteraccion = {IdTipo} AND r.IdCategoria = @pIdCategoria
                                AND r.Fecha >= DATEADD(MINUTE, -@pMinutos, GETDATE()))";
                connection.Execute(query, new { pIdUsuario = idUsuario, pIdCategoria = idCategoria, pTipo = TipoInteracciones.FiltroCategoria, pMinutos = minutosSinRepetir });
            }
        }
    }

    public static List<int> GetIdsFavoritos(int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = $"SELECT IdArticulo FROM Interacciones WHERE IdUsuario = @pIdUsuario AND IdTipoInteraccion = {IdTipo}";
            return connection.Query<int>(query, new { pIdUsuario = idUsuario, pTipo = TipoInteracciones.Favorito }).ToList();
        }
    }

    public static List<ArticuloCardViewModel> GetFavoritos(int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = $@"SELECT a.IdArticulos, a.Nombre, e.Nombre AS Estado, COALESCE(NULLIF(a.Ubicacion, ''), u.Barrio) AS Barrio,
                    (SELECT TOP 1 i.Ruta FROM Imagenes i WHERE i.IdArticulos = a.IdArticulos ORDER BY i.IdImagenes) AS Imagen,
                    a.IdUsuarios, a.IdCategorias, a.IdCategoriaACambio
                FROM Interacciones f
                INNER JOIN Articulos a ON a.IdArticulos = f.IdArticulo
                INNER JOIN Usuarios u ON u.IdUsuarios = a.IdUsuarios
                INNER JOIN EstadosArticulos e ON e.IdEstadosArticulos = a.IdEstado
                WHERE f.IdUsuario = @pIdUsuario AND f.IdTipoInteraccion = {IdTipo} AND {ArticuloDisponible}
                ORDER BY f.Fecha DESC, f.Id DESC";
            return connection.Query<ArticuloCardViewModel>(query, new
            {
                pIdUsuario = idUsuario,
                pTipo = TipoInteracciones.Favorito,
                pComprometidos = EstadosComprometidos
            }).ToList();
        }
    }

    public static bool? AlternarFavorito(int idUsuario, int idArticulo)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = $@"IF EXISTS (SELECT 1 FROM Interacciones WHERE IdUsuario = @pIdUsuario AND IdArticulo = @pIdArticulo AND IdTipoInteraccion = {IdTipo})
                BEGIN
                    DELETE FROM Interacciones WHERE IdUsuario = @pIdUsuario AND IdArticulo = @pIdArticulo AND IdTipoInteraccion = {IdTipo};
                    SELECT CAST(0 AS bit);
                END
                ELSE IF EXISTS (SELECT 1 FROM Articulos WHERE IdArticulos = @pIdArticulo AND IdUsuarios <> @pIdUsuario)
                BEGIN
                    INSERT INTO Interacciones (IdUsuario, IdTipoInteraccion, IdArticulo, Fecha) VALUES (@pIdUsuario, {IdTipo}, @pIdArticulo, GETDATE());
                    SELECT CAST(1 AS bit);
                END
                ELSE
                    SELECT CAST(NULL AS bit);";
            return connection.QuerySingle<bool?>(query, new { pIdUsuario = idUsuario, pIdArticulo = idArticulo, pTipo = TipoInteracciones.Favorito });
        }
    }

    public static void ImportarFavoritos(int idUsuario, IReadOnlyCollection<int> idsArticulos)
    {
        if (idsArticulos.Count == 0) return;
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = $@"INSERT INTO Interacciones (IdUsuario, IdTipoInteraccion, IdArticulo, Fecha)
                SELECT @pIdUsuario, {IdTipo}, a.IdArticulos, GETDATE()
                FROM Articulos a
                WHERE a.IdArticulos IN @pIds AND a.IdUsuarios <> @pIdUsuario
                    AND NOT EXISTS (SELECT 1 FROM Interacciones f
                        WHERE f.IdUsuario = @pIdUsuario AND f.IdArticulo = a.IdArticulos AND f.IdTipoInteraccion = {IdTipo})";
            connection.Execute(query, new { pIdUsuario = idUsuario, pIds = idsArticulos, pTipo = TipoInteracciones.Favorito });
        }
    }

    public static List<SenalGusto> GetSenalesGustos(IReadOnlyCollection<int> idsUsuarios, DateTime desde)
    {
        if (idsUsuarios.Count == 0) return new List<SenalGusto>();
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = @"SELECT i.IdUsuario, t.Nombre AS Tipo, COALESCE(i.IdCategoria, ai.IdCategorias) AS IdCategoria,
                    i.Texto, i.Segundos, i.Fecha
                FROM Interacciones i
                INNER JOIN TipoInteracciones t ON t.Id = i.IdTipoInteraccion
                LEFT JOIN Articulos ai ON ai.IdArticulos = i.IdArticulo
                WHERE i.IdUsuario IN @pIds AND i.Fecha >= @pDesde

                UNION ALL

                SELECT ic.IdUsuarios1, @pPropuesta, ap.IdCategorias, NULL, NULL, CAST(ic.Fecha AS datetime)
                FROM Intercambios ic
                INNER JOIN Articulos ap ON ap.IdArticulos = ic.IdArticulos2
                WHERE ic.IdUsuarios1 IN @pIds AND ic.Fecha >= CAST(@pDesde AS date)

                UNION ALL

                SELECT a.IdUsuarios, @pPideACambio, a.IdCategoriaACambio, NULL, NULL, GETDATE()
                FROM Articulos a
                WHERE a.IdUsuarios IN @pIds AND a.IdCategoriaACambio IS NOT NULL AND " + ArticuloDisponible;
            return connection.Query<SenalGusto>(query, new
            {
                pIds = idsUsuarios,
                pDesde = desde,
                pPropuesta = SenalGusto.Propuesta,
                pPideACambio = SenalGusto.PideACambio,
                pComprometidos = EstadosComprometidos
            }).ToList();
        }
    }

    public static List<PopularidadArticulo> GetPopularidad(DateTime desde)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = @"SELECT i.IdArticulo,
                    SUM(CASE WHEN t.Nombre = @pVista THEN 1 ELSE 0 END) AS Vistas,
                    SUM(CASE WHEN t.Nombre = @pFavorito THEN 1 ELSE 0 END) AS Favoritos
                FROM Interacciones i
                INNER JOIN TipoInteracciones t ON t.Id = i.IdTipoInteraccion
                WHERE i.IdArticulo IS NOT NULL AND i.Fecha >= @pDesde
                GROUP BY i.IdArticulo";
            return connection.Query<PopularidadArticulo>(query, new
            {
                pDesde = desde,
                pVista = TipoInteracciones.Vista,
                pFavorito = TipoInteracciones.Favorito
            }).ToList();
        }
    }

    private static string? PatronBusqueda(string? busqueda) =>
        string.IsNullOrWhiteSpace(busqueda) ? null : EscaparLike(busqueda.Trim());

    private static string EscaparLike(string texto) =>
        texto.Replace("[", "[[]").Replace("%", "[%]").Replace("_", "[_]");
}