using Dapper;
using Microsoft.Data.SqlClient;
using System.Data;
using Swappit.Models.ViewModels;

namespace Swappit.Models;

public static class ArticulosBD
{
    internal static readonly string[] EstadosComprometidos = { EstadosIntercambios.Aceptado, EstadosIntercambios.Realizado };

    public static List<ArticuloCardViewModel> GetArticulosCatalogo(string? busqueda = null, int? cantidad = null,
        IReadOnlyCollection<int>? categorias = null, IReadOnlyCollection<int>? estados = null, int? idUsuario = null,
        int? excluirUsuario = null, int? excluirArticulo = null, int? fueraDeIntercambio = null,
        bool incluirEnIntercambio = false, string? orden = null)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.Query<ArticuloCardViewModel>("GetArticulosCatalogo",
                new
                {
                    busqueda = TextoBusqueda(busqueda),
                    cantidad,
                    categorias = ConexionBD.ListaDeIds(categorias),
                    estados = ConexionBD.ListaDeIds(estados),
                    idUsuario,
                    excluirUsuario,
                    excluirArticulo,
                    fueraDeIntercambio,
                    incluirEnIntercambio,
                    orden
                },
                commandType: CommandType.StoredProcedure).AsList();
        }
    }

    public static Articulos? GetArticuloById(int id)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.QueryFirstOrDefault<Articulos>("GetArticuloById",
                new { id },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static int PublicarArticulo(Articulos a, List<string> rutasFotos)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.QuerySingle<int>("PublicarArticulo",
                new
                {
                    nombre = a.Nombre,
                    descripcion = a.Descripcion,
                    idEstado = a.IdEstado,
                    idUsuario = a.IdUsuarios,
                    idCategoria = a.IdCategorias,
                    ubicacion = a.Ubicacion,
                    idCategoriaACambio = a.IdCategoriaACambio,
                    rutasFotos = string.Join("|", rutasFotos)
                },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static int ContarArticulosActivos(int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.ExecuteScalar<int>("ContarArticulosActivos",
                new { idUsuario },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static List<int> GetCategoriasDeUsuario(int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.Query<int>("GetCategoriasDeUsuario",
                new { idUsuario },
                commandType: CommandType.StoredProcedure).AsList();
        }
    }

    public static List<string> GetImagenesArticulo(int idArticulo)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.Query<string>("GetImagenesArticulo",
                new { idArticulo },
                commandType: CommandType.StoredProcedure).AsList();
        }
    }

    public static Categorias? GetCategoriaById(int id)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.QueryFirstOrDefault<Categorias>("GetCategoriaById",
                new { id },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static List<Categorias> GetCategorias()
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.Query<Categorias>("GetCategorias", commandType: CommandType.StoredProcedure).AsList();
        }
    }

    public static List<EstadosArticulos> GetEstadosArticulos()
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.Query<EstadosArticulos>("GetEstadosArticulos", commandType: CommandType.StoredProcedure).AsList();
        }
    }

    public static EstadosArticulos? GetEstadoArticuloById(int id)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.QueryFirstOrDefault<EstadosArticulos>("GetEstadoArticuloById",
                new { id },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static List<OpcionFiltroViewModel> GetFiltroCategorias(string? busqueda = null, int? excluirUsuario = null)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.Query<OpcionFiltroViewModel>("GetFiltroCategorias",
                new
                {
                    busqueda = TextoBusqueda(busqueda),
                    excluirUsuario,
                    comprometidos = string.Join(",", EstadosComprometidos)
                },
                commandType: CommandType.StoredProcedure).AsList();
        }
    }

    public static List<OpcionFiltroViewModel> GetFiltroEstados(string? busqueda = null, int? excluirUsuario = null)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.Query<OpcionFiltroViewModel>("GetFiltroEstados",
                new
                {
                    busqueda = TextoBusqueda(busqueda),
                    excluirUsuario,
                    comprometidos = string.Join(",", EstadosComprometidos)
                },
                commandType: CommandType.StoredProcedure).AsList();
        }
    }

    private static string? TextoBusqueda(string? busqueda) =>
        string.IsNullOrWhiteSpace(busqueda) ? null : busqueda.Trim();
}
