namespace Swappit.Models;

public class ErrorCampo
{
    public string Campo { get; set; }
    public string Mensaje { get; set; }

    public ErrorCampo(string campo, string mensaje)
    {
        Campo = campo;
        Mensaje = mensaje;
    }

    public bool EsGeneral => Campo == "";
}
