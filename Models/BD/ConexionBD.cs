namespace Swappit.Models;

public static class ConexionBD
{
    public const string ConnectionString = //@"Server=localhost;Database=Base_De_Datos_Swappit;Integrated Security=True;TrustServerCertificate=True;";
    @"Server=.\SQLEXPRESS;Database=Base_De_Datos_Swappit;Integrated Security=True;TrustServerCertificate=True;";

    public static string? ListaDeIds(IReadOnlyCollection<int>? ids)
    {
        if (ids == null || ids.Count == 0)
        {
            return null;
        }
        return string.Join(",", ids);
    }
}
