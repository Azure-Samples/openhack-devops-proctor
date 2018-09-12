using System;
using Microsoft.AspNetCore.Mvc;
using System.Linq;
using System.Collections.Generic;
using Sentinel.Data;
using Sentinel.Models;
using Microsoft.Extensions.Logging;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Cors;

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

        // Teams
        // * GET /api/leaderboard/teams - get all teams
        // * GET /api/leaderboard/teams/id/{teamId} = get a team by ID
        // * GET /api/leaderboard/teams/{teamName} - get team by teamName
        // * POST /api/leaderboard/teams/ - create a team
        // * PATCH /api/leaderboard/teams/{teamName} - update a team
        // * DELETE /api/leaderboard/teams/{teamName} - Delete a team and it's associated challenges

        // Challenges
        // * GET /api/leaderboard/challenges/ - get challenges for all teams
        // * GET /api/leaderboard/challenges/{teamName} - get challenges for a team
        // * POST /api/leaderboard/challenges/ - create a challenge for a team
        // * PATCH /api/leaderboard/challenges/{challengeId} - update a challenge.  Update start/end times for a challenge

        //Service Health
        // * GET /api/leaderboard/servicehealth/ - get health for all teams services
        // * GET /api/leaderboard/servicehealth/{teamName} - get health for a team`

        //Challenge Definitions
        // * GET /api/leaderboard/challengedefinitions/id/{challengeId}

        // Sentinel Controller
        // * GET /api/sentinel/logs/{teamId} - gets all logs for a team
        // * POST /api/sentinel/logs/{teamId} - posts logs for a team

        /// <summary>
        /// GET /api/leaderboard/teams - get all teams
        /// </summary>
        /// <returns>List of Teams</returns>
        [HttpGet("teams", Name = "GetTeams")]
        [Produces("application/json", Type = typeof(Team))]
        public List<Team> GetTeams()
        {
            return _context.Teams.ToList<Team>();
        }

        /// <summary>
        /// GET /api/leaderboard/teams/id/{teamId} = get a team by ID
        /// </summary>
        /// <param name="teamId"></param>
        /// <returns>List with 1 team</returns>
        [HttpGet("teams/id/{teamId}", Name = "GetTeamById")]
        [Produces("application/json", Type = typeof(Team))]
        public List<Team> GetTeamById(string teamId)
        {
            return _context.Teams.Where(tm => tm.Id == teamId).ToList<Team>();
        }

        /// <summary>
        /// GET /api/leaderboard/teams/{teamName} - get team by teamName
        /// </summary>
        /// <param name="teamName"></param>
        /// <returns>List with 1 team</returns>
        [HttpGet("teams/{teamName}", Name = "GetTeam")]
        [Produces("application/json", Type = typeof(Team))]
        public List<Team> GetTeam(string teamName)
        {
            return _context.Teams.Where(tm => tm.TeamName == teamName).ToList<Team>();
        }

        /// <summary>
        /// POST /api/leaderboard/teams/ - create a team
        /// </summary>
        /// <param name="tm"></param>
        /// <returns>status 200 if team created</returns>
        [HttpPost("teams", Name = "CreateTeam")]
        public IActionResult CreateTeam([FromBody] Team tm)
        {
            tm.Id = Guid.NewGuid().ToString();

            _context.Teams.Add(tm);
            _context.SaveChanges();
            return Ok(tm);
        }

        /// <summary>
        /// PATCH /api/leaderboard/teams/{teamName} - update a team
        /// </summary>
        /// <param name="tm"></param>
        /// <returns>Status 200 if team is update, 404 if not found.</returns>
        [HttpPatch("teams/{teamName}", Name = "UpdateTeam")]
        public IActionResult UpdateTeam([FromBody] Team tm)
        {
            Team tmp = _context.Teams.Find(tm.Id);
            if (tmp == null){
                return NotFound();
            }

            tmp.DownTimeMinutes = tm.DownTimeMinutes;
            tmp.IsScoringEnabled = tm.IsScoringEnabled;
            tmp.Points = tm.Points;
            tmp.TeamName = tm.TeamName;

            _context.Teams.Update(tmp);
            _context.SaveChanges();

            return NoContent();
        }

        /// <summary>
        /// DELETE /api/leaderboard/teams/{teamName} - Delete a team and it's associated challenges
        /// </summary>
        /// <param name="teamName"></param>
        /// <returns></returns>
        [HttpDelete("teams/{teamName}", Name = "DeleteTeam")]
        public IActionResult DeleteTeam(string teamName)
        {

            Team t;
            try
            {
                t = _context.Teams.Where<Team>(Team => Team.TeamName == teamName).Single<Team>();
            }
            catch(Exception)
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

        /// <summary>
        /// GET /api/leaderboard/challenges/ - get all challenges for all teams
        /// </summary>
        /// <returns></returns>
        [HttpGet("challenges", Name = "GetChallenges")]
        public List<Challenge> GetChallenges()
        {
            var query = _context.Challenges
                .Include(tm => tm.Team)
                .Include(cd => cd.ChallengeDefinition);
            return  query.ToList();
        }

        /// <summary>
        /// GET /api/leaderboard/challenges/{teamName} - get challenges for a team
        /// </summary>
        /// <param name="teamName"></param>
        /// <returns>List of challenges</returns>
        [HttpGet("challenges/{teamName}",Name = "GetChallengesForTeam")]
        public List<Challenge> GetChallengesForTeam(string teamName){

            var query = from c in _context.Challenges join t in _context.Teams on c.TeamId equals t.Id where t.TeamName == teamName select c;

            return query.ToList<Challenge>();
        }

        /// <summary>
        /// POST /api/leaderboard/challenges/ - create a challenge for a team
        /// </summary>
        /// <param name="c"></param>
        /// <returns></returns>
        [HttpPost("challenges", Name = "CreateChallenge")]
        public IActionResult CreateChallenge([FromBody] Challenge c)
        {
            c.Id = Guid.NewGuid().ToString();

            _context.Challenges.Add(c);
            _context.SaveChanges();

            return Ok(c);
        }

        /// <summary>
        /// PATCH /api/leaderboard/challenges/{challengeId} - update a challenge.  Update start/end times for a challenge
        /// </summary>
        /// <param name="c"></param>
        /// <returns></returns>
        [HttpPatch("challenges/{challengeId}",Name = "UpdateChallenge")]
        public IActionResult UpdateChallenge([FromBody] Challenge c)
        {
            Challenge tmp = _context.Challenges.Find(c.Id);

            if(tmp == null)
            {
                return NotFound();
            }

            tmp.TeamId = c.TeamId;
            tmp.ChallengeDefinitionId = c.ChallengeDefinitionId;
            tmp.IsCompleted = c.IsCompleted;
            tmp.StartDateTime = c.StartDateTime;
            tmp.EndDateTime = c.EndDateTime.HasValue ? c.EndDateTime : null;
            tmp.Score = c.Score;

            _context.Challenges.Update(tmp);
            _context.SaveChanges();

            return NoContent();
        }

        //Service Health
        // * GET /api/leaderboard/servicehealth/ - get health for all teams services

        // * GET /api/leaderboard/servicehealth/{teamName} - get health for a team`

        /// <summary>
        ///
        /// </summary>
        /// <returns>ListOfServiceHealth Records</returns>
        [HttpGet("servicehealth", Name = "GetAllServiceHealth")]
        public List<Team> GetAllServiceHealth()
        {
            var query = _context.Teams.Include(tm => tm.ServiceStatus);
            return  query.ToList();
        }
    }
}