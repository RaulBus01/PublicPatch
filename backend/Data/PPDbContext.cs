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
        public DbSet<ReportEntity> Reports { get; set; }
        public DbSet<LocationEntity> Locations { get; set; }


        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<LocationEntity>()
                .HasKey(e => e.Id);

            modelBuilder.Entity<ReportEntity>()
                .HasOne(r => r.Location)
                .WithMany()
                .HasForeignKey("LocationId");
        }
    }
}