using Dapper;
using Microsoft.Data.SqlClient;
using System.Data;
using Swappit.Models.ViewModels;

namespace Swappit.Models;

public static class UsuariosBD
{
    private static string _connectionString = //@"Server=localhost; DataBase=Base_De_Datos_Swappit; Integrated Security=True; TrustServerCertificate=True;";
    @"Server=.\SQLEXPRESS;Database=Base_De_Datos_Swappit;Integrated Security=True;TrustServerCertificate=True;";

    public static Usuarios? GetUsuarioByMail(string mail)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            return connection.QueryFirstOrDefault<Usuarios>("GetUsuarioByMail",
                new { Mail = mail },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static void ActualizarContrasena(int idUsuario, string contrasenaHash)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            connection.Execute("ActualizarContrasena",
                new { idUsuario, contrasenaHash },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static bool UsuarioExiste(string mail)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            return connection.ExecuteScalar<int>("UsuarioExiste",
                new { mail },
                commandType: CommandType.StoredProcedure) > 0;
        }
    }

    public static Usuarios? GetUsuarioById(int id)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            return connection.QueryFirstOrDefault<Usuarios>("GetUsuarioById",
                new { id },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static Provincias? GetProvinciaById(int id)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            return connection.QueryFirstOrDefault<Provincias>("GetProvinciaById",
                new { id },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static List<Provincias> GetProvincias()
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            return connection.Query<Provincias>("GetProvincias", commandType: CommandType.StoredProcedure).ToList();
        }
    }

    public static void Register(Usuarios u)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            string query = @"INSERT INTO Usuarios (Nombre, Apellido, Usuario, Mail, Telefono, Contraseña, Barrio, [Fecha nacimiento], Edad, IdProvincias)
                VALUES (@Nombre, @Apellido, @Usuario, @Mail, @Telefono, @Contraseña, @Barrio, @FechaNacimiento, @Edad, @IdProvincias)";
            connection.Execute(query, u);
        }
    }

    public static void UpdateUsuario(Usuarios u)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
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
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            return connection.QueryFirstOrDefault<string>("GetFotoUsuario",
                new { idUsuario },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static void GuardarFotoUsuario(int idUsuario, string ruta)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            connection.Execute("GuardarFotoUsuario",
                new { idUsuario, ruta },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static void BorrarFotoUsuario(int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            connection.Execute("BorrarFotoUsuario",
                new { idUsuario },
                commandType: CommandType.StoredProcedure);
        }
    }


}
