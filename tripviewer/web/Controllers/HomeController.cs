using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using TripViewer.Models;
using TripViewer.Utility;

namespace TripViewer.Controllers
{
    public class HomeController : Controller
    {
        private readonly TripViewerConfiguration _envvars;
        public HomeController(IOptions<TripViewerConfiguration> EnvVars)
        {
            _envvars = EnvVars.Value ?? throw new ArgumentNullException(nameof(EnvVars));
        }
        public IActionResult Index()
        {
            return View(_envvars);
        }

        public IActionResult About()
        {
            ViewData["Message"] = "Your application description page.";

            return View();
        }

        public IActionResult Contact()
        {
            ViewData["Message"] = "Your contact page.";

            return View();
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
