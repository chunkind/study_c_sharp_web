using Microsoft.EntityFrameworkCore;
using SharedData.Models;

namespace WebApi.Data
{
    public class ApplicationDbContext : DbContext
    {
        public DbSet<GameResult> GameResult {  get; set; }
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {

        }
    }
}
