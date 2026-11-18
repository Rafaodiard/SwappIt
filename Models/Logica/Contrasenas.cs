using Microsoft.AspNetCore.Identity;

namespace Swappit.Models;

public static class Contrasenas
{
    private static readonly PasswordHasher<Usuarios> _hasher = new PasswordHasher<Usuarios>();

    public static string Hashear(string contrasena)
    {
        return _hasher.HashPassword(null!, contrasena);
    }

    public static bool Verificar(string? guardada, string ingresada, out bool hayQueActualizar)
    {
        hayQueActualizar = false;
        if (string.IsNullOrEmpty(guardada)) return false;

        if (!EsHash(guardada))
        {
            bool coincide = guardada == ingresada;
            hayQueActualizar = coincide;
            return coincide;
        }

        PasswordVerificationResult resultado = _hasher.VerifyHashedPassword(null!, guardada, ingresada);
        hayQueActualizar = resultado == PasswordVerificationResult.SuccessRehashNeeded;
        return resultado != PasswordVerificationResult.Failed;
    }

    private static bool EsHash(string valor)
    {
        if (valor.Length <= 50) return false;

        try
        {
            byte[] bytes = Convert.FromBase64String(valor);
            return bytes.Length > 0 && bytes[0] == 0x01;
        }
        catch (FormatException)
        {
            return false;
        }
    }
}
