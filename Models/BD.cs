using Dapper;
using Microsoft.Data.SqlClient;
using Swappit.Models.ViewModels;

namespace Swappit.Models;

public static class BD
{
    private static string _connectionString = //@"Server=localhost; DataBase=Base_De_Datos_Swappit; Integrated Security=True; TrustServerCertificate=True;";
    @"Server=.\SQLEXPRESS;Database=Base_De_Datos_Swappit;Integrated Security=True;TrustServerCertificate=True;";

    
    private const string SelectUsuarios = @"SELECT IdUsuarios, Nombre, Apellido, Usuario, Mail, Telefono, Contraseña, Barrio,
        [Fecha nacimiento] AS FechaNacimiento, Edad, IdProvincias, Descripcion FROM Usuarios";

    public static Usuarios? GetUsuarioByMail(string mail)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = SelectUsuarios + " WHERE Mail = @pMail";
            return connection.QueryFirstOrDefault<Usuarios>(query, new { pMail = mail });
        }
    }

    public static void ActualizarContrasena(int idUsuario, string contrasenaHash)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = "UPDATE Usuarios SET Contraseña = @pContrasena WHERE IdUsuarios = @pId";
            connection.Execute(query, new { pId = idUsuario, pContrasena = contrasenaHash });
        }
    }

    public static bool UsuarioExiste(string mail)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = "SELECT COUNT(*) FROM Usuarios WHERE Mail = @pMail";
            return connection.ExecuteScalar<int>(query, new { pMail = mail }) > 0;
        }
    }

    public static Usuarios? GetUsuarioById(int id)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = SelectUsuarios + " WHERE IdUsuarios = @pId";
            return connection.QueryFirstOrDefault<Usuarios>(query, new { pId = id });
        }
    }

    public static Provincias? GetProvinciaById(int id)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = "SELECT IdProvincia, Nombre FROM Provincias WHERE IdProvincia = @pId";
            return connection.QueryFirstOrDefault<Provincias>(query, new { pId = id });
        }
    }

    public static List<Provincias> GetProvincias()
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = "SELECT IdProvincia, Nombre FROM Provincias ORDER BY Nombre";
            return connection.Query<Provincias>(query).ToList();
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
            string query = @"UPDATE Usuarios SET Nombre = @Nombre, Apellido = @Apellido, Usuario = @Usuario, Mail = @Mail,
                Telefono = @Telefono, Contraseña = @Contraseña, Barrio = @Barrio, [Fecha nacimiento] = @FechaNacimiento,
                Edad = @Edad, IdProvincias = @IdProvincias, Descripcion = @Descripcion WHERE IdUsuarios = @IdUsuarios";
            connection.Execute(query, u);
        }
    }

    public static string? GetFotoUsuario(int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = "SELECT TOP 1 Ruta FROM Imagenes WHERE IdUsuarios = @pId AND IdArticulos IS NULL ORDER BY IdImagenes DESC";
            return connection.QueryFirstOrDefault<string>(query, new { pId = idUsuario });
        }
    }

    public static void GuardarFotoUsuario(int idUsuario, string ruta)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = @"DELETE FROM Imagenes WHERE IdUsuarios = @pId AND IdArticulos IS NULL;
                INSERT INTO Imagenes (Ruta, IdUsuarios) VALUES (@pRuta, @pId)";
            connection.Execute(query, new { pId = idUsuario, pRuta = ruta });
        }
    }

    public static void BorrarFotoUsuario(int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = "DELETE FROM Imagenes WHERE IdUsuarios = @pId AND IdArticulos IS NULL";
            connection.Execute(query, new { pId = idUsuario });
        }
    }

    // Un artículo con un intercambio Aceptado o Realizado ya está comprometido: deja de mostrarse en el inicio,
    // el catálogo, los filtros, los perfiles y "Más artículos de...", y no se puede pedir ni ofrecer en otra propuesta.
    // No se le cambia nada al artículo: se calcula desde Intercambios (sigue visible en Mis intercambios y en su detalle).
    // Va con el alias "a" para Articulos y necesita el parámetro @pComprometidos (EstadosComprometidos).
    private const string ArticuloDisponible = @"NOT EXISTS (SELECT 1 FROM Intercambios ic
        INNER JOIN EstadosIntercambios eic ON eic.IdEstadosIntercambios = ic.IdEstado
        WHERE eic.Nombre IN @pComprometidos AND (ic.IdArticulos1 = a.IdArticulos OR ic.IdArticulos2 = a.IdArticulos))";

    private static readonly string[] EstadosComprometidos = { EstadosIntercambios.Aceptado, EstadosIntercambios.Realizado };

    // idUsuario: solo los artículos de ese usuario (perfiles). excluirUsuario: todos menos los de ese usuario
    // (en Explorar no se muestran los artículos propios del que está logueado).
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
            // Barrio: la ubicación que cargó el dueño al publicar; si no tiene, el barrio de su perfil.
            string query = $@"SELECT {top}a.IdArticulos, a.Nombre, e.Nombre AS Estado, COALESCE(NULLIF(a.Ubicacion, ''), u.Barrio) AS Barrio,
                    (SELECT TOP 1 i.Ruta FROM Imagenes i WHERE i.IdArticulos = a.IdArticulos ORDER BY i.IdImagenes) AS Imagen
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
            string query = @"SELECT IdArticulos, Nombre, Descripcion, IdEstado, IdUsuarios, IdCategorias, Ubicacion, ACambio
                FROM Articulos WHERE IdArticulos = @pId";
            return connection.QueryFirstOrDefault<Articulos>(query, new { pId = id });
        }
    }

    // Guarda un artículo nuevo y sus fotos (rutas ya guardadas en wwwroot, la primera es la portada).
    // Va todo en una transacción: si falla algo, no queda un artículo a medias. Devuelve el IdArticulos nuevo.
    public static int PublicarArticulo(Articulos a, List<string> rutasFotos)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            connection.Open();
            using (SqlTransaction transaccion = connection.BeginTransaction())
            {
                string query = @"INSERT INTO Articulos (Nombre, Descripcion, IdEstado, IdUsuarios, IdCategorias, Ubicacion, ACambio)
                    OUTPUT INSERTED.IdArticulos
                    VALUES (@Nombre, @Descripcion, @IdEstado, @IdUsuarios, @IdCategorias, @Ubicacion, @ACambio)";
                int idArticulo = connection.QuerySingle<int>(query, a, transaccion);

                // Las fotos de artículos llevan IdArticulos (las de perfil llevan IdUsuarios e IdArticulos NULL).
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

    public static List<string> GetImagenesArticulo(int idArticulo)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = "SELECT Ruta FROM Imagenes WHERE IdArticulos = @pId ORDER BY IdImagenes";
            return connection.Query<string>(query, new { pId = idArticulo }).ToList();
        }
    }

    public static Categorias? GetCategoriaById(int id)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = "SELECT IdCategorias, Nombre FROM Categorias WHERE IdCategorias = @pId";
            return connection.QueryFirstOrDefault<Categorias>(query, new { pId = id });
        }
    }

    public static List<Categorias> GetCategorias()
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = "SELECT IdCategorias, Nombre FROM Categorias ORDER BY Nombre";
            return connection.Query<Categorias>(query).ToList();
        }
    }


    // Opciones de "Estado del objeto" en Publicar, en el orden en que se cargaron (de mejor a peor).
    public static List<EstadosArticulos> GetEstadosArticulos()
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = "SELECT IdEstadosArticulos, Nombre FROM EstadosArticulos ORDER BY IdEstadosArticulos";
            return connection.Query<EstadosArticulos>(query).ToList();
        }
    }

    public static EstadosArticulos? GetEstadoArticuloById(int id)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = "SELECT IdEstadosArticulos, Nombre FROM EstadosArticulos WHERE IdEstadosArticulos = @pId";
            return connection.QueryFirstOrDefault<EstadosArticulos>(query, new { pId = id });
        }
    }

    // excluirUsuario: no cuenta los artículos de ese usuario (igual que GetArticulosCatalogo en Explorar).
    public static List<OpcionFiltroViewModel> GetFiltroCategorias(string? busqueda = null, int? excluirUsuario = null)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = @"SELECT CAST(c.IdCategorias AS varchar(10)) AS Valor, c.Nombre AS Texto, COUNT(a.IdArticulos) AS Cantidad
                FROM Categorias c
                LEFT JOIN Articulos a ON a.IdCategorias = c.IdCategorias
                    AND (@pBusqueda IS NULL OR a.Nombre LIKE '%' + @pBusqueda + '%')
                    AND (@pExcluirUsuario IS NULL OR a.IdUsuarios <> @pExcluirUsuario)
                    AND " + ArticuloDisponible + @"
                GROUP BY c.IdCategorias, c.Nombre
                ORDER BY c.Nombre";
            return connection.Query<OpcionFiltroViewModel>(query, new { pBusqueda = PatronBusqueda(busqueda), pExcluirUsuario = excluirUsuario, pComprometidos = EstadosComprometidos }).ToList();
        }
    }

    // Estados para el filtro de Buscar: todos los de EstadosArticulos (como las categorías), de mejor a peor.
    public static List<OpcionFiltroViewModel> GetFiltroEstados(string? busqueda = null, int? excluirUsuario = null)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = @"SELECT CAST(e.IdEstadosArticulos AS varchar(10)) AS Valor, e.Nombre AS Texto, COUNT(a.IdArticulos) AS Cantidad
                FROM EstadosArticulos e
                LEFT JOIN Articulos a ON a.IdEstado = e.IdEstadosArticulos
                    AND (@pBusqueda IS NULL OR a.Nombre LIKE '%' + @pBusqueda + '%')
                    AND (@pExcluirUsuario IS NULL OR a.IdUsuarios <> @pExcluirUsuario)
                    AND " + ArticuloDisponible + @"
                GROUP BY e.IdEstadosArticulos, e.Nombre
                ORDER BY e.IdEstadosArticulos";
            return connection.Query<OpcionFiltroViewModel>(query, new { pBusqueda = PatronBusqueda(busqueda), pExcluirUsuario = excluirUsuario, pComprometidos = EstadosComprometidos }).ToList();
        }
    }

    // ---------- Intercambios ----------
    // Quien propone queda en IdUsuarios1/IdArticulos1 (el artículo que ofrece) y el dueño del artículo pedido
    // en IdUsuarios2/IdArticulos2. Los estados se buscan por nombre (ver EstadosIntercambios).

    // Lista de intercambios del usuario (enviados y recibidos), lo más nuevo primero.
    // "Mi..." es siempre lo del usuario logueado y "Su..."/"Otro..." lo de la otra persona.
    // Va sin el SELECT para poder agregarle TOP (ver GetIntercambios).
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

    // Un intercambio, solo si el usuario es una de las dos partes (si no, null).
    public static IntercambioViewModel? GetIntercambio(int idIntercambio, int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = $"SELECT {ConsultaIntercambios} AND i.IdIntercambios = @pId";
            return connection.QueryFirstOrDefault<IntercambioViewModel>(query, new { pId = idIntercambio, pIdUsuario = idUsuario });
        }
    }

    // Propuesta en curso (Pendiente o Aceptado) que el usuario ya hizo por ese artículo, para no repetirla.
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

    // true si el artículo ya está en un intercambio Aceptado o Realizado (ver ArticuloDisponible).
    public static bool ArticuloComprometido(int idArticulo)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = "SELECT CAST(CASE WHEN " + ArticuloDisponible + " THEN 0 ELSE 1 END AS bit) FROM Articulos a WHERE a.IdArticulos = @pId";
            return connection.QueryFirstOrDefault<bool>(query, new { pId = idArticulo, pComprometidos = EstadosComprometidos });
        }
    }

    // Guarda una propuesta nueva en estado Pendiente con la fecha de hoy y devuelve su IdIntercambios.
    // Si el usuario ya tiene una propuesta en curso por ese artículo, o alguno de los dos artículos ya está comprometido,
    // no inserta nada y devuelve null (el chequeo va en el mismo INSERT para que dos clics seguidos no creen dos propuestas).
    // En la misma transacción le avisa al dueño del artículo pedido (notificación "Propuesta recibida").
    public static int? ProponerIntercambio(int idUsuario, int idArticuloOfrecido, int idDueno, int idArticuloPedido)
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
                int? idIntercambio = connection.QueryFirstOrDefault<int?>(query, new
                {
                    pIdUsuario = idUsuario,
                    pIdDueno = idDueno,
                    pIdOfrecido = idArticuloOfrecido,
                    pIdPedido = idArticuloPedido,
                    pPendiente = EstadosIntercambios.Pendiente,
                    pEnCurso = new[] { EstadosIntercambios.Pendiente, EstadosIntercambios.Aceptado },
                    pComprometidos = EstadosComprometidos
                }, transaccion);

                if (idIntercambio.HasValue)
                {
                    CrearNotificacion(connection, transaccion, idDueno, idIntercambio.Value, TipoNotificaciones.PropuestaRecibida);
                }

                transaccion.Commit();
                return idIntercambio;
            }
        }
    }

    // Pasa un intercambio de estadoActual a estadoNuevo. Solo lo cambia si el usuario puede hacerlo:
    // soloQuienRecibe = true -> solo el dueño del artículo pedido (aceptar o rechazar); si no, cualquiera de los dos.
    // Si se cambió y viene tipoNotificacion, en la misma transacción le avisa a la otra persona del intercambio.
    // Para pasar a Aceptado, ninguno de los dos artículos puede estar ya en otro intercambio Aceptado o Realizado,
    // y en la misma transacción se rechazan las otras propuestas pendientes con esos artículos (ver RechazarPendientesDeArticulos).
    // Devuelve false si no se cambió (no existe, no es del usuario, ya no estaba en estadoActual o el artículo ya está comprometido).
    public static bool CambiarEstadoIntercambio(int idIntercambio, int idUsuario, string estadoActual, string estadoNuevo,
        bool soloQuienRecibe, string? tipoNotificacion = null)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            connection.Open();
            using (SqlTransaction transaccion = connection.BeginTransaction())
            {
                // Devuelve el id de la otra persona, o nada si no se actualizó ninguna fila.
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

                if (idOtro.HasValue && tipoNotificacion != null)
                {
                    CrearNotificacion(connection, transaccion, idOtro.Value, idIntercambio, tipoNotificacion);
                }

                if (idOtro.HasValue && estadoNuevo == EstadosIntercambios.Aceptado)
                {
                    RechazarPendientesDeArticulos(connection, transaccion, idIntercambio, idUsuario);
                }

                transaccion.Commit();
                return idOtro.HasValue;
            }
        }
    }

    // Pasa el intercambio a Cancelado y le avisa a la otra persona ("Intercambio cancelado"), en una transacción.
    // Una propuesta Pendiente solo la cancela quien la hizo (quien la recibió la rechaza); uno Aceptado, cualquiera de los dos.
    // Devuelve false si el usuario no puede cancelarlo o si ya cambió de estado.
    // Al dejar de estar Aceptado, los dos artículos vuelven a estar disponibles (ver ArticuloDisponible).
    public static bool CancelarIntercambio(int idIntercambio, int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            connection.Open();
            using (SqlTransaction transaccion = connection.BeginTransaction())
            {
                // Devuelve el id de la otra persona, o nada si no se actualizó ninguna fila.
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

                if (idOtro.HasValue)
                {
                    CrearNotificacion(connection, transaccion, idOtro.Value, idIntercambio, TipoNotificaciones.IntercambioCancelado);
                }

                transaccion.Commit();
                return idOtro.HasValue;
            }
        }
    }

    // Otras propuestas Pendientes que usan alguno de los dos artículos del intercambio (como pedido o como ofrecido).
    // Son las que se rechazan solas si se acepta este intercambio.
    private const string CondicionPendientesDeArticulos = @"o.IdIntercambios <> @pId
        AND EXISTS (SELECT 1 FROM Intercambios acep WHERE acep.IdIntercambios = @pId
            AND (o.IdArticulos1 IN (acep.IdArticulos1, acep.IdArticulos2) OR o.IdArticulos2 IN (acep.IdArticulos1, acep.IdArticulos2)))";

    // Cuántas propuestas se rechazarían solas al aceptar este intercambio (para avisarle antes a quien acepta).
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

    // Se llama al aceptar un intercambio, dentro de su transacción: pasa a Rechazado las otras propuestas pendientes
    // con esos artículos y le avisa a quien las hizo ("Propuesta rechazada"). No se avisa a quien acepta (idUsuario),
    // por ejemplo si él mismo había ofrecido ese artículo en otra propuesta.
    private static void RechazarPendientesDeArticulos(SqlConnection connection, SqlTransaction transaccion, int idIntercambio, int idUsuario)
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
            CrearNotificacion(connection, transaccion, r.IdUsuarios1, r.IdIntercambios, TipoNotificaciones.PropuestaRechazada);
        }
    }

    // Estados para los filtros de Mis intercambios, en el orden de la tabla.
    public static List<EstadosIntercambios> GetEstadosIntercambios()
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = "SELECT IdEstadosIntercambios, Nombre FROM EstadosIntercambios ORDER BY IdEstadosIntercambios";
            return connection.Query<EstadosIntercambios>(query).ToList();
        }
    }

    // ---------- Notificaciones ----------
    // Cada notificación es para un usuario (IdUsuario) sobre un intercambio. El tipo se busca por nombre
    // (ver TipoNotificaciones): si ese tipo no está cargado en la tabla, no se inserta nada.

    // Se llama desde ProponerIntercambio, CambiarEstadoIntercambio, CancelarIntercambio y EnviarMensaje, dentro de su transacción.
    // siNoHayOtraSinLeer = true: no la crea si el usuario ya tiene una sin leer de ese tipo y de ese intercambio
    // (así un chat con 10 mensajes seguidos deja una sola notificación "Mensaje nuevo").
    private static void CrearNotificacion(SqlConnection connection, SqlTransaction transaccion, int idUsuario, int idIntercambio, string tipo,
        bool siNoHayOtraSinLeer = false)
    {
        string query = @"INSERT INTO Notificaciones (IdUsuario, IdIntercambio, IdTipoNotificacion, Leida, Fecha)
            SELECT @pIdUsuario, @pIdIntercambio, t.Id, 0, GETDATE()
            FROM TipoNotificaciones t WHERE t.Nombre = @pTipo
                AND (@pSiNoHayOtra = 0 OR NOT EXISTS (SELECT 1 FROM Notificaciones n
                    WHERE n.IdUsuario = @pIdUsuario AND n.IdIntercambio = @pIdIntercambio AND n.IdTipoNotificacion = t.Id AND n.Leida = 0))";
        connection.Execute(query, new
        {
            pIdUsuario = idUsuario,
            pIdIntercambio = idIntercambio,
            pTipo = tipo,
            pSiNoHayOtra = siNoHayOtraSinLeer
        }, transaccion);
    }

    // Notificaciones del usuario para el pop up del header, lo más nuevo primero.
    // "Otro" es la otra persona del intercambio y el artículo es el pedido (IdArticulos2).
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
            string query = "SELECT COUNT(*) FROM Notificaciones WHERE IdUsuario = @pIdUsuario AND Leida = 0";
            return connection.ExecuteScalar<int>(query, new { pIdUsuario = idUsuario });
        }
    }

    // Marca como leída una notificación del usuario y la devuelve con su IdIntercambio y su Tipo, para saber a dónde llevarlo
    // (null si no es suya o no existe).
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
            string query = "UPDATE Notificaciones SET Leida = 1 WHERE IdUsuario = @pIdUsuario AND Leida = 0";
            connection.Execute(query, new { pIdUsuario = idUsuario });
        }
    }

    // ---------- Chat ----------
    // Hay un chat por intercambio: Mensajes.IdIntercambio. Solo lo usan las dos partes del intercambio
    // (todas las consultas lo chequean con ParteDelIntercambio). Se puede escribir mientras el intercambio
    // está en curso (Pendiente o Aceptado); cuando se rechaza o se realiza, el chat queda para leer.

    // Condición "el usuario @pIdUsuario es una de las dos partes del intercambio @pIdIntercambio".
    private const string ParteDelIntercambio = @"EXISTS (SELECT 1 FROM Intercambios ip
        WHERE ip.IdIntercambios = @pIdIntercambio AND (ip.IdUsuarios1 = @pIdUsuario OR ip.IdUsuarios2 = @pIdUsuario))";

    // Último mensaje y cantidad sin ver de cada intercambio del usuario que ya tiene mensajes.
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

    // Mensajes del chat de un intercambio, del más viejo al más nuevo (vacío si el usuario no es parte del intercambio).
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

    // Guarda un mensaje del usuario en el chat del intercambio y, en la misma transacción, le avisa a la otra persona
    // (notificación "Mensaje nuevo", una sola mientras no la lea). Solo lo guarda si el usuario es parte del intercambio
    // y el intercambio está en curso; si no, devuelve false.
    public static bool EnviarMensaje(int idIntercambio, int idUsuario, string texto)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            connection.Open();
            using (SqlTransaction transaccion = connection.BeginTransaction())
            {
                // Busca a la otra persona solo si el usuario es parte y el intercambio está en curso; si la encontró, inserta.
                // Devuelve el id de la otra persona, o NULL si no se insertó.
                string query = @"DECLARE @idOtro int;
                    SELECT @idOtro = CASE WHEN i.IdUsuarios1 = @pIdUsuario THEN i.IdUsuarios2 ELSE i.IdUsuarios1 END
                    FROM Intercambios i
                    INNER JOIN EstadosIntercambios e ON e.IdEstadosIntercambios = i.IdEstado
                    WHERE i.IdIntercambios = @pIdIntercambio AND (i.IdUsuarios1 = @pIdUsuario OR i.IdUsuarios2 = @pIdUsuario)
                        AND e.Nombre IN @pEnCurso;
                    IF @idOtro IS NOT NULL
                        INSERT INTO Mensajes (Texto, fueVisto, FechaEnviado, FechaRecibido, IdUsuariosManda, IdIntercambio)
                        VALUES (@pTexto, 0, GETDATE(), NULL, @pIdUsuario, @pIdIntercambio);
                    SELECT @idOtro;";
                int? idOtro = connection.QueryFirstOrDefault<int?>(query, new
                {
                    pIdIntercambio = idIntercambio,
                    pIdUsuario = idUsuario,
                    pTexto = texto,
                    pEnCurso = new[] { EstadosIntercambios.Pendiente, EstadosIntercambios.Aceptado }
                }, transaccion);

                if (idOtro.HasValue)
                {
                    CrearNotificacion(connection, transaccion, idOtro.Value, idIntercambio, TipoNotificaciones.MensajeNuevo, siNoHayOtraSinLeer: true);
                }

                transaccion.Commit();
                return idOtro.HasValue;
            }
        }
    }

    // El usuario abrió el chat: marca como vistos los mensajes que le mandó la otra persona (con la fecha en FechaRecibido)
    // y como leídas sus notificaciones "Mensaje nuevo" de ese intercambio.
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

    private static string? PatronBusqueda(string? busqueda) =>
        string.IsNullOrWhiteSpace(busqueda) ? null : EscaparLike(busqueda.Trim());

    // Evita que %, _ o [ escritos por el usuario funcionen como comodines del LIKE.
    private static string EscaparLike(string texto) =>
        texto.Replace("[", "[[]").Replace("%", "[%]").Replace("_", "[_]");
}
