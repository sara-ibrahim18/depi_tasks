using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Linq2
{
    internal class StudentNamesEnumarator : IEnumerator
    {
        private string[] names;
        private int position = -1;

        public StudentNamesEnumarator(string[] names)
        {
            this.names = names;
        }

        public object Current
        {
            get
            {
                return names[position];
            }
        }

        public bool MoveNext()
        {
            position++; // 0
            if(position < names.Length)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public void Reset()
        {
            throw new NotImplementedException();
        }
    }
}
