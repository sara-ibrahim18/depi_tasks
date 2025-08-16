using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bankSystem
{
   
        public class Customer
        {
            private static int _seq = 1000;

            public string CustomerId { get; }
            public string NationalId { get; }
            public DateTime DateOfBirth { get; set; }
            public string FullName { get; set; }

            public Customer(string fullName, string nationalId, DateTime dateOfBirth)
            {
                FullName = string.IsNullOrWhiteSpace(fullName) ? throw new ArgumentException("Full name required") : fullName.Trim();
                NationalId = string.IsNullOrWhiteSpace(nationalId) ? throw new ArgumentException("National ID required") : nationalId.Trim();
                DateOfBirth = dateOfBirth;

                CustomerId = $"C{_seq++}";
            }
        }
    }
