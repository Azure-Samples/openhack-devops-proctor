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
    public class LeaderboardController : ControllerBase
    {
        private readonly LeaderboardContext _context;

        public LeaderboardController(LeaderboardContext context)
        {
            _context = context;

        }

        // Routes
        // GET /sentinel/logs/{teamId} - Get logs for team
        // POST /sentinel/logs/{teamId} - Create new log for team

        // Leaderboard routes in Leaderboard controller

        [HttpGet("teams/{teamName}", Name = "GetTeam")]
        [Produces("application/json", Type = typeof(Team))]
        public List<Team> GetTeam(string teamName)
        {
            return _context.Teams.Where(tm => tm.TeamName == teamName).ToList<Team>();
        }

        [HttpGet("teams", Name = "GetTeams")]
        [Produces("application/json", Type = typeof(Team))]
        public List<Team> GetTeams()
        {
            return _context.Teams.ToList<Team>();
        }

        [HttpPost("teams", Name = "CreateTeam")]
        public IActionResult CreateTeam([FromBody] Team tm)
        {
            Team t = new Team();
            t.TeamName = tm.TeamName;
            t.DownTimeSeconds = 0;
            t.Points = 0;

            _context.Add(t);
            _context.SaveChanges();
            return Ok(t);
        }
    }
}