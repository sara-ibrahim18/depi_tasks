using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystem
{
    internal class StudentExam
    {
        public Student Student { get; set; }
        public Exam Exam { get; set; }
        public Dictionary<Question, object> Answers { get; set; } = new();

        public StudentExam(Student student, Exam exam)
        {
            Student = student;
            Exam = exam;
            student.Attempts.Add(this);
        }

        public double CalculateScore()
        {
            double score = 0;
            foreach (var q in Exam.Questions)
            {
                if (Answers.TryGetValue(q, out var ans))
                {
                    if (q.Type == QuestionType.MultipleChoice && (int)ans == q.CorrectOptionIndex)
                        score += q.Mark;
                    else if (q.Type == QuestionType.TrueFalse && (bool)ans == q.CorrectTrueFalse)
                        score += q.Mark;
                    else if (q.Type == QuestionType.Essay && ans is double m)
                        score += m;
                }
            }
            return score;
        }

        public bool IsPass() => CalculateScore() >= 0.5 * Exam.TotalMarks;
    }
}

