using Dapper;
using Microsoft.Data.SqlClient;
using System.Data;
using Swappit.Models.ViewModels;

namespace Swappit.Models;

public static class IntercambiosBD
{
    public static int ContarIntercambiosActivos(int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.ExecuteScalar<int>("ContarIntercambiosActivos",
                new { idUsuario },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static List<IntercambioViewModel> GetIntercambios(int idUsuario, string? estado = null, bool enCurso = false,
        bool conChat = false, int? cantidad = null)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.Query<IntercambioViewModel>("GetIntercambios",
                new { idUsuario, estado, enCurso, conChat, cantidad },
                commandType: CommandType.StoredProcedure).AsList();
        }
    }

    public static IntercambioViewModel? GetIntercambio(int idIntercambio, int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.QueryFirstOrDefault<IntercambioViewModel>("GetIntercambios",
                new { idUsuario, idIntercambio },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static List<CantidadPorEstado> ContarIntercambiosPorEstado(int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.Query<CantidadPorEstado>("ContarIntercambiosPorEstado",
                new { idUsuario },
                commandType: CommandType.StoredProcedure).AsList();
        }
    }

    public static int? GetIdPropuestaEnCurso(int idUsuario, int idArticuloPedido)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.QueryFirstOrDefault<int?>("GetIdPropuestaEnCurso",
                new { idUsuario, idArticulo = idArticuloPedido },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static bool ArticuloComprometido(int idArticulo)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.QueryFirstOrDefault<bool>("ArticuloComprometido",
                new { idArticulo },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static bool IntercambioConArticuloComprometido(int idIntercambio)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.QuerySingle<bool>("IntercambioConArticuloComprometido",
                new { idIntercambio },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static List<ArticuloCardViewModel> GetArticulosDeIntercambio(int idIntercambio, int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.Query<ArticuloCardViewModel>("GetArticulosDeIntercambio",
                new { idIntercambio, idUsuario },
                commandType: CommandType.StoredProcedure).AsList();
        }
    }

    public static int? ProponerIntercambio(int idUsuario, IReadOnlyCollection<int> idsOfrecidos, int idDueno, int idArticuloPedido,
        List<NotificacionCreada>? creadas = null)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            using (SqlMapper.GridReader resultado = connection.QueryMultiple("ProponerIntercambio",
                new { idUsuario, idsOfrecidos = ConexionBD.ListaDeIds(idsOfrecidos), idDueno, idArticuloPedido },
                commandType: CommandType.StoredProcedure))
            {
                int? idIntercambio = resultado.ReadSingle<int?>();
                NotificacionesBD.LeerCreadas(resultado, creadas);
                return idIntercambio;
            }
        }
    }

    public static bool CambiarEstadoIntercambio(int idIntercambio, int idUsuario, string estadoActual, string estadoNuevo,
        bool soloQuienRecibe, string? tipoNotificacion = null, List<NotificacionCreada>? creadas = null, int? ultimoCambioVisto = null)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            using (SqlMapper.GridReader resultado = connection.QueryMultiple("CambiarEstadoIntercambio",
                new { idIntercambio, idUsuario, estadoActual, estadoNuevo, soloQuienRecibe, tipoNotificacion, ultimoCambioVisto },
                commandType: CommandType.StoredProcedure))
            {
                bool cambiado = resultado.ReadSingle<bool>();
                NotificacionesBD.LeerCreadas(resultado, creadas);
                return cambiado;
            }
        }
    }

    public static bool CancelarIntercambio(int idIntercambio, int idUsuario, List<NotificacionCreada>? creadas = null)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            using (SqlMapper.GridReader resultado = connection.QueryMultiple("CancelarIntercambio",
                new { idIntercambio, idUsuario },
                commandType: CommandType.StoredProcedure))
            {
                bool cancelado = resultado.ReadSingle<bool>();
                NotificacionesBD.LeerCreadas(resultado, creadas);
                return cancelado;
            }
        }
    }

    public static int ContarPendientesDeArticulos(int idIntercambio)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.ExecuteScalar<int>("ContarPendientesDeArticulos",
                new { idIntercambio },
                commandType: CommandType.StoredProcedure);
        }
    }

    // ---------- Cambios de un intercambio ----------

    public static List<CambioIntercambioViewModel> GetCambiosIntercambio(int idIntercambio, int idUsuario, bool soloPendientes = false)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.Query<CambioIntercambioViewModel>("GetCambiosIntercambio",
                new { idIntercambio, idUsuario, soloPendientes },
                commandType: CommandType.StoredProcedure).AsList();
        }
    }

    public static int ContarCambiosPendientes(int idIntercambio, int idUsuario, bool soloDelOtro = false)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.ExecuteScalar<int>("ContarCambiosPendientes",
                new { idIntercambio, idUsuario, soloDelOtro },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static int GetUltimoCambio(int idIntercambio)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.ExecuteScalar<int>("GetUltimoCambio",
                new { idIntercambio },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static int AgregarArticulos(int idIntercambio, int idUsuario, IReadOnlyCollection<int> idsArticulos,
        List<NotificacionCreada>? creadas = null)
    {
        if (idsArticulos.Count == 0)
        {
            return 0;
        }

        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            using (SqlMapper.GridReader resultado = connection.QueryMultiple("AgregarArticulos",
                new { idIntercambio, idUsuario, idsArticulos = ConexionBD.ListaDeIds(idsArticulos) },
                commandType: CommandType.StoredProcedure))
            {
                int agregados = resultado.ReadSingle<int>();
                NotificacionesBD.LeerCreadas(resultado, creadas);
                return agregados;
            }
        }
    }

    public static bool PedirArticulo(int idIntercambio, int idUsuario, int idArticulo, List<NotificacionCreada>? creadas = null)
    {
        return CrearPedido(idIntercambio, idUsuario, idArticulo, TipoCambios.Pedir, creadas);
    }

    public static bool PedirSacarArticulo(int idIntercambio, int idUsuario, int idArticulo, List<NotificacionCreada>? creadas = null)
    {
        return CrearPedido(idIntercambio, idUsuario, idArticulo, TipoCambios.Sacar, creadas);
    }

    private static bool CrearPedido(int idIntercambio, int idUsuario, int idArticulo, string tipo, List<NotificacionCreada>? creadas)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            using (SqlMapper.GridReader resultado = connection.QueryMultiple("CrearPedido",
                new { idIntercambio, idUsuario, idArticulo, tipo },
                commandType: CommandType.StoredProcedure))
            {
                bool creado = resultado.ReadSingle<bool>();
                NotificacionesBD.LeerCreadas(resultado, creadas);
                return creado;
            }
        }
    }

    public static bool ResponderCambio(int idCambio, int idUsuario, bool aceptar, List<NotificacionCreada>? creadas = null)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            using (SqlMapper.GridReader resultado = connection.QueryMultiple("ResponderCambio",
                new { idCambio, idUsuario, aceptar },
                commandType: CommandType.StoredProcedure))
            {
                bool respondido = resultado.ReadSingle<bool>();
                NotificacionesBD.LeerCreadas(resultado, creadas);
                return respondido;
            }
        }
    }

    public static bool CancelarCambio(int idCambio, int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.QuerySingle<bool>("CancelarCambio",
                new { idCambio, idUsuario },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static List<EstadosIntercambios> GetEstadosIntercambios()
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.Query<EstadosIntercambios>("GetEstadosIntercambios", commandType: CommandType.StoredProcedure).AsList();
        }
    }
}
