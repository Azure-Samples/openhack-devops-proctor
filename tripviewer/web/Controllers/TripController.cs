using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using Simulator.DataObjects;
using Simulator.DataStore.Stores;
using TripViewer.Utility;
using Kendo.Mvc.UI;
using Kendo.Mvc.Extensions;

namespace TripViewer.Controllers
{
    public class TripController : Controller
    {
        private readonly TripViewerConfiguration _envvars;

        public TripController(IOptions<TripViewerConfiguration> EnvVars)
        {
            _envvars = EnvVars.Value ?? throw new ArgumentNullException(nameof(EnvVars));
        }
        [HttpGet]
        public IActionResult Index()
        {
            var teamendpoint = _envvars.TEAM_API_ENDPOINT;
            TripStore t = new TripStore(teamendpoint);
            List<Trip> trips = t.GetItemsAsync().Result;
            return View(trips);
        }
    }
}