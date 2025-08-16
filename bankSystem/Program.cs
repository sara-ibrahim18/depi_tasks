using System.Globalization;

namespace bankSystem
{
    internal class Program
    {
        static void Main(string[] args)
        {

            Console.OutputEncoding = System.Text.Encoding.UTF8;

            // 1) Create bank at start
            Console.Write("Enter Bank Name: ");
            string bankName = Console.ReadLine()!.Trim();

            Console.Write("Enter Branch Code: ");
            string branchCode = Console.ReadLine()!.Trim();

            var bank = new Bank(bankName, branchCode);
            Console.WriteLine($"Bank '{bank.Name}' (Branch {bank.BranchCode}) created.\n");

            var ui = new ConsoleMenu(bank);
            ui.Run();
        }
    }

    public class ConsoleMenu
    {
        private readonly Bank _bank;

        public ConsoleMenu(Bank bank) => _bank = bank;

        public void Run()
        {
            while (true)
            {
                Console.WriteLine("\n==== BANK MENU ====");
                Console.WriteLine("1) Add Customer");
                Console.WriteLine("2) Update Customer (name/dob)");
                Console.WriteLine("3) Remove Customer (if all accounts zero)");
                Console.WriteLine("4) Search Customer (by name or national id)");
                Console.WriteLine("5) Open Account (Savings/Current)");
                Console.WriteLine("6) Deposit");
                Console.WriteLine("7) Withdraw");
                Console.WriteLine("8) Transfer");
                Console.WriteLine("9) Customer Total Balance");
                Console.WriteLine("10) Calculate Monthly Interest for Savings (apply)");
                Console.WriteLine("11) Bank Report (all customers & accounts)");
                Console.WriteLine("12) Show Account Transactions");
                Console.WriteLine("0) Exit");
                Console.Write("Choose: ");

                var choice = Console.ReadLine();
                Console.WriteLine();
                try
                {
                    switch (choice)
                    {
                        case "1": AddCustomer(); break;
                        case "2": UpdateCustomer(); break;
                        case "3": RemoveCustomer(); break;
                        case "4": SearchCustomer(); break;
                        case "5": OpenAccount(); break;
                        case "6": Deposit(); break;
                        case "7": Withdraw(); break;
                        case "8": Transfer(); break;
                        case "9": CustomerTotalBalance(); break;
                        case "10": ApplyMonthlyInterest(); break;
                        case "11": BankReport(); break;
                        case "12": ShowTransactions(); break;
                        case "0": return;
                        default: Console.WriteLine("Invalid choice."); break;
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"[ERROR] {ex.Message}");
                }
            }
        }

        private void AddCustomer()
        {
            Console.Write("Full Name: ");
            var fullName = Console.ReadLine()!.Trim();

            Console.Write("National ID: ");
            var nationalId = Console.ReadLine()!.Trim();

            Console.Write("Date of Birth (yyyy-MM-dd): ");
            var dobStr = Console.ReadLine()!.Trim();

            if (!DateTime.TryParseExact(dobStr, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out var dob))
                throw new ArgumentException("Invalid date format.");

            var customer = _bank.AddCustomer(fullName, nationalId, dob);
            Console.WriteLine($"Customer added. ID: {customer.CustomerId}");
        }

        private void UpdateCustomer()
        {
            Console.Write("Customer ID: ");
            var id = Console.ReadLine()!.Trim();

            Console.Write("New Full Name (leave empty to keep): ");
            var name = Console.ReadLine()!;

            Console.Write("New Date of Birth (yyyy-MM-dd) (leave empty to keep): ");
            var dobStr = Console.ReadLine()!;

            DateTime? dob = null;
            if (!string.IsNullOrWhiteSpace(dobStr))
            {
                if (!DateTime.TryParseExact(dobStr, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out var parsed))
                    throw new ArgumentException("Invalid date format.");
                dob = parsed;
            }

            _bank.UpdateCustomer(id, string.IsNullOrWhiteSpace(name) ? null : name.Trim(), dob);
            Console.WriteLine("Customer updated.");
        }

        private void RemoveCustomer()
        {
            Console.Write("Customer ID: ");
            var id = Console.ReadLine()!.Trim();
            _bank.RemoveCustomer(id);
            Console.WriteLine("Customer removed.");
        }

