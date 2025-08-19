using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystem
{
    internal class Instructor
    {
        
            public int Id { get; set; }
            public string Name { get; set; }
            public string Specialization { get; set; }
            public List<Course> Courses { get; set; } = new();

            public Instructor(int id, string name, string specialization)
            {
                Id = id;
                Name = name;
                Specialization = specialization;
            }
        }

    }

