using EF_CodefFirst.Models;

namespace EF_CodefFirst
{
    internal class Program

    {
        static int CurrentAuthorId = 0;
        #region login
        static void Login()
        {
            Console.Write("\nEnter username: ");
            string uname = Console.ReadLine();

            Console.Write("Enter password: ");
            string pass = Console.ReadLine();

            var context = new S1Context();

            var author = context.authors.FirstOrDefault(a => a.user_name == uname && a.password == pass);

            if (author != null)
            {
                CurrentAuthorId = author.Id;
                Console.WriteLine($" Welcome {author.Name}");
            }
            else
            {
                Console.WriteLine(" Invalid login.");
            }

        }
        #endregion
        #region create
        static void CreateNews()
        {
            Console.Write("News Title: ");
            string title = Console.ReadLine();

            Console.Write("News Description: ");
            string desc = Console.ReadLine();

            Console.Write("Category ID: ");
            int catId = int.Parse(Console.ReadLine());

            var context = new S1Context();

            var newsItem = new news
            {
                Name = title,
                Desc = desc,
                date = DateOnly.FromDateTime(DateTime.Now),
                time = TimeOnly.FromDateTime(DateTime.Now),
                AuthorId = CurrentAuthorId,
                CategoryId = catId
            };

            context.newss.Add(newsItem);
            context.SaveChanges();

            Console.WriteLine("News Created!");

        }
        #endregion
        #region read
        static void ReadMyNews()
        {
            using (var context = new S1Context())
            {
                var myNews = context.newss
                    .Where(n => n.AuthorId == CurrentAuthorId)
                    .ToList();

                Console.WriteLine("\n My News:");
                foreach (var n in myNews)
                {
                    Console.WriteLine($"ID: {n.Id}, Title: {n.Name}, Date: {n.date}, Time: {n.time}");
                }
            }
        }

        #endregion
        #region update
        static void UpdateNews()
        {
            Console.Write("Enter News ID to update: ");
            int id = int.Parse(Console.ReadLine());

            var context = new S1Context();

            var newsItem = context.newss.FirstOrDefault(n => n.Id == id && n.AuthorId == CurrentAuthorId);

            if (newsItem != null)
            {
                Console.Write("New Title: ");
                newsItem.Name = Console.ReadLine();

                Console.Write("New Description: ");
                newsItem.Desc = Console.ReadLine();

                context.SaveChanges();
                Console.WriteLine("News Updated!");
            }
            else
            {
                Console.WriteLine(" News not found or you don’t have permission to update it.");
            }

        }




        #endregion
        #region delete
        static void DeleteNews()
        {
            Console.Write("Enter News ID to delete: ");
            int id = int.Parse(Console.ReadLine());

            var context = new S1Context();

            var newsItem = context.newss.FirstOrDefault(n => n.Id == id && n.AuthorId == CurrentAuthorId);

            if (newsItem != null)
            {
                context.newss.Remove(newsItem);
                context.SaveChanges();
                Console.WriteLine(" News Deleted!");
            }
            else
            {
                Console.WriteLine(" News not found or you don’t have permission to delete it.");
            }
        }


        #endregion
        #region read others
        static void ReadOtherNews()
        {
            using var context = new S1Context();
            
                var otherNews = context.newss
                    .Where(n => n.AuthorId != CurrentAuthorId) 
                    .ToList();

                Console.WriteLine("\n Other Authors' News:");
                foreach (var n in otherNews)
                {
                    Console.WriteLine($"ID: {n.Id}, Title: {n.Name}, Author ID: {n.AuthorId}, Date: {n.date}, Time: {n.time}");
                }
  
        }
        #endregion

        static void Main(string[] args)
        {
           
            while (true)
            {
                if (CurrentAuthorId == 0)
                {
                    Login();
                }
                else
                {
                    Console.WriteLine("\nChoose an option:");
                    Console.WriteLine("1 - Create News");
                    Console.WriteLine("2 - Read My News");
                    Console.WriteLine("3 - Update News");
                    Console.WriteLine("4 - Delete News");
                    Console.WriteLine("5 - Read Other Authors' News");
                    Console.WriteLine("6 - Logout");

                    var choice = Console.ReadLine();

                    switch (choice)
                    {
                        case "1": CreateNews(); break;
                        case "2": ReadMyNews(); break;
                        case "3": UpdateNews(); break;
                        case "4": DeleteNews(); break;
                        case "5": ReadOtherNews(); break;
                        case "6": CurrentAuthorId = 0; Console.WriteLine("Logged out."); break;
                        default: Console.WriteLine(" Invalid choice."); break;
                    }
                }
            }
        }


    }
}