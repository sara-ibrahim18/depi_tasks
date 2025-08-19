using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystem
{
    internal class Exam
    {
        public string Title { get; set; }
        public Course Course { get; set; }
        public List<Question> Questions { get; set; } = new();

        public Exam(string title, Course course)
        {
            Title = title;
            Course = course;
            course.Exams.Add(this);
        }

        public double TotalMarks => Questions.Sum(q => q.Mark);

        public void AddQuestion(Question q)
        {
            if (TotalMarks + q.Mark > Course.MaximumDegree)
                throw new InvalidOperationException("Cannot exceed course maximum degree.");
            Questions.Add(q);
        }
    }
}
