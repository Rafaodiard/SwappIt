using Dapper;
using Microsoft.Data.SqlClient;
using System.Data;
using Swappit.Models.ViewModels;

namespace Swappit.Models;

public static class PlanesBD
{
    public static List<PlanViewModel> GetPlanes()
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.Query<PlanViewModel>("GetPlanes", commandType: CommandType.StoredProcedure).AsList();
        }
    }

    public static PlanViewModel? GetPlanDeUsuario(int idUsuario)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.QueryFirstOrDefault<PlanViewModel>("GetPlanDeUsuario",
                new { idUsuario },
                commandType: CommandType.StoredProcedure);
        }
    }

    public static List<BeneficioPlan> GetBeneficiosPlanes()
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.Query<BeneficioPlan>("GetBeneficiosPlanes", commandType: CommandType.StoredProcedure).AsList();
        }
    }

    public static bool CambiarPlanUsuario(int idUsuario, int idPlan)
    {
        using (SqlConnection connection = new SqlConnection(ConexionBD.ConnectionString))
        {
            return connection.ExecuteScalar<int>("CambiarPlanUsuario",
                new { idUsuario, idPlan },
                commandType: CommandType.StoredProcedure) > 0;
        }
    }
}
