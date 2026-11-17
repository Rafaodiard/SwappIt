using Dapper;
using Microsoft.Data.SqlClient;
using System.Data;
using Swappit.Models.ViewModels;

namespace Swappit.Models;

public static class NotificacionesBD
{
    private static string _connectionString = //@"Server=localhost; DataBase=Base_De_Datos_Swappit; Integrated Security=True; TrustServerCertificate=True;";
    @"Server=.\SQLEXPRESS;Database=Base_De_Datos_Swappit;Integrated Security=True;TrustServerCertificate=True;";

    public static DatosMailNotificacion? GetDatosMailNotificacion(int idUsuario, int idIntercambio, int? idCambio = null)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = @"SELECT d.Mail, d.Nombre, o.Nombre AS OtroNombre
                FROM Intercambios i
                INNER JOIN Usuarios d ON d.IdUsuarios = @pIdUsuario
                INNER JOIN Usuarios o ON o.IdUsuarios = CASE WHEN i.IdUsuarios1 = @pIdUsuario THEN i.IdUsuarios2 ELSE i.IdUsuarios1 END
                WHERE i.IdIntercambios = @pIdIntercambio AND (i.IdUsuarios1 = @pIdUsuario OR i.IdUsuarios2 = @pIdUsuario)";
            DatosMailNotificacion? datos = connection.QueryFirstOrDefault<DatosMailNotificacion>(query, new { pIdUsuario = idUsuario, pIdIntercambio = idIntercambio });
            if (datos == null)
            {
                return null;
            }

            string queryArticulos = @"SELECT a.Nombre, CAST(CASE WHEN a.IdUsuarios = @pIdUsuario THEN 1 ELSE 0 END AS bit) AS EsMio
                FROM ArticulosIntercambios ai
                INNER JOIN Articulos a ON a.IdArticulos = ai.IdArticulo
                WHERE ai.IdIntercambio = @pIdIntercambio
                ORDER BY ai.Id";
            var articulos = connection.Query<(string Nombre, bool EsMio)>(queryArticulos, new { pIdUsuario = idUsuario, pIdIntercambio = idIntercambio }).ToList();
            datos.MisArticulos = articulos.Where(a => a.EsMio).Select(a => a.Nombre).ToList();
            datos.SusArticulos = articulos.Where(a => !a.EsMio).Select(a => a.Nombre).ToList();

            if (idCambio.HasValue)
            {
                string queryCambio = $@"SELECT tcn.Nombre, artcambio.Nombres
                    FROM CambiosIntercambios cn
                    INNER JOIN TipoCambios tcn ON tcn.Id = cn.IdTipoCambio
                    {ArticulosDelCambio}
                    WHERE cn.Id = @pIdCambio AND cn.IdIntercambio = @pIdIntercambio";
                var cambio = connection.Query<(string Tipo, string Nombres)>(queryCambio,
                    new { pIdCambio = idCambio.Value, pIdIntercambio = idIntercambio, pAgregar = TipoCambios.Agregar }).ToList();
                if (cambio.Count > 0)
                {
                    datos.CambioTipo = cambio[0].Tipo;
                    datos.CambioArticulos = cambio[0].Nombres;
                }
            }
            return datos;
        }
    }

    public static List<NotificacionViewModel> GetNotificaciones(int idUsuario, int cantidad)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = $@"SELECT TOP (@pCantidad) n.Id, t.Nombre AS Tipo, n.Leida, n.Fecha, n.IdIntercambio,
                    u.Nombre AS OtroNombre, a.Nombre AS ArticuloNombre, tcn.Nombre AS CambioTipo, artcambio.Nombres AS CambioArticulos
                FROM Notificaciones n
                INNER JOIN TipoNotificaciones t ON t.Id = n.IdTipoNotificacion
                INNER JOIN Intercambios i ON i.IdIntercambios = n.IdIntercambio
                INNER JOIN Usuarios u ON u.IdUsuarios = CASE WHEN i.IdUsuarios1 = n.IdUsuario THEN i.IdUsuarios2 ELSE i.IdUsuarios1 END
                CROSS APPLY (SELECT TOP 1 ap.Nombre FROM ArticulosIntercambios ai
                    INNER JOIN Articulos ap ON ap.IdArticulos = ai.IdArticulo
                    WHERE ai.IdIntercambio = i.IdIntercambios AND ap.IdUsuarios = i.IdUsuarios2
                    ORDER BY ai.Id) a
                LEFT JOIN CambiosIntercambios cn ON cn.Id = n.IdCambio
                LEFT JOIN TipoCambios tcn ON tcn.Id = cn.IdTipoCambio
                {ArticulosDelCambio}
                WHERE n.IdUsuario = @pIdUsuario
                ORDER BY n.Fecha DESC, n.Id DESC";
            return connection.Query<NotificacionViewModel>(query, new { pIdUsuario = idUsuario, pCantidad = cantidad, pAgregar = TipoCambios.Agregar }).ToList();
        }
    }

    public static int GetCantidadNotificacionesNoLeidas(int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            return connection.ExecuteScalar<int>("GetCantidadNotificacionesNoLeidas",
                new { idUsuario },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static NotificacionViewModel? MarcarNotificacionLeida(int idNotificacion, int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = @"UPDATE n SET n.Leida = 1
                OUTPUT INSERTED.Id, INSERTED.IdIntercambio, t.Nombre AS Tipo
                FROM Notificaciones n
                INNER JOIN TipoNotificaciones t ON t.Id = n.IdTipoNotificacion
                WHERE n.Id = @pId AND n.IdUsuario = @pIdUsuario";
            return connection.QueryFirstOrDefault<NotificacionViewModel>(query, new { pId = idNotificacion, pIdUsuario = idUsuario });
        }
    }

    public static void MarcarNotificacionesLeidas(int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            connection.Execute("MarcarNotificacionesLeidas",
                new { idUsuario },
                commandType: CommandType.StoredProcedure);
        }
    }


}
