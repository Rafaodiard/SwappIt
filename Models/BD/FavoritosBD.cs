using Dapper;
using Microsoft.Data.SqlClient;
using System.Data;
using Swappit.Models.ViewModels;

namespace Swappit.Models;

public static class FavoritosBD
{
    public static List<int> GetIdsFavoritos(int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.Query<int>("GetIdsFavoritos",
                new { idUsuario },
                commandType: CommandType.StoredProcedure).AsList();
        }
    }

    public static List<ArticuloCardViewModel> GetFavoritos(int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.Query<ArticuloCardViewModel>("GetFavoritos",
                new { idUsuario },
                commandType: CommandType.StoredProcedure).AsList();
        }
    }

    public static bool? AlternarFavorito(int idUsuario, int idArticulo)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.QuerySingle<bool?>("AlternarFavorito",
                new { idUsuario, idArticulo },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static void ImportarFavoritos(int idUsuario, IReadOnlyCollection<int> idsArticulos)
    {
        if (idsArticulos.Count == 0) return;
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            connection.Execute("ImportarFavoritos",
                new { idUsuario, idsArticulos = ConexionBD.ListaDeIds(idsArticulos) },
                commandType: CommandType.StoredProcedure);
        }
    }
}
