using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace Swappit.Controllers;

public abstract class BaseController : Controller
{
    public override void OnActionExecuted(ActionExecutedContext context)
    {
        int? sesionId = HttpContext.Session.GetInt32("UsuarioId");
        ViewBag.sesionId = sesionId;
        ViewBag.esVisitante = sesionId == null;
        ViewBag.sesionIniciales = HttpContext.Session.GetString("Iniciales");
        ViewBag.sesionFoto = HttpContext.Session.GetString("Foto");
        base.OnActionExecuted(context);
    }
}
