namespace ExaminationSystem
{
    internal class Program
    {
        static void Main(string[] args)
        {
            
       

       
              Course csharp = new Course("C# Fundamentals", "Intro to C#", 100);
                Student s1 = new Student(1, "Amina Ali", "amina@example.com");
                Student s2 = new Student(2, "Omar Said", "omar@example.com");
                Instructor inst = new Instructor(1, "Dr. Salma", "Programming");

                csharp.EnrollStudent(s1);
                csharp.EnrollStudent(s2);
                csharp.AssignInstructor(inst);

                Exam midterm = new Exam("Midterm", csharp);

                Question q1 = new Question("What is 2+2?", QuestionType.MultipleChoice, 20);
                q1.Options.AddRange(new[] { "3", "4", "5" });
                q1.CorrectOptionIndex = 1;
                midterm.AddQuestion(q1);

                Question q2 = new Question("C# is case sensitive.", QuestionType.TrueFalse, 20);
                q2.CorrectTrueFalse = true;
                midterm.AddQuestion(q2);

                Question q3 = new Question("Explain encapsulation.", QuestionType.Essay, 60);
                midterm.AddQuestion(q3);

                // Student 1 answers
                StudentExam attempt1 = new StudentExam(s1, midterm);
                attempt1.Answers[q1] = 1;
                attempt1.Answers[q2] = true;
                attempt1.Answers[q3] = 50.0; // instructor graded

                // Student 2 answers
                StudentExam attempt2 = new StudentExam(s2, midterm);
                attempt2.Answers[q1] = 0;
                attempt2.Answers[q2] = false;
                attempt2.Answers[q3] = 20.0;

                PrintReport(attempt1);
                PrintReport(attempt2);

                CompareStudents(attempt1, attempt2);
            }

            static void PrintReport(StudentExam attempt)
            {
                Console.WriteLine("==================== Report ====================");
                Console.WriteLine($"Exam Title : {attempt.Exam.Title}");
                Console.WriteLine($"Student    : {attempt.Student.Name}");
                Console.WriteLine($"Course     : {attempt.Exam.Course.Title}");
                Console.WriteLine($"Score      : {attempt.CalculateScore()}");
                Console.WriteLine($"Status     : {(attempt.IsPass() ? "Pass" : "Fail")}");
            }

            static void CompareStudents(StudentExam a, StudentExam b)
            {
                double scoreA = a.CalculateScore();
                double scoreB = b.CalculateScore();

                if (scoreA == scoreB)
                    Console.WriteLine("\nBoth students tied.");
                else if (scoreA > scoreB)
                    Console.WriteLine($"\nWinner: {a.Student.Name} with {scoreA} vs {scoreB}");
                else
                    Console.WriteLine($"\nWinner: {b.Student.Name} with {scoreB} vs {scoreA}");
            }
        }
    }

