namespace Swappit.Models;

public static class Listas
{
    public static List<int> IdsValidos(int[]? ids, int maximo = int.MaxValue)
    {
        List<int> validos = new List<int>();
        if (ids == null)
        {
            return validos;
        }
        foreach (int id in ids)
        {
            if (validos.Count >= maximo)
            {
                break;
            }
            if (id > 0 && !validos.Contains(id))
            {
                validos.Add(id);
            }
        }
        return validos;
    }

    public static string UnirNombres(List<string> nombres)
    {
        if (nombres.Count == 0)
        {
            return "";
        }
        if (nombres.Count == 1)
        {
            return nombres[0];
        }
        return $"{string.Join(", ", nombres.GetRange(0, nombres.Count - 1))} y {nombres[nombres.Count - 1]}";
    }

    public static string UnirConComas(params string?[] textos)
    {
        List<string> conTexto = new List<string>();
        foreach (string? texto in textos)
        {
            if (!string.IsNullOrWhiteSpace(texto))
            {
                conTexto.Add(texto);
            }
        }
        return string.Join(", ", conTexto);
    }
}
