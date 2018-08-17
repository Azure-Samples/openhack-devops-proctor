using System;
using Microsoft.AspNetCore.Mvc;
using System.Linq;
using System.Collections.Generic;
using Sentinel.Data;
using Sentinel.Models;
using Microsoft.Extensions.Logging;

namespace Sentinel.Controllers
{
    [Produces("application/json")]
    [Route("api/[controller]")]
    public class SentinelController : ControllerBase
    {
        private readonly LogMessageContext _context;

        public SentinelController(LogMessageContext context)
        {
            _context = context;

        }

        // Routes
        // GET /sentinel/logs/{teamId} - Get logs for team
        // POST /sentinel/logs/{teamId} - Create new log for team

        // Leaderboard routes in Leaderboard controller

        [HttpGet("{teamName}", Name = "GetLogMessagesForTeam")]
        [Produces("application/json", Type = typeof(LogMessage))]
        public List<LogMessage> GetLogMessagesForTeam(string teamName)
        {

            ILoggerFactory loggerFactory = new LoggerFactory()
                .AddDebug()
                .AddConsole();

            ILogger logger = loggerFactory.CreateLogger("Service");
            logger.LogInformation("Service sees {0}",teamName);

            return _context.LogMessages.Where(msg => msg.TeamName == teamName).ToList<LogMessage>();
        }

        [HttpPost(Name = "CreateLogMessageForTeam")]
        public IActionResult CreateLogMessageForTeam([FromBody] LogMessage msg)
        {
            _context.Add<LogMessage>(msg);
            _context.SaveChanges();
            return Ok(msg);
        }
    }
}