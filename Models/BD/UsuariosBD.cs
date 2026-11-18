using Dapper;
using Microsoft.Data.SqlClient;
using System.Data;
using Swappit.Models.ViewModels;

namespace Swappit.Models;

public static class UsuariosBD
{
    public static Usuarios? GetUsuarioByMail(string mail)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.QueryFirstOrDefault<Usuarios>("GetUsuarioByMail",
                new { Mail = mail },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static void ActualizarContrasena(int idUsuario, string contrasenaHash)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            connection.Execute("ActualizarContrasena",
                new { idUsuario, contrasenaHash },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static bool UsuarioExiste(string mail)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.ExecuteScalar<int>("UsuarioExiste",
                new { mail },
                commandType: CommandType.StoredProcedure) > 0;
        }
    }

    public static Usuarios? GetUsuarioById(int id)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.QueryFirstOrDefault<Usuarios>("GetUsuarioById",
                new { id },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static Provincias? GetProvinciaById(int id)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.QueryFirstOrDefault<Provincias>("GetProvinciaById",
                new { id },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static List<Provincias> GetProvincias()
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.Query<Provincias>("GetProvincias", commandType: CommandType.StoredProcedure).AsList();
        }
    }

    public static void Register(Usuarios u)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            connection.Execute("RegistrarUsuario",
                new
                {
                    nombre = u.Nombre,
                    apellido = u.Apellido,
                    usuario = u.Usuario,
                    mail = u.Mail,
                    telefono = u.Telefono,
                    contraseña = u.Contraseña,
                    barrio = u.Barrio,
                    fechaNacimiento = u.FechaNacimiento,
                    edad = u.Edad,
                    idProvincia = u.IdProvincias,
                    idPlan = u.IdPlan
                },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static void UpdateUsuario(Usuarios u)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            connection.Execute("UpdateUsuario",
                new
                {
                    idUsuario = u.IdUsuarios,
                    nombre = u.Nombre,
                    apellido = u.Apellido,
                    usuario = u.Usuario,
                    mail = u.Mail,
                    telefono = u.Telefono,
                    contraseña = u.Contraseña,
                    barrio = u.Barrio,
                    fechaNacimiento = u.FechaNacimiento,
                    edad = u.Edad,
                    idProvincia = u.IdProvincias,
                    descripcion = u.Descripcion
                },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static string? GetFotoUsuario(int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.QueryFirstOrDefault<string>("GetFotoUsuario",
                new { idUsuario },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static void GuardarFotoUsuario(int idUsuario, string ruta)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            connection.Execute("GuardarFotoUsuario",
                new { idUsuario, ruta },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static void BorrarFotoUsuario(int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            connection.Execute("BorrarFotoUsuario",
                new { idUsuario },
                commandType: CommandType.StoredProcedure);
        }
    }


}
