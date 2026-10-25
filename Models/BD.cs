using Dapper;
using Microsoft.Data.SqlClient;
using Swappit.Models.ViewModels;

namespace Swappit.Models;

public static class BD
{
    private static string _connectionString = //@"Server=localhost; DataBase=Base_De_Datos_Swappit; Integrated Security=True; TrustServerCertificate=True;";
    @"Server=.\SQLEXPRESS;Database=Base_De_Datos_Swappit;Integrated Security=True;TrustServerCertificate=True;";
    private const string SelectUsuarios = @"SELECT IdUsuarios, Nombre, Apellido, Usuario, Mail, Telefono, Contraseña, Barrio,
        [Fecha nacimiento] AS FechaNacimiento, Edad, IdProvincias FROM Usuarios";

    public static Usuarios? Login(LoginViewModel l)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = SelectUsuarios + " WHERE Mail = @pMail AND Contraseña = @pContrasena";
            return connection.QueryFirstOrDefault<Usuarios>(query, new { pMail = l.Mail, pContrasena = l.Contrasena });
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
                Edad = @Edad, IdProvincias = @IdProvincias WHERE IdUsuarios = @IdUsuarios";
            connection.Execute(query, u);
        }
    }

    // La foto de perfil es la fila de Imagenes con IdUsuarios del usuario y sin IdArticulos.
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

    // Artículos para el catálogo, del más nuevo al más viejo.
    // busqueda: filtra por nombre (null o vacío = todos). cantidad: límite opcional (ej: destacados del inicio).
    // categorias / estados: filtros del panel de Buscar (null o vacío = sin filtrar por ese campo).
    // idUsuario: solo los artículos publicados por ese usuario (Articulos.IdUsuarios), para el perfil.
    public static List<ArticuloCardViewModel> GetArticulosCatalogo(string? busqueda = null, int? cantidad = null,
        IReadOnlyCollection<int>? categorias = null, IReadOnlyCollection<string>? estados = null, int? idUsuario = null)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            var condiciones = new List<string> { "(@pBusqueda IS NULL OR a.Nombre LIKE '%' + @pBusqueda + '%')" };
            // Dapper expande las listas en IN (...); con una lista vacía no se agrega la condición.
            if (categorias is { Count: > 0 }) condiciones.Add("a.IdCategorias IN @pCategorias");
            if (estados is { Count: > 0 }) condiciones.Add("a.Estado IN @pEstados");
            if (idUsuario.HasValue) condiciones.Add("a.IdUsuarios = @pIdUsuario");

            string top = cantidad.HasValue ? "TOP (@pCantidad) " : "";
            string query = $@"SELECT {top}a.IdArticulos, a.Nombre, a.Estado, u.Barrio,
                    (SELECT TOP 1 i.Ruta FROM Imagenes i WHERE i.IdArticulos = a.IdArticulos ORDER BY i.IdImagenes) AS Imagen
                FROM Articulos a
                INNER JOIN Usuarios u ON u.IdUsuarios = a.IdUsuarios
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
            string query = "SELECT IdArticulos, Nombre, Descripcion, Estado, IdUsuarios, IdCategorias FROM Articulos WHERE IdArticulos = @pId";
            return connection.QueryFirstOrDefault<Articulos>(query, new { pId = id });
        }
    }

    // Fotos de un artículo (Imagenes.IdArticulos), en el orden en que se cargaron. La primera es la de la card.
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

    // Categorías para el filtro de Buscar, con cuántos artículos de cada una coinciden con la búsqueda por nombre.
    // Incluye las categorías sin artículos (cantidad 0).
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

    // Estados para el filtro de Buscar. No hay tabla de estados: son los valores distintos de Articulos.Estado.
    public static List<OpcionFiltroViewModel> GetFiltroEstados(string? busqueda = null)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = @"SELECT Estado AS Valor, Estado AS Texto, COUNT(*) AS Cantidad
                FROM Articulos
                WHERE @pBusqueda IS NULL OR Nombre LIKE '%' + @pBusqueda + '%'
                GROUP BY Estado
                ORDER BY Estado";
            return connection.Query<OpcionFiltroViewModel>(query, new { pBusqueda = PatronBusqueda(busqueda) }).ToList();
        }
    }

    private static string? PatronBusqueda(string? busqueda) =>
        string.IsNullOrWhiteSpace(busqueda) ? null : EscaparLike(busqueda.Trim());

    // Evita que %, _ o [ escritos por el usuario funcionen como comodines del LIKE.
    private static string EscaparLike(string texto) =>
        texto.Replace("[", "[[]").Replace("%", "[%]").Replace("_", "[_]");
}
