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

        // Leaderboard Controller
        // * GET /api/leaderboard/teams - get teams
        // * GET /api/leaderboard/teams/{teamName} - get team by teamName
        // * POST /api/leaderboard/teams/ - create a team
        // * PATCH /api/leaderboard/teams/{teamName} - update a team
        // * DELETE /api/leaderboard/teams/{teamName} - Delete a team

        // * GET /api/leaderboard/challenges/ - get challenges for all teams
        // * GET /api/leaderboard/challenges/{teamName} - get challenges for a team
        // * POST /api/leaderboard/challenges/ - create a challenge for a team
        // * PATCH /api/leaderboard/challenges/{challengeId} - update a challenge.  Update start/end times for a challenge

        // Sentinel Controller
        // * GET /api/sentinel/logs/{teamId} - gets all logs for a team
        // * POST /api/sentinel/logs/{teamId} - posts logs for a team


        // * GET /api/leaderboard/teams/{teamName} - get team by teamName
        [HttpGet("teams/{teamName}", Name = "GetTeam")]
        [Produces("application/json", Type = typeof(Team))]
        public List<Team> GetTeam(string teamName)
        {
            return _context.Teams.Where(tm => tm.TeamName == teamName).ToList<Team>();
        }

        // * GET /api/leaderboard/teams - get teams
        [HttpGet("teams", Name = "GetTeams")]
        [Produces("application/json", Type = typeof(Team))]
        public List<Team> GetTeams()
        {
            return _context.Teams.ToList<Team>();
        }

        // * POST /api/leaderboard/teams/ - create a team
        [HttpPost("teams", Name = "CreateTeam")]
        public IActionResult CreateTeam([FromBody] Team tm)
        {
            tm.Id = Guid.NewGuid().ToString();

            _context.Teams.Add(tm);
            _context.SaveChanges();
            return Ok(tm);
        }

        // * PATCH /api/leaderboard/teams/{teamName} - update a team
        [HttpPatch("teams/{teamName}", Name = "UpdateTeam")]
        public IActionResult UpdateTeam([FromBody] Team tm)
        {
            Team t = _context.Teams.Find(tm.Id);
            if (t == null){
                return NotFound();
            }

            t.DownTimeSeconds = tm.DownTimeSeconds;
            t.IsScoringEnabled = tm.IsScoringEnabled;
            t.Points = tm.Points;
            t.TeamName = tm.TeamName;

            _context.Teams.Update(t);
            _context.SaveChanges();

            return NoContent();
        }

        // * DELETE /api/leaderboard/teams/{teamName} - Delete a team
        [HttpDelete("teams/{teamName}", Name = = "DeleteTeam")]
        public IActionResult DeleteTeam(string teamName)
        {
            
            Team t;
            try
            {
                t = _context.Teams.Where<Team>(Team => Team.TeamName == teamName).Single<Team>();
            }
            catch(Exception ex)
            {
                return NoContent();
            }

            List<Challenge> challengesToDelete = _context.Challenges.Where<Challenge>(Challenge => Challenge.TeamId == t.Id).ToList<Challenge>();

            foreach(Challenge c in challengesToDelete)
            {
                _context.Challenges.Remove(c);
            }

            _context.Teams.Remove(t);
            _context.SaveChanges();

            return NoContent();
        }

        // * GET /api/leaderboard/challenges/ - get challenges for all teams
        [HttpGet("challenges", Name = "GetChallenges")]
        public List<Challenge> GetChallenges()
        {
            return _context.Challenges.ToList<Challenge>();
        }

        // * GET /api/leaderboard/challenges/{teamName} - get challenges for a team
        [HttpGet("challenges/{teamName}",Name = "GetChallengesForTeam")]
        public List<Challenge> GetChallengesForTeam(string teamName){

            var query = from c in _context.Challenges join t in _context.Teams on c.TeamId equals t.Id where t.TeamName == teamName select c;

            return query.ToList<Challenge>();
        }

        // * POST /api/leaderboard/challenges/ - create a challenge for a team
        [HttpPost("challenges", Name = "CreateChallenge")]
        public IActionResult CreateChallenge([FromBody] Challenge c)
        {
            c.Id = Guid.NewGuid().ToString();

            _context.Challenges.Add(c);
            _context.SaveChanges();

            return Ok(c);
        }

        // * PATCH /api/leaderboard/challenges/{challengeId} - update a challenge.  Update start/end times for a challenge
        [HttpPatch("challenges/{challengeId}",Name = "UpdateChallenge")]
        public IActionResult UpdateChallenge([FromBody] Challenge c)
        {
            Challenge tmp = _context.Challenges.Find(c.Id);

            if(tmp == null)
            {
                return NotFound();
            }

            tmp.ChallengeDefinitionId = c.ChallengeDefinitionId;
            tmp.EndDateTime = c.EndDateTime;
            tmp.Score = c.Score;
            tmp.StartDateTime = c.StartDateTime;
            tmp.TeamId = c.TeamId;

            _context.Challenges.Update(tmp);
            _context.SaveChanges();

            return NoContent();
        }

    }
}