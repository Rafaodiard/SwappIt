using Dapper;
using Microsoft.Data.SqlClient;
using System.Data;
using Swappit.Models.ViewModels;

namespace Swappit.Models;

public static class FavoritosBD
{
    private static string _connectionString = //@"Server=localhost; DataBase=Base_De_Datos_Swappit; Integrated Security=True; TrustServerCertificate=True;";
    @"Server=.\SQLEXPRESS;Database=Base_De_Datos_Swappit;Integrated Security=True;TrustServerCertificate=True;";

    private const string ArticuloDisponible = @"NOT EXISTS (SELECT 1 FROM ArticulosIntercambios aic
        INNER JOIN Intercambios ic ON ic.IdIntercambios = aic.IdIntercambio
        INNER JOIN EstadosIntercambios eic ON eic.IdEstadosIntercambios = ic.IdEstado
        WHERE eic.Nombre IN @pComprometidos AND aic.IdArticulo = a.IdArticulos)";
    private static readonly string[] EstadosComprometidos = { EstadosIntercambios.Aceptado, EstadosIntercambios.Realizado };
    private const string IdTipo = "(SELECT Id FROM TipoInteracciones WHERE Nombre = @pTipo)";

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


}