        private void SearchCustomer()
        {
            Console.Write("Enter Name or National ID: ");
            var q = Console.ReadLine()!.Trim();

            var results = _bank.SearchCustomers(q);
            if (results.Count == 0) { Console.WriteLine("No results."); return; }

            foreach (var c in results)
            {
                Console.WriteLine($"ID:{c.CustomerId} | {c.FullName} | NID:{c.NationalId} | DOB:{c.DateOfBirth:yyyy-MM-dd}");
            }
        }

        private void OpenAccount()
        {
            Console.Write("Customer ID: ");
            var customerId = Console.ReadLine()!.Trim();

            Console.Write("Type (1=Saving, 2=Current): ");
            var t = Console.ReadLine()!.Trim();

            if (t == "1")
            {
                Console.Write("Initial Balance: ");
                var bal = decimal.Parse(Console.ReadLine()!.Trim());

                Console.Write("Monthly Interest Rate (e.g., 0.01 for 1%): ");
                var rate = decimal.Parse(Console.ReadLine()!.Trim(), CultureInfo.InvariantCulture);

                var acc = _bank.OpenSavingsAccount(customerId, bal, rate);
                Console.WriteLine($"Savings account opened. No: {acc.AccountNumber}");
            }
            else if (t == "2")
            {
                Console.Write("Initial Balance: ");
                var bal = decimal.Parse(Console.ReadLine()!.Trim());

                Console.Write("Overdraft Limit: ");
                var od = decimal.Parse(Console.ReadLine()!.Trim());

                var acc = _bank.OpenCurrentAccount(customerId, bal, od);
                Console.WriteLine($"Current account opened. No: {acc.AccountNumber}");
            }
            else
            {
                Console.WriteLine("Invalid type.");
            }
        }

        private void Deposit()
        {
            Console.Write("Account Number: ");
            var accNo = Console.ReadLine()!.Trim();

            Console.Write("Amount: ");
            var amount = decimal.Parse(Console.ReadLine()!.Trim());

            _bank.Deposit(accNo, amount, "Cash deposit");
            Console.WriteLine("Deposited.");
        }

        private void Withdraw()
        {
            Console.Write("Account Number: ");
            var accNo = Console.ReadLine()!.Trim();

            Console.Write("Amount: ");
            var amount = decimal.Parse(Console.ReadLine()!.Trim());

            _bank.Withdraw(accNo, amount, "Cash withdrawal");
            Console.WriteLine("Withdrawn.");
        }

        private void Transfer()
        {
            Console.Write("From Account Number: ");
            var from = Console.ReadLine()!.Trim();

            Console.Write("To Account Number: ");
            var to = Console.ReadLine()!.Trim();

            Console.Write("Amount: ");
            var amount = decimal.Parse(Console.ReadLine()!.Trim());

            _bank.Transfer(from, to, amount, "Account transfer");
            Console.WriteLine("Transferred.");
        }

        private void CustomerTotalBalance()
        {
            Console.Write("Customer ID: ");
            var id = Console.ReadLine()!.Trim();

            var total = _bank.GetCustomerTotalBalance(id);
            Console.WriteLine($"Total Balance = {total}");
        }

        private void ApplyMonthlyInterest()
        {
            Console.Write("Year (e.g., 2025): ");
            var y = int.Parse(Console.ReadLine()!.Trim());

            Console.Write("Month (1-12): ");
            var m = int.Parse(Console.ReadLine()!.Trim());

            var totalApplied = _bank.ApplyMonthlyInterestToAllSavings(y, m);
            Console.WriteLine($"Applied total interest across savings accounts: {totalApplied}");
        }

        private void BankReport()
        {
            Console.WriteLine(_bank.GenerateBankReport());
        }

        private void ShowTransactions()
        {
            Console.Write("Account Number: ");
            var accNo = Console.ReadLine()!.Trim();

            var acc = _bank.GetAccount(accNo);
            Console.WriteLine($"Transactions for Account {acc.AccountNumber} ({acc.GetType().Name})");
            foreach (var t in acc.Transactions)
            {
                Console.WriteLine($"{t.DateUtc:u} | {t.Type} | {t.Amount} | BalAfter:{t.BalanceAfter} | {t.Description} | From:{t.FromAccountNumber ?? "-"} | To:{t.ToAccountNumber ?? "-"}");
            }
        }
    }
}
        