using Dapper;
using Microsoft.Data.SqlClient;
using System.Data;
using Swappit.Models.ViewModels;

namespace Swappit.Models;

public static class CalificacionesBD
{
    public static bool CalificarIntercambio(int idIntercambio, int idUsuario, int puntaje, string? comentario,
        List<NotificacionCreada>? creadas = null)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            using (SqlMapper.GridReader resultado = connection.QueryMultiple("CalificarIntercambio",
                new { idIntercambio, idUsuario, puntaje, comentario },
                commandType: CommandType.StoredProcedure))
            {
                bool calificado = resultado.ReadSingle<bool>();
                NotificacionesBD.LeerCreadas(resultado, creadas);
                return calificado;
            }
        }
    }

    public static List<CalificacionViewModel> GetCalificacionesIntercambio(int idIntercambio, int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.Query<CalificacionViewModel>("GetCalificacionesIntercambio",
                new { idIntercambio, idUsuario },
                commandType: CommandType.StoredProcedure).AsList();
        }
    }

    public static List<CalificacionViewModel> GetCalificacionesUsuario(int idUsuario, int cantidad)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.Query<CalificacionViewModel>("GetCalificacionesUsuario",
                new { idUsuario, cantidad },
                commandType: CommandType.StoredProcedure).AsList();
        }
    }

    public static ResumenReputacion GetReputacionUsuario(int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.QuerySingle<ResumenReputacion>("GetReputacionUsuario",
                new { idUsuario },
                commandType: CommandType.StoredProcedure);
        }
    }
}
