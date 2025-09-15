using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EF_CodefFirst.Models
{
    internal class author
    {
        public int Id { get; set; } 
        public string Name { get; set; }
        public int age {  get; set; }
        public string user_name {  get; set; }
        public string password { get; set; }
        public DateOnly JoinDate { get; set; } = DateOnly.FromDateTime(DateTime.Now);
        public ICollection<news> News { get; set; }

    }
}
