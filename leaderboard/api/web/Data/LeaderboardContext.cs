
using Microsoft.EntityFrameworkCore;
using Sentinel.Models;

namespace Sentinel.Data
{
    public class LeaderboardContext : DbContext
    {
        public LeaderboardContext(DbContextOptions<LeaderboardContext> options) : base(options)
        {

        }

        public DbSet<Team> Teams { get; set; }
    }
}