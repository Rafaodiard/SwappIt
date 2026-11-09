namespace Swappit.Models;

public static class Telefonos
{
    public static int Convertir(string telefono)
    {
        string digitos = new string(telefono.Where(char.IsDigit).ToArray());
        return int.TryParse(digitos, out int numero) ? numero : 0;
    }
}
