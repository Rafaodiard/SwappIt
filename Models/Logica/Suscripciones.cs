using System.Globalization;
using Swappit.Models.ViewModels;

namespace Swappit.Models;

public static class Suscripciones
{
    private static readonly NumberFormatInfo FormatoPesos = new NumberFormatInfo { NumberGroupSeparator = "." };

    public static List<PlanViewModel> Planes()
    {
        List<PlanViewModel> planes = PlanesBD.GetPlanes();
        foreach (PlanViewModel plan in planes)
        {
            plan.Beneficios.Add(plan.MaxArticulos == null ? "Publicá todos los artículos que quieras" : $"Publicá hasta {plan.MaxArticulos} artículos a la vez");
            plan.Beneficios.Add(plan.MaxIntercambios == null ? "Proponé todos los intercambios que quieras" : $"Proponé hasta {plan.MaxIntercambios} intercambios a la vez");
        }
        foreach (BeneficioPlan beneficio in PlanesBD.GetBeneficiosPlanes())
        {
            Buscar(planes, beneficio.IdPlan)?.Beneficios.Add(beneficio.Texto);
        }
        return planes;
    }

    public static PlanViewModel? Buscar(List<PlanViewModel> planes, int? idPlan)
    {
        foreach (PlanViewModel plan in planes)
        {
            if (plan.Id == idPlan)
            {
                return plan;
            }
        }
        return null;
    }

    public static int? PlanElegido(List<PlanViewModel> planes, int? pedido)
    {
        PlanViewModel? plan = Buscar(planes, pedido);
        if (plan == null && planes.Count > 0)
        {
            plan = planes[0];
        }
        return plan?.Id;
    }

    public static string? ValidarPlan(List<PlanViewModel> planes, int? idPlan)
    {
        if (idPlan == null || Buscar(planes, idPlan) != null)
        {
            return null;
        }
        return "Elegí un plan de la lista";
    }

    public static int PlanAlRegistrarse(List<PlanViewModel> planes, int idPlanElegido)
    {
        PlanViewModel? elegido = Buscar(planes, idPlanElegido);
        if (elegido != null && elegido.EsGratis)
        {
            return elegido.Id;
        }
        foreach (PlanViewModel plan in planes)
        {
            if (plan.EsGratis)
            {
                return plan.Id;
            }
        }
        return idPlanElegido;
    }

    public static PlanViewModel? PlanParaPagar(List<PlanViewModel> planes, int idPlan)
    {
        PlanViewModel? plan = Buscar(planes, idPlan);
        return plan != null && !plan.EsGratis ? plan : null;
    }

    public static Resultado CambiarPlan(Usuarios usuario, int idPlan)
    {
        PlanViewModel? plan = Buscar(Planes(), idPlan);
        if (plan == null)
        {
            return Resultado.ConError("Ese plan no existe.");
        }
        if (usuario.IdPlan == idPlan)
        {
            return Resultado.ConMensaje($"Ya tenés el plan {plan.Nombre}.");
        }
        if (!PlanesBD.CambiarPlanUsuario(usuario.IdUsuarios, idPlan))
        {
            return Resultado.ConError("No pudimos cambiar tu plan. Probá de nuevo en un rato.");
        }
        return Resultado.ConMensaje($"Listo, ahora tenés el plan {plan.Nombre}.");
    }

    public static bool AlcanzoLimite(int usados, int? maximo)
    {
        return maximo != null && usados >= maximo;
    }

    public static string TextoUso(int usados, int? maximo)
    {
        return maximo == null ? $"{usados} · sin límite" : $"{usados} de {maximo}";
    }

    public static int PorcentajeUso(int usados, int maximo)
    {
        if (maximo <= 0)
        {
            return 100;
        }
        return Math.Min(100, usados * 100 / maximo);
    }

    public static string Precio(int precioMensual)
    {
        return "$" + precioMensual.ToString("#,0", FormatoPesos);
    }
}
