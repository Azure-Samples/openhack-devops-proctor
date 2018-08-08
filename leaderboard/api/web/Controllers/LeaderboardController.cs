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

        // * GET /api/leaderboard/teams/ - get teams
        // * GET /api/leaderboard/teams/{teamName} - get team record
        // * POST /api/leaderboard/teams/ - create a team
        // * PATCH /api/leaderboard/teams/{teamName} - update a team

        // * GET /api/leaderboard/challenges/ - get challenges for all teams
        // * GET /api/leaderboard/challenges/{teamName} - get challenges for a team
        // * POST /api/leaderboard/challenges/ - create a challenge for a team
        // * PATCH /api/leaderboard/challenges/{challengeId} - update a challenge.  Update start/end times for a challenge

        // * GET /api/sentinel/logs/{teamId} - gets all logs for a team
        // * POST /api/sentinel/logs/{teamId} - posts logs for a team

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

        [("teams", Name = "UpdateTeam")]
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