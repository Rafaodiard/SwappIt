using Swappit.Models.ViewModels;

namespace Swappit.Models;

public static class Reputaciones
{
    public const int OpinionesEnPerfil = 6;

    public static Resultado Calificar(int idIntercambio, int idUsuario, int puntaje, string? comentario)
    {
        IntercambioViewModel? intercambio = IntercambiosBD.GetIntercambio(idIntercambio, idUsuario);
        if (intercambio == null)
        {
            return new Resultado { NoExiste = true };
        }
        if (intercambio.Estado != EstadosIntercambios.Realizado)
        {
            return Resultado.ConError("Podés calificar el intercambio cuando los dos lo hayan confirmado como realizado.");
        }
        if (intercambio.YaCalifique)
        {
            return Resultado.ConError($"Ya calificaste a {intercambio.OtroNombreVisible} por este intercambio.");
        }
        if (puntaje < Calificaciones.MinPuntaje || puntaje > Calificaciones.MaxPuntaje)
        {
            return Resultado.ConError($"Elegí de {Calificaciones.MinPuntaje} a {Calificaciones.MaxPuntaje} estrellas.");
        }

        string? texto = string.IsNullOrWhiteSpace(comentario) ? null : comentario.Trim();
        if (texto != null && texto.Length > Calificaciones.MaxComentario)
        {
            return Resultado.ConError($"El comentario puede tener hasta {Calificaciones.MaxComentario} caracteres.");
        }

        Resultado resultado = new Resultado();
        if (CalificacionesBD.CalificarIntercambio(idIntercambio, idUsuario, puntaje, texto, resultado.Notificaciones))
        {
            resultado.Mensaje = $"¡Gracias! Le dejaste {TextoEstrellas(puntaje)} a {intercambio.OtroNombreVisible}.";
        }
        else
        {
            resultado.Error = "No se pudo guardar la calificación. Puede que ya hayas calificado este intercambio.";
        }
        return resultado;
    }

    public static string TextoEstrellas(double puntaje)
    {
        string numero = puntaje.ToString("0.#", new System.Globalization.CultureInfo("es-AR"));
        return puntaje == 1 ? "1 estrella" : $"{numero} estrellas";
    }

    public static string IconoEstrella(double valor, int posicion)
    {
        if (valor >= posicion - 0.25)
        {
            return "bi-star-fill";
        }
        if (valor >= posicion - 0.75)
        {
            return "bi-star-half";
        }
        return "bi-star";
    }

    public static string Etiqueta(int puntaje)
    {
        switch (puntaje)
        {
            case 5:
                return "Excelente";
            case 4:
                return "Muy bueno";
            case 3:
                return "Bueno";
            case 2:
                return "Regular";
            default:
                return "Malo";
        }
    }
}
