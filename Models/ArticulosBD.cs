using Dapper;
using Microsoft.Data.SqlClient;
using System.Data;
using Swappit.Models.ViewModels;

namespace Swappit.Models;

public static class ArticulosBD
{
    private static string _connectionString = //@"Server=localhost; DataBase=Base_De_Datos_Swappit; Integrated Security=True; TrustServerCertificate=True;";
    @"Server=.\SQLEXPRESS;Database=Base_De_Datos_Swappit;Integrated Security=True;TrustServerCertificate=True;";

    private const string ArticuloDisponible = @"NOT EXISTS (SELECT 1 FROM ArticulosIntercambios aic
        INNER JOIN Intercambios ic ON ic.IdIntercambios = aic.IdIntercambio
        INNER JOIN EstadosIntercambios eic ON eic.IdEstadosIntercambios = ic.IdEstado
        WHERE eic.Nombre IN @pComprometidos AND aic.IdArticulo = a.IdArticulos)";

    private const string ArticuloNoIntercambiado = @"NOT EXISTS (SELECT 1 FROM ArticulosIntercambios air
        INNER JOIN Intercambios ir ON ir.IdIntercambios = air.IdIntercambio
        INNER JOIN EstadosIntercambios eir ON eir.IdEstadosIntercambios = ir.IdEstado
        WHERE eir.Nombre = @pRealizado AND air.IdArticulo = a.IdArticulos)";

    private static readonly string[] EstadosComprometidos = { EstadosIntercambios.Aceptado, EstadosIntercambios.Realizado };

    public static List<ArticuloCardViewModel> GetArticulosCatalogo(string? busqueda = null, int? cantidad = null,
        IReadOnlyCollection<int>? categorias = null, IReadOnlyCollection<int>? estados = null, int? idUsuario = null,
        int? excluirUsuario = null, bool incluirEnIntercambio = false)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            var condiciones = new List<string>
            {
                "(@pBusqueda IS NULL OR a.Nombre LIKE '%' + @pBusqueda + '%')",
                incluirEnIntercambio ? ArticuloNoIntercambiado : ArticuloDisponible
            };
            if (categorias is { Count: > 0 }) condiciones.Add("a.IdCategorias IN @pCategorias");
            if (estados is { Count: > 0 }) condiciones.Add("a.IdEstado IN @pEstados");
            if (idUsuario.HasValue) condiciones.Add("a.IdUsuarios = @pIdUsuario");
            if (excluirUsuario.HasValue) condiciones.Add("a.IdUsuarios <> @pExcluirUsuario");

            string top = cantidad.HasValue ? "TOP (@pCantidad) " : "";
            string enIntercambio = incluirEnIntercambio ? $", CAST(CASE WHEN {ArticuloDisponible} THEN 0 ELSE 1 END AS bit) AS EnIntercambio" : "";
            string query = $@"SELECT {top}a.IdArticulos, a.Nombre, e.Nombre AS Estado, COALESCE(NULLIF(a.Ubicacion, ''), u.Barrio) AS Barrio,
                    (SELECT TOP 1 i.Ruta FROM Imagenes i WHERE i.IdArticulos = a.IdArticulos ORDER BY i.IdImagenes) AS Imagen,
                    a.IdUsuarios, a.IdCategorias, a.IdCategoriaACambio{enIntercambio}
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
                pComprometidos = EstadosComprometidos,
                pRealizado = EstadosIntercambios.Realizado
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
            string query = $@"SELECT COUNT(*)
                FROM Articulos a
                WHERE a.IdUsuarios = @pIdUsuario AND {ArticuloNoIntercambiado}";
            return connection.ExecuteScalar<int>(query, new
            {
                pIdUsuario = idUsuario,
                pRealizado = EstadosIntercambios.Realizado
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

    private static string? PatronBusqueda(string? busqueda) =>
        string.IsNullOrWhiteSpace(busqueda) ? null : EscaparLike(busqueda.Trim());

    private static string EscaparLike(string texto) =>
        texto.Replace("[", "[[]").Replace("%", "[%]").Replace("_", "[_]");

}
