namespace Linq2
{
    internal class Program
    {
        // 3- select fname , lname
        // 1- from employees
        // 2- where salary > 5000

        static IEnumerable<string> GetNames()
        {
            yield return "John";
            yield return "Jane";
            yield return "Jack";
            yield return "Jill";
            yield return "James";
        }
        static void Main(string[] args)
        {
            #region Enumerable & Enumuator & sequence
            //var names = GetNames(); // 
            //foreach (var name in names)
            //{
            //    Console.WriteLine(name);
            //}

            //var e = names.GetEnumerator();
            //e.MoveNext();
            //Console.WriteLine(e.Current);

            //var s = new StudentNames();

            //foreach(var name in s)
            //{
            //    Console.WriteLine(name);
            //}

            //var e = s.GetEnumerator();

            //while(e.MoveNext())
            //{
            //    Console.WriteLine(e.Current);
            //}
            //e.MoveNext();
            //Console.WriteLine(e.Current);
            //e.MoveNext();
            //Console.WriteLine(e.Current);
            //foreach (var name in s)
            //{
            //    Console.WriteLine(name);
            //} 
            #endregion

            #region Deffered & Eager Execution
            //var courses = SampleData.Courses.Filter(c => c.Hours > 30);
            //var courses = SampleData.Courses.Filter(c => c.Hours >= 30); //
            //
            //var courses = SampleData.Courses.Filter(c => c.Hours >= 30).MyCount();
            //Console.WriteLine(courses);
            //var courseNames = courses.Choose(c=>c.Name).MyToList();
            //var courseNamesAndHours = courses.Choose(c => new { c.Name, c.Hours }).MyToList;

            //Console.WriteLine(courses[0].Name);


            //foreach (var course in courseNames)
            //{
            //    Console.WriteLine($"{course.Name}  , {course.Hours}");
            //} 
            #endregion

            #region where & select (query operator & query expression)
            // linq query operators
            //var courses = SampleData.Courses.Where(c => c.Hours > 30)
            //    .Select(c => new { c.Name, subjectName = c.Subject.Name, c.Hours }).Skip(2);

            // query expression
            //var courses2 = from c in SampleData.Courses
            //               where c.Hours > 30
            //               select c.Name; 
            #endregion

            #region take , takewhile, skip, skipwhile
            //var courses = SampleData.Courses.Where(c => c.Hours > 30)
            //    .Select(c => new { c.Name, subjectName = c.Subject.Name, c.Hours })
            //    .Take(2);

            //var courses2 = (from c in SampleData.Courses
            //               where c.Hours > 30
            //               select c.Name).Take(2);

            //foreach (var course in courses)
            //{
            //    Console.WriteLine($"{course.Name}  , {course.subjectName} , {course.Hours}");
            //} 
            #endregion

            #region Aggregate Functions
            //var courseNum = SampleData.Courses.Count();
            //var courseNum1 = SampleData.Courses.Where(c => c.Hours > 30).Count();
            //var courseNum2 = SampleData.Courses.Count(c => c.Hours > 30);

            //int totalHours = SampleData.Courses
            //    .Where(c => c.Department.Name == "SD")
            //    .Sum(c => c.Hours);

            //int totalHours2 = (from c in SampleData.Courses
            //                   where c.Department.Name == "SD"
            //                   select c.Hours).Sum();

            //int maxHours = SampleData.Courses.Max(c => c.Hours);

            //Console.WriteLine(maxHours); 
            #endregion

            #region join
            //var query = from dept in SampleData.Departments
            //            from course in SampleData.Courses
            //            where dept.Id == course.DepartmentId
            //            select new { dept.Name, courseName =course.Name}; // name , name 

            //var query = from dept in SampleData.Departments
            //            join course in SampleData.Courses
            //            on dept.Id equals course.DepartmentId
            //            select new { departmentName = dept.Name, courseName = course.Name }; // 
            #endregion

            #region first , last , single => ordefault 
            // first , last , single => ordefault 

            //Course course = SampleData.Courses.Single(c => c.Hours == 60);

            //Console.WriteLine(course.Name); 
            #endregion

            #region SubQuery
            //var query = from sub in SampleData.Subjects
            //            select new
            //            {
            //                subjectName = sub.Name,
            //                courses =
            //                    from crs in SampleData.Courses
            //                    where crs.Subject.Name == sub.Name
            //                    select crs
            //            };

            //foreach (var item in query)
            //{
            //    Console.WriteLine($"{item.subjectName} , {item.courses.Sum(c => c.Hours)}");
            //    foreach (var course in item.courses)
            //    {
            //        Console.WriteLine(course.Name);
            //    }
            //    Console.WriteLine("====================================");
            //} 
            #endregion

            #region OrderBy
            ////var query = SampleData.Courses.OrderBy(c => c.Hours).ThenBy(c => c.Name)
            ////    .Select(c => new {c.Name , c.Hours});

            //var query1 =
            //    from crs in SampleData.Courses
            //    orderby crs.Hours descending, crs.Name
            //    select new { crs.Name, crs.Hours };

            //foreach (var course in query1) {
            //    Console.WriteLine($"{course.Name} , {course.Hours}");
            //} 
            #endregion

            #region Group By
            //var query =
            //    from crs in SampleData.Courses
            //    group crs by crs.Subject;

            //var query =
            //    from crs in SampleData.Courses
            //    group crs by crs.Subject into g
            //    let totalHours = g.Sum(c => c.Hours)
            //    where totalHours > 40
            //    select new { subjectName = g.Key.Name, Courses = g , TotalHours = totalHours};

            //foreach (var grp in query)
            //{
            //    Console.WriteLine($"Subject Name : {grp.subjectName} , Total Hours : {grp.TotalHours}"); // 
            //    foreach(var course in grp.Courses)
            //    {
            //        Console.WriteLine($"{course.Name}");
            //    }
            //    Console.WriteLine("========================================");
            //} 
            #endregion
        }
    }
}
