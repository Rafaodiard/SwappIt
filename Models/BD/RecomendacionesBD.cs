using Dapper;
using Microsoft.Data.SqlClient;
using System.Data;
using Swappit.Models.ViewModels;

namespace Swappit.Models;

public static class RecomendacionesBD
{
    public static int RegistrarVista(int idUsuario, int idArticulo)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.QuerySingle<int>("RegistrarVista",
                new { idUsuario, idArticulo },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static void GuardarSegundosVista(int idInteraccion, int idUsuario, int segundos)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            connection.Execute("GuardarSegundosVista",
                new { idInteraccion, idUsuario, segundos },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static void RegistrarBusqueda(int idUsuario, string? texto, IReadOnlyCollection<int> categorias, int minutosSinRepetir)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            connection.Execute("RegistrarBusqueda",
                new { idUsuario, texto, categorias = ConexionBD.ListaDeIds(categorias), minutosSinRepetir },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static List<SenalGusto> GetSenalesGustos(IReadOnlyCollection<int> idsUsuarios, DateTime desde)
    {
        if (idsUsuarios.Count == 0) return new List<SenalGusto>();
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.Query<SenalGusto>("GetSenalesGustos",
                new { idsUsuarios = ConexionBD.ListaDeIds(idsUsuarios), desde },
                commandType: CommandType.StoredProcedure).AsList();
        }
    }

    public static List<PopularidadArticulo> GetPopularidad()
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.Query<PopularidadArticulo>("GetPopularidad", commandType: CommandType.StoredProcedure).AsList();
        }
    }
}
