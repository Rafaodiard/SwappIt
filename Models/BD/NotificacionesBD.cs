using Dapper;
using Microsoft.Data.SqlClient;
using System.Data;
using Swappit.Models.ViewModels;

namespace Swappit.Models;

public static class NotificacionesBD
{
    public static DatosMailNotificacion? GetDatosMailNotificacion(int idUsuario, int idIntercambio, int? idCambio = null)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            using (SqlMapper.GridReader resultado = connection.QueryMultiple("GetDatosMailNotificacion",
                new { idUsuario, idIntercambio, idCambio },
                commandType: CommandType.StoredProcedure))
            {
                DatosMailNotificacion? datos = resultado.ReadFirstOrDefault<DatosMailNotificacion>();
                if (datos == null)
                {
                    return null;
                }

                datos.MisArticulos = resultado.Read<string>().AsList();
                datos.SusArticulos = resultado.Read<string>().AsList();

                DatosMailNotificacion? cambio = resultado.ReadFirstOrDefault<DatosMailNotificacion>();
                if (cambio != null)
                {
                    datos.CambioTipo = cambio.CambioTipo;
                    datos.CambioArticulos = cambio.CambioArticulos;
                }
                return datos;
            }
        }
    }

    public static List<NotificacionViewModel> GetNotificaciones(int idUsuario, int cantidad)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.Query<NotificacionViewModel>("GetNotificaciones",
                new { idUsuario, cantidad },
                commandType: CommandType.StoredProcedure).AsList();
        }
    }

    public static int GetCantidadNotificacionesNoLeidas(int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.ExecuteScalar<int>("GetCantidadNotificacionesNoLeidas",
                new { idUsuario },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static NotificacionViewModel? MarcarNotificacionLeida(int idNotificacion, int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.QueryFirstOrDefault<NotificacionViewModel>("MarcarNotificacionLeida",
                new { idNotificacion, idUsuario },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static void MarcarNotificacionesLeidas(int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            connection.Execute("MarcarNotificacionesLeidas",
                new { idUsuario },
                commandType: CommandType.StoredProcedure);
        }
    }

    internal static void LeerCreadas(SqlMapper.GridReader resultado, List<NotificacionCreada>? creadas)
    {
        List<NotificacionCreada> nuevas = resultado.Read<NotificacionCreada>().AsList();
        if (creadas != null)
        {
            creadas.AddRange(nuevas);
        }
    }
}
