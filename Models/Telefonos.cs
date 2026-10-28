namespace Swappit.Models;

// Convierte el teléfono que escribe el usuario (registro y editar perfil) al formato de la columna Usuarios.Telefono.
public static class Telefonos
{
    // TODO: la columna Telefono es int y no entra un número completo (+54 9 11 ...).
    // Conviene pasarla a varchar; mientras tanto, si no entra se guarda 0.
    public static int Convertir(string telefono)
    {
        string digitos = new string(telefono.Where(char.IsDigit).ToArray());
        return int.TryParse(digitos, out int numero) ? numero : 0;
    }
}
