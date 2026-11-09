namespace Swappit.Models;

public static class Telefonos
{
    public const int MinDigitos = 8;
    public const int MaxDigitos = 15;

    public static string Convertir(string? telefono)
    {
        return new string((telefono ?? string.Empty).Where(char.IsDigit).ToArray());
    }

    public static bool EsValido(string digitos)
    {
        return digitos.Length >= MinDigitos && digitos.Length <= MaxDigitos;
    }
}