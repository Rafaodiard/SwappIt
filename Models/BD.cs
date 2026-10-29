using Dapper;
using Microsoft.Data.SqlClient;
using Swappit.Models.ViewModels;

namespace Swappit.Models;

public static class BD
{
    private static string _connectionString = @"Server=localhost; DataBase=Base_De_Datos_Swappit; Integrated Security=True; TrustServerCertificate=True;";
    //@"Server=.\SQLEXPRESS;Database=Base_De_Datos_Swappit;Integrated Security=True;TrustServerCertificate=True;";

    
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

 
    public static List<ArticuloCardViewModel> GetArticulosCatalogo(string? busqueda = null, int? cantidad = null,
        IReadOnlyCollection<int>? categorias = null, IReadOnlyCollection<int>? estados = null, int? idUsuario = null)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            var condiciones = new List<string> { "(@pBusqueda IS NULL OR a.Nombre LIKE '%' + @pBusqueda + '%')" };
            if (categorias is { Count: > 0 }) condiciones.Add("a.IdCategorias IN @pCategorias");
            if (estados is { Count: > 0 }) condiciones.Add("a.IdEstado IN @pEstados");
            if (idUsuario.HasValue) condiciones.Add("a.IdUsuarios = @pIdUsuario");

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
                pIdUsuario = idUsuario
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

    public static List<OpcionFiltroViewModel> GetFiltroCategorias(string? busqueda = null)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = @"SELECT CAST(c.IdCategorias AS varchar(10)) AS Valor, c.Nombre AS Texto, COUNT(a.IdArticulos) AS Cantidad
                FROM Categorias c
                LEFT JOIN Articulos a ON a.IdCategorias = c.IdCategorias
                    AND (@pBusqueda IS NULL OR a.Nombre LIKE '%' + @pBusqueda + '%')
                GROUP BY c.IdCategorias, c.Nombre
                ORDER BY c.Nombre";
            return connection.Query<OpcionFiltroViewModel>(query, new { pBusqueda = PatronBusqueda(busqueda) }).ToList();
        }
    }

    // Estados para el filtro de Buscar: todos los de EstadosArticulos (como las categorías), de mejor a peor.
    public static List<OpcionFiltroViewModel> GetFiltroEstados(string? busqueda = null)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = @"SELECT CAST(e.IdEstadosArticulos AS varchar(10)) AS Valor, e.Nombre AS Texto, COUNT(a.IdArticulos) AS Cantidad
                FROM EstadosArticulos e
                LEFT JOIN Articulos a ON a.IdEstado = e.IdEstadosArticulos
                    AND (@pBusqueda IS NULL OR a.Nombre LIKE '%' + @pBusqueda + '%')
                GROUP BY e.IdEstadosArticulos, e.Nombre
                ORDER BY e.IdEstadosArticulos";
            return connection.Query<OpcionFiltroViewModel>(query, new { pBusqueda = PatronBusqueda(busqueda) }).ToList();
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

    // Guarda una propuesta nueva en estado Pendiente con la fecha de hoy y devuelve su IdIntercambios.
    // Si el usuario ya tiene una propuesta en curso por ese artículo no inserta nada y devuelve null
    // (el chequeo va en el mismo INSERT para que dos clics seguidos no creen dos propuestas).
    public static int? ProponerIntercambio(int idUsuario, int idArticuloOfrecido, int idDueno, int idArticuloPedido)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = @"INSERT INTO Intercambios (Fecha, IdEstado, IdUsuarios1, IdUsuarios2, IdArticulos1, IdArticulos2)
                OUTPUT INSERTED.IdIntercambios
                SELECT CAST(GETDATE() AS date), e.IdEstadosIntercambios, @pIdUsuario, @pIdDueno, @pIdOfrecido, @pIdPedido
                FROM EstadosIntercambios e
                WHERE e.Nombre = @pPendiente
                    AND NOT EXISTS (SELECT 1 FROM Intercambios i
                        INNER JOIN EstadosIntercambios ei ON ei.IdEstadosIntercambios = i.IdEstado
                        WHERE i.IdUsuarios1 = @pIdUsuario AND i.IdArticulos2 = @pIdPedido AND ei.Nombre IN @pEnCurso)";
            return connection.QueryFirstOrDefault<int?>(query, new
            {
                pIdUsuario = idUsuario,
                pIdDueno = idDueno,
                pIdOfrecido = idArticuloOfrecido,
                pIdPedido = idArticuloPedido,
                pPendiente = EstadosIntercambios.Pendiente,
                pEnCurso = new[] { EstadosIntercambios.Pendiente, EstadosIntercambios.Aceptado }
            });
        }
    }

    // Pasa un intercambio de estadoActual a estadoNuevo. Solo lo cambia si el usuario puede hacerlo:
    // soloQuienRecibe = true -> solo el dueño del artículo pedido (aceptar o rechazar); si no, cualquiera de los dos.
    // Devuelve false si no se cambió (no existe, no es del usuario o ya no estaba en estadoActual).
    public static bool CambiarEstadoIntercambio(int idIntercambio, int idUsuario, string estadoActual, string estadoNuevo, bool soloQuienRecibe)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = @"UPDATE i SET i.IdEstado = nuevo.IdEstadosIntercambios
                FROM Intercambios i
                INNER JOIN EstadosIntercambios actual ON actual.IdEstadosIntercambios = i.IdEstado
                INNER JOIN EstadosIntercambios nuevo ON nuevo.Nombre = @pNuevo
                WHERE i.IdIntercambios = @pId AND actual.Nombre = @pActual
                    AND (i.IdUsuarios2 = @pIdUsuario OR (@pSoloQuienRecibe = 0 AND i.IdUsuarios1 = @pIdUsuario))";
            return connection.Execute(query, new
            {
                pId = idIntercambio,
                pIdUsuario = idUsuario,
                pActual = estadoActual,
                pNuevo = estadoNuevo,
                pSoloQuienRecibe = soloQuienRecibe
            }) > 0;
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

    private static string? PatronBusqueda(string? busqueda) =>
        string.IsNullOrWhiteSpace(busqueda) ? null : EscaparLike(busqueda.Trim());

    // Evita que %, _ o [ escritos por el usuario funcionen como comodines del LIKE.
    private static string EscaparLike(string texto) =>
        texto.Replace("[", "[[]").Replace("%", "[%]").Replace("_", "[_]");
}
