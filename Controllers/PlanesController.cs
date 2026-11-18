using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Swappit.Models;
using Swappit.Models.ViewModels;

namespace Swappit.Controllers;

public class PlanesController : BaseController
{
    private readonly ILogger<PlanesController> _logger;

    public PlanesController(ILogger<PlanesController> logger)
    {
        _logger = logger;
    }

    public IActionResult Index()
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");

        ViewBag.planes = new List<PlanViewModel>();
        ViewBag.idPlanActual = null;
        ViewBag.errorCarga = false;
        ViewBag.mensaje = TempData["MensajePlan"] as string;
        ViewBag.error = TempData["ErrorPlan"] as string;
        try
        {
            ViewBag.planes = Suscripciones.Planes();
            if (usuarioId != null)
            {
                ViewBag.idPlanActual = UsuariosBD.GetUsuarioById(usuarioId.Value)?.IdPlan;
            }
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudieron cargar los planes");
            ViewBag.errorCarga = true;
        }
        return View();
    }

    public IActionResult Pago(int id)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return RedirectToAction("Index", "Account");
        }

        try
        {
            Usuarios? usuario = UsuariosBD.GetUsuarioById(usuarioId.Value);
            if (usuario == null)
            {
                return RedirectToAction("Index", "Account");
            }

            List<PlanViewModel> planes = Suscripciones.Planes();
            PlanViewModel? plan = Suscripciones.PlanParaPagar(planes, id);
            if (plan == null)
            {
                return RedirectToAction("Index");
            }
            if (usuario.IdPlan == plan.Id)
            {
                TempData["MensajePlan"] = $"Ya tenés el plan {plan.Nombre}.";
                return RedirectToAction("Index");
            }

            ViewBag.plan = plan;
            ViewBag.planActual = Suscripciones.Buscar(planes, usuario.IdPlan);
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo cargar el pago del plan {IdPlan}", id);
            TempData["ErrorPlan"] = "No pudimos cargar el pago. Probá de nuevo en un rato.";
            return RedirectToAction("Index");
        }
        return View();
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Cambiar(int idPlan)
    {
        int? usuarioId = HttpContext.Session.GetInt32("UsuarioId");
        if (usuarioId == null)
        {
            return RedirectToAction("Index", "Account");
        }

        try
        {
            Usuarios? usuario = UsuariosBD.GetUsuarioById(usuarioId.Value);
            if (usuario == null)
            {
                return RedirectToAction("Index", "Account");
            }

            Resultado resultado = Suscripciones.CambiarPlan(usuario, idPlan);
            if (resultado.Error != null)
            {
                TempData["ErrorPlan"] = resultado.Error;
            }
            else
            {
                TempData["MensajePlan"] = resultado.Mensaje;
            }
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "No se pudo cambiar el plan del usuario {IdUsuario} a {IdPlan}", usuarioId, idPlan);
            TempData["ErrorPlan"] = "No pudimos cambiar tu plan. Probá de nuevo en un rato.";
        }
        return RedirectToAction("Index");
    }
}
