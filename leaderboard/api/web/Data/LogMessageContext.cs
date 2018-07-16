using Microsoft.EntityFrameworkCore;
using Sentinel.Models;

namespace Sentinel.Data
{
    public class LogMessageContext : DbContext
    {
        public LogMessageContext(DbContextOptions<LogMessageContext> options) : base(options)
        {

        }

        public DbSet<LogMessage> LogMessages { get; set; }
    }
}