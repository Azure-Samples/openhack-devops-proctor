using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Sentinel.Models;

namespace Sentinel.Data
{
    public class AppUserContext : IdentityDbContext<AppUser>
    {
        public AppUserContext(DbContextOptions<AppUserContext> options) : base(options)
        {

        }

        public DbSet<AppUser> AppUser { get; set; }

    }
}