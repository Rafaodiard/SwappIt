using Dapper;
using Microsoft.Data.SqlClient;
using System.Data;
using Swappit.Models.ViewModels;

namespace Swappit.Models;

public static class RecomendacionesBD
{
    private static string _connectionString = //@"Server=localhost; DataBase=Base_De_Datos_Swappit; Integrated Security=True; TrustServerCertificate=True;";
    @"Server=.\SQLEXPRESS;Database=Base_De_Datos_Swappit;Integrated Security=True;TrustServerCertificate=True;";

    private const string ArticuloDisponible = @"NOT EXISTS (SELECT 1 FROM ArticulosIntercambios aic
        INNER JOIN Intercambios ic ON ic.IdIntercambios = aic.IdIntercambio
        INNER JOIN EstadosIntercambios eic ON eic.IdEstadosIntercambios = ic.IdEstado
        WHERE eic.Nombre IN @pComprometidos AND aic.IdArticulo = a.IdArticulos)";
    private static readonly string[] EstadosComprometidos = { EstadosIntercambios.Aceptado, EstadosIntercambios.Realizado };

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
                INNER JOIN ArticulosIntercambios aip ON aip.IdIntercambio = ic.IdIntercambios
                INNER JOIN Articulos ap ON ap.IdArticulos = aip.IdArticulo AND ap.IdUsuarios = ic.IdUsuarios2
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


}
