using Microsoft.EntityFrameworkCore;

using WF.Document.Data.Models;

namespace WF.Document.Data.DbContext
{
    public class DemoDbContext : Microsoft.EntityFrameworkCore.DbContext
    {
        public DemoDbContext(DbContextOptions<DemoDbContext> options) : base(options)
        { }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.EnableSensitiveDataLogging();
        }

        public virtual DbSet<OTItemHistoryEFModel> OTItemHistories { get; set; }

        public virtual DbSet<UserEFModel> Users { get; set; }
    }
}
