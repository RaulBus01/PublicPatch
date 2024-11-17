using Microsoft.EntityFrameworkCore;
using PublicPatch.Aggregates;
using PublicPatch.Services;

namespace PublicPatch.Data
{
    public class PPContext : DbContext
    {
        
        private readonly IConfigService config;

        public PPContext(IConfigService config)
        {
            this.config = config;

        }
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseNpgsql(config.GetDbConnectionString());

        }

        public DbSet<UserEntity> Users { get; set; }
    }
}