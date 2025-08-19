using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystem
{
    
        public enum QuestionType
        {
            MultipleChoice,
            TrueFalse,
            Essay
        }

        internal class Question
        {
            public string Text { get; set; }
            public QuestionType Type { get; set; }
            public List<string> Options { get; set; } = new();
            public int CorrectOptionIndex { get; set; }
            public bool CorrectTrueFalse { get; set; }
            public double Mark { get; set; }

            public Question(string text, QuestionType type, double mark)
            {
                Text = text;
                Type = type;
                Mark = mark;
            }
        }
    }

