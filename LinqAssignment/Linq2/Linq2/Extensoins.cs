using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Linq2
{
    internal static class Extensoins
    {

        public static IEnumerable<T> Filter<T>(this IEnumerable<T> source, Predicate<T> predicate)
        {
            foreach (var item in source)
            {
                if(predicate(item))
                    yield return item;  
            }
        }

        public static IEnumerable<TResult> Choose<TSource, TResult>(this IEnumerable<TSource> source, Func<TSource, TResult> chooser)
        {
            foreach (var item in source)
            {
                yield return chooser(item);
            }
        }

        public static List<T> MyToList<T>(this IEnumerable<T> source)
        {
            List<T> list = new List<T>();
            foreach (var item in source)
            {
                list.Add(item);
            }
            return list;
        }

        public static int MyCount<TSource>(this IEnumerable<TSource> source)
        {
            int counter = 0;
            foreach (var item in source)
            {
                counter++;
            }
            return counter;
        }


        //public static IEnumerable<TResult> Choose<TSource, TResult>(this IEnumerable<TSource> source, Func<TSource, TResult> chooser)
        //{
        //    foreach (var item in source)
        //    {
        //        yield return chooser(item);
        //    }
        //}

        //public static int MyCount<TSource>(this IEnumerable<TSource> source)
        //{
        //    int counter = 0;

        //    foreach (var item in source)
        //    {
        //            counter++;
        //    }
        //    return counter;
        //}
    }
}
