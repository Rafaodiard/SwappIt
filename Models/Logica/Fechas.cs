namespace Swappit.Models;

public static class Fechas
{
    public static int DiasDesde(DateTime fecha)
    {
        return (DateTime.Today - fecha.Date).Days;
    }

    public static string Hace(DateTime fecha)
    {
        TimeSpan paso = DateTime.Now - fecha;
        if (paso.TotalMinutes < 1) return "Recién";
        if (paso.TotalHours < 1) return $"Hace {(int)paso.TotalMinutes} min";
        if (paso.TotalDays < 1) return $"Hace {(int)paso.TotalHours} h";
        int dias = DiasDesde(fecha);
        if (dias == 1) return "Ayer";
        if (dias < 7) return $"Hace {dias} días";
        return fecha.ToString("dd/MM/yyyy");
    }

    public static string DiaYHora(DateTime fecha)
    {
        int dias = DiasDesde(fecha);
        string hora = fecha.ToString("HH:mm");
        return dias == 0 ? $"hoy {hora}" : dias == 1 ? $"ayer {hora}" : fecha.ToString("dd/MM HH:mm");
    }

    public static string HoraODia(DateTime fecha)
    {
        int dias = DiasDesde(fecha);
        return dias == 0 ? fecha.ToString("HH:mm") : dias == 1 ? "Ayer" : fecha.ToString("dd/MM");
    }

    public static string Dia(DateTime fecha)
    {
        int dias = DiasDesde(fecha);
        return dias == 0 ? "Hoy" : dias == 1 ? "Ayer" : fecha.ToString("dd/MM/yyyy");
    }

    public static string ParaHtml(DateTime fecha)
    {
        return fecha.ToString("yyyy-MM-ddTHH:mm");
    }
}
