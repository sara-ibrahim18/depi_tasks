using System.Security.Cryptography.X509Certificates;

namespace delegates
{
    internal static class extensions
    {
        public delegate int MathOperation(int x, int y);
        public static int Add( this int x, int y) => x + y;
        public static int Multiply(this int x, int y) => x * y;
        public static int sub(this int x, int y) => x - y;
        public static int divide(this int x, int y) => x / y;
         public static int Calc(this int x, int y,MathOperation calculations)
        {
           return calculations (x, y);
        }
        static void Main(string[] args)
        {

            Console.WriteLine(extensions.Calc(4, 3, Multiply));
            Console.WriteLine(extensions.Calc(4, 3, Add));
            Console.WriteLine(extensions.Calc(4, 3, sub));
            Console.WriteLine(extensions.Calc(4, 3,divide));
        }
    }
}
