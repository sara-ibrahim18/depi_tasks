using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Linq2
{
    internal class StudentNames : IEnumerable
    {
        String[] names = { "John", "Jane", "Jack", "Jill", "James" };

        public IEnumerator GetEnumerator()
        {
            return new StudentNamesEnumarator(names);
        }
    }
}
