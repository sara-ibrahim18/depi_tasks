using System.Collections.Generic;

namespace ConsoleApp1
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello!");
         
            Console.WriteLine("Input the first number: ");
            int x=Convert.ToInt32(Console.ReadLine());
            Console.WriteLine("Input the second number");
            int y = Convert.ToInt32(Console.ReadLine());
            
            
           
                Console.WriteLine("What do you want to do with those numbers?");
                Console.WriteLine("[A]add");
                Console.WriteLine("[S]subtract");
                Console.WriteLine("[M]multiply ");
                char ch = Console.ReadLine()[0];
                if(ch =='A'||ch=='a')
                {
                Console.WriteLine($"{x}+{y}={x+y}");
                }
                else if(ch =='S'||ch=='s')
                {
                    Console.WriteLine($"{x} - {y} = {x - y}");
                }
                else if (ch == 'M' || ch == 'm')
                {
                    Console.WriteLine($"{x} * {y} = {x * y}");
                }
                else
                {
                    Console.WriteLine("Invalid option");
                }
            Console.WriteLine("Press any key to close");
            Console.ReadKey();

                    




        }
    }
}
