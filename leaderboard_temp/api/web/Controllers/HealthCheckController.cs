using System;
using Microsoft.AspNetCore.Mvc;
using System.Linq;
using System.Collections.Generic;
using Microsoft.Extensions.Logging;
using Sentinel.Models;
using Sentinel.Data;
using Sentinel.Utility;
using Newtonsoft.Json;


namespace Sentinel.Controllers
{
    [Produces("application/json")]
    [Route("api/[controller]/sentinel")]
    public class HealthCheckController : ControllerBase
    {

        private readonly ILogger _logger;

        public HealthCheckController(ILogger<HealthCheckController> logger)
        {
            _logger = logger;
        }

        [HttpGet]
        [Produces("application/json", Type = typeof(Healthcheck))]
        public IActionResult Get()
        {
            _logger.LogInformation(LoggingEvents.Healthcheck, "Healthcheck Requested");
            return Ok(new Healthcheck());
        }
    }

}