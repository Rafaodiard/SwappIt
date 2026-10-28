using Microsoft.AspNetCore.Mvc;

namespace Swappit.Controllers;

// Chat para coordinar los intercambios (/Chat). Por ahora la vista es solo visual.
public class ChatController : Controller
{
    public IActionResult Index()
    {
        return View();
    }
}
