using Microsoft.AspNetCore.Identity;

namespace Swappit.Models;

// Hash de contraseñas con el PasswordHasher que ya trae ASP.NET Core (PBKDF2 con sal aleatoria),
// así no hace falta agregar paquetes. Cada hash es distinto aunque dos usuarios usen la misma contraseña,
// por eso nunca se compara en SQL: se trae el usuario por mail y se verifica acá.
public static class Contrasenas
{
    // PasswordHasher no usa el usuario para calcular el hash, por eso se le pasa null.
    private static readonly PasswordHasher<Usuarios> _hasher = new PasswordHasher<Usuarios>();

    public static string Hashear(string contrasena)
    {
        return _hasher.HashPassword(null!, contrasena);
    }

    // hayQueActualizar = true cuando la contraseña es correcta pero lo guardado está en texto plano
    // (usuarios cargados antes del hash, como los del script de datos) o con un formato de hash viejo:
    // quien llama tiene que volver a guardarla con Hashear.
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

    // El hash de PasswordHasher es base64 y empieza con el byte 0x01 (formato V3), con 84 caracteres.
    // Una contraseña en texto plano no puede confundirse con un hash: la columna era varchar(50).
    // Esto evita que alguien entre escribiendo el hash como si fuera la contraseña.
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
