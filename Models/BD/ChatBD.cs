using Dapper;
using Microsoft.Data.SqlClient;
using System.Data;
using Swappit.Models.ViewModels;

namespace Swappit.Models;

public static class ChatBD
{
    public static List<ConversacionViewModel> GetResumenesChat(int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.Query<ConversacionViewModel>("GetResumenesChat",
                new { idUsuario },
                commandType: CommandType.StoredProcedure).AsList();
        }
    }

    public static int ContarMensajesNoLeidos(int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.ExecuteScalar<int>("ContarMensajesNoLeidos",
                new { idUsuario },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static List<Mensajes> GetMensajes(int idIntercambio, int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.Query<Mensajes>("GetMensajes",
                new { idIntercambio, idUsuario },
                commandType: CommandType.StoredProcedure).AsList();
        }
    }

    public static bool EnviarMensaje(int idIntercambio, int idUsuario, string texto, List<NotificacionCreada>? creadas = null)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            using (SqlMapper.GridReader resultado = connection.QueryMultiple("EnviarMensaje",
                new { idIntercambio, idUsuario, texto },
                commandType: CommandType.StoredProcedure))
            {
                bool enviado = resultado.ReadSingle<bool>();
                NotificacionesBD.LeerCreadas(resultado, creadas);
                return enviado;
            }
        }
    }

    public static void MarcarMensajesVistos(int idIntercambio, int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            connection.Execute("MarcarMensajesVistos",
                new { idIntercambio, idUsuario },
                commandType: CommandType.StoredProcedure);
        }
    }
}
