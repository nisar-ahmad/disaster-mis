using ODTKMS.Models;
using System.Web.Mvc;

namespace ODTKMS.Controllers
{
    [AllowAnonymous]
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return RedirectToAction("Index", "Website");
        }
    }
}