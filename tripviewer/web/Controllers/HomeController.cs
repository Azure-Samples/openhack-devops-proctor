using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Options;
using TripViewer.Models;
using TripViewer.Utility;

namespace TripViewer.Controllers
{
    public class HomeController : Controller
    {
        private readonly IConfiguration Configuration;

        public HomeController(IConfiguration configuration)
        {
            Configuration = configuration;
        }
        public IActionResult Index()
        {
            TripViewerConfiguration tv = new TripViewerConfiguration();

            tv.USER_ROOT_URL = Configuration.GetValue<string>("USER_ROOT_URL");
            tv.USER_JAVA_ROOT_URL = Configuration.GetValue<string>("USER_JAVA_ROOT_URL");
            tv.TRIPS_ROOT_URL = Configuration.GetValue<string>("TRIPS_ROOT_URL");
            tv.POI_ROOT_URL = Configuration.GetValue<string>("POI_ROOT_URL");
            return View(tv);
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
