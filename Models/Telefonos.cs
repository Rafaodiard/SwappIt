namespace Swappit.Models;

public static class Telefonos
{
    public const int MinDigitos = 8;
    public const int MaxDigitos = 15;

    public static string Convertir(string? telefono)
    {
        string digitos = "";
        foreach (char letra in telefono ?? string.Empty)
        {
            if (char.IsDigit(letra))
            {
                digitos += letra;
            }
        }
        return digitos;
    }

    public static bool EsValido(string digitos)
    {
        return digitos.Length >= MinDigitos && digitos.Length <= MaxDigitos;
    }
}