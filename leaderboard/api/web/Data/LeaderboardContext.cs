
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
        public DbSet<Challenge> Challenges { get; set; }
        public DbSet<ChallengeDefinition> ChallengeDefinitions { get; set; }
        public DbSet<ServiceStatus> ServiceStatuses {get;set;}
        public DbSet<LogMessage> LogMessages { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<ServiceStatus>()
                        .HasOne(t => t.Team)
                        .WithMany(t => t.ServiceStatus);

            modelBuilder.Entity<Challenge>()
                .HasOne(c => c.Team);

            modelBuilder.Entity<Challenge>()
                .HasOne(c => c.ChallengeDefinition);

            modelBuilder.Entity<ServiceStatus>().HasKey(s => new {s.TeamId, s.ServiceType});
        }
    }
}