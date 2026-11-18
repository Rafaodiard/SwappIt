using System.ComponentModel.DataAnnotations;
using System.Reflection;
using Microsoft.AspNetCore.Mvc.ModelBinding;

namespace Swappit.Models;

public static class Formularios
{
    public static void AgregarErrores(ModelStateDictionary modelState, List<ErrorCampo> errores)
    {
        foreach (ErrorCampo error in errores)
        {
            modelState.AddModelError(error.Campo, error.Mensaje);
        }
    }

    public static bool TieneError(ModelStateDictionary modelState, string campo)
    {
        return modelState[campo]?.Errors.Count > 0;
    }

    public static string PrimerError(ModelStateDictionary modelState)
    {
        foreach (ModelStateEntry campo in modelState.Values)
        {
            foreach (ModelError error in campo.Errors)
            {
                return error.ErrorMessage;
            }
        }
        return "";
    }

    public static Dictionary<string, string> MensajesRequeridos(Type tipo)
    {
        Dictionary<string, string> mensajes = new Dictionary<string, string>();
        foreach (PropertyInfo propiedad in tipo.GetProperties())
        {
            mensajes[propiedad.Name] = propiedad.GetCustomAttribute<RequiredAttribute>()?.ErrorMessage ?? "";
        }
        return mensajes;
    }
}
