using Dapper;
using Microsoft.Data.SqlClient;
using System.Data;
using Swappit.Models.ViewModels;

namespace Swappit.Models;

public static class ChatBD
{
    private static string _connectionString = //@"Server=localhost; DataBase=Base_De_Datos_Swappit; Integrated Security=True; TrustServerCertificate=True;";
    @"Server=.\SQLEXPRESS;Database=Base_De_Datos_Swappit;Integrated Security=True;TrustServerCertificate=True;";

    // ---------- Chat ----------

    private const string ParteDelIntercambio = @"EXISTS (SELECT 1 FROM Intercambios ip
        WHERE ip.IdIntercambios = @pIdIntercambio AND (ip.IdUsuarios1 = @pIdUsuario OR ip.IdUsuarios2 = @pIdUsuario))";

    public static List<ConversacionViewModel> GetResumenesChat(int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = @"SELECT i.IdIntercambios AS IdIntercambio, ult.Texto AS UltimoTexto, ult.FechaEnviado AS UltimaFecha,
                    CAST(CASE WHEN ult.IdUsuariosManda = @pIdUsuario THEN 1 ELSE 0 END AS bit) AS UltimoEsMio,
                    (SELECT COUNT(*) FROM Mensajes m
                        WHERE m.IdIntercambio = i.IdIntercambios AND m.IdUsuariosManda <> @pIdUsuario AND m.fueVisto = 0) AS NoLeidos
                FROM Intercambios i
                CROSS APPLY (SELECT TOP 1 m.Texto, m.FechaEnviado, m.IdUsuariosManda FROM Mensajes m
                    WHERE m.IdIntercambio = i.IdIntercambios ORDER BY m.IdMensajes DESC) ult
                WHERE i.IdUsuarios1 = @pIdUsuario OR i.IdUsuarios2 = @pIdUsuario";
            return connection.Query<ConversacionViewModel>(query, new { pIdUsuario = idUsuario }).ToList();
        }
    }

    public static List<Mensajes> GetMensajes(int idIntercambio, int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = $@"SELECT IdMensajes, Texto, fueVisto, FechaEnviado, FechaRecibido, IdUsuariosManda, IdIntercambio
                FROM Mensajes
                WHERE IdIntercambio = @pIdIntercambio AND {ParteDelIntercambio}
                ORDER BY IdMensajes";
            return connection.Query<Mensajes>(query, new { pIdIntercambio = idIntercambio, pIdUsuario = idUsuario }).ToList();
        }
    }

    public static bool EnviarMensaje(int idIntercambio, int idUsuario, string texto, List<NotificacionCreada>? creadas = null)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            connection.Open();
            using (SqlTransaction transaccion = connection.BeginTransaction())
            {
                string query = @"DECLARE @idOtro int;
                    SELECT @idOtro = CASE WHEN i.IdUsuarios1 = @pIdUsuario THEN i.IdUsuarios2 ELSE i.IdUsuarios1 END
                    FROM Intercambios i
                    INNER JOIN EstadosIntercambios e ON e.IdEstadosIntercambios = i.IdEstado
                    WHERE i.IdIntercambios = @pIdIntercambio AND (i.IdUsuarios1 = @pIdUsuario OR i.IdUsuarios2 = @pIdUsuario)
                        AND (e.Nombre = @pAceptado
                            OR (e.Nombre = @pPendiente AND (i.IdUsuarios2 = @pIdUsuario
                                OR EXISTS (SELECT 1 FROM Mensajes mr WHERE mr.IdIntercambio = i.IdIntercambios AND mr.IdUsuariosManda = i.IdUsuarios2))));
                    IF @idOtro IS NOT NULL
                        INSERT INTO Mensajes (Texto, fueVisto, FechaEnviado, FechaRecibido, IdUsuariosManda, IdIntercambio)
                        VALUES (@pTexto, 0, GETDATE(), NULL, @pIdUsuario, @pIdIntercambio);
                    SELECT @idOtro;";
                int? idOtro = connection.QueryFirstOrDefault<int?>(query, new
                {
                    pIdIntercambio = idIntercambio,
                    pIdUsuario = idUsuario,
                    pTexto = texto,
                    pPendiente = EstadosIntercambios.Pendiente,
                    pAceptado = EstadosIntercambios.Aceptado
                }, transaccion);

                List<NotificacionCreada> nuevas = new List<NotificacionCreada>();
                if (idOtro.HasValue)
                {
                    CrearNotificacion(connection, transaccion, nuevas, idOtro.Value, idIntercambio, TipoNotificaciones.MensajeNuevo,
                        siNoHayOtraSinLeer: true);
                }

                transaccion.Commit();
                creadas?.AddRange(nuevas);
                return idOtro.HasValue;
            }
        }
    }

    public static void MarcarMensajesVistos(int idIntercambio, int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = $@"UPDATE Mensajes SET fueVisto = 1, FechaRecibido = GETDATE()
                WHERE IdIntercambio = @pIdIntercambio AND IdUsuariosManda <> @pIdUsuario AND fueVisto = 0 AND {ParteDelIntercambio};
                UPDATE n SET n.Leida = 1
                FROM Notificaciones n
                INNER JOIN TipoNotificaciones t ON t.Id = n.IdTipoNotificacion
                WHERE n.IdUsuario = @pIdUsuario AND n.IdIntercambio = @pIdIntercambio AND t.Nombre = @pTipo AND n.Leida = 0";
            connection.Execute(query, new { pIdIntercambio = idIntercambio, pIdUsuario = idUsuario, pTipo = TipoNotificaciones.MensajeNuevo });
        }
    }

    // ---------- Interacciones y favoritos ----------


}
