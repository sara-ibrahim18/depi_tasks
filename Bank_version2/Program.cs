namespace bank_version2
{
    internal class Program
    {
        static void Main(string[] args)
        {
            SavingAccount savingAcc = new SavingAccount("SARA ibrahim", "12345678901234", "01012345678", "Cairo", 5000, 5);
            CurrentAccount currentAcc = new CurrentAccount("Mona Ali", "98765432109876", "01087654321", "Giza", 2000, 1000);

            
            List<BankAccount> accounts = new List<BankAccount> { savingAcc, currentAcc };

        
            foreach (var acc in accounts)
            {
                acc.ShowAccountDetails();
                Console.WriteLine($"Calculated Interest: {acc.CalculateInterest():C}\n");
            }
        }
    }
}
