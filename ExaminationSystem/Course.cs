using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static ExaminationSystem.Program;

namespace ExaminationSystem
{
    internal class Course
    {
        public string Title { get; set; }
        public string Description { get; set; }
        public double MaximumDegree { get; set; }
        public List<Student> Students { get; set; } = new();
        public List<Instructor> Instructors { get; set; } = new();
        public List<Exam> Exams { get; set; } = new();

        public Course(string title, string description, double maxDegree)
        {
            Title = title;
            Description = description;
            MaximumDegree = maxDegree;
        }

        public void EnrollStudent(Student student)
        {
            Students.Add(student);
            student.Courses.Add(this);
        }

        public void AssignInstructor(Instructor instructor)
        {
            Instructors.Add(instructor);
            instructor.Courses.Add(this);
        }
    }

}
