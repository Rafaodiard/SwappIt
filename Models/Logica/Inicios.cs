namespace Swappit.Models;

public static class Inicios
{
    public static string Saludo(string? nombre)
    {
        return string.IsNullOrWhiteSpace(nombre) ? "¡Hola!" : $"¡Hola, {nombre}!";
    }

    public static string TextoVerTodos(int cantidadEnCurso, int mostrados)
    {
        return cantidadEnCurso > mostrados ? $"Ver todos ({cantidadEnCurso})" : "Ver todos";
    }
}
