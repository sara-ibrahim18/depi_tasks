using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace EF_CodefFirst.Models
{
    internal class news
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Desc { get; set; }
        
        public DateOnly date {  get; set; }
        public TimeOnly time { get; set; }

        public int AuthorId { get; set; }
        public author Author { get; set; }

        public int CategoryId { get; set; }
        public category Category { get; set; }
    }
}
