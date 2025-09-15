using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace EF_CodefFirst.Models
{
    internal class S1Context:DbContext
    {
        public DbSet<category> categories { get; set; }
        public DbSet<news>newss { get; set; }
        public DbSet<author> authors { get; set; }
        
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseSqlServer("Server=DESKTOP-4FF9LMV;Database=ef1;Trusted_Connection=True;Trust Server Certificate=True;");
        }
    }
}
