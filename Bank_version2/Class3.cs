using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bank_version2
{
    internal class CurrentAccount:BankAccount
    {
        public decimal OverdraftLimit { get; set; }
        public CurrentAccount(string fullName, string nationalID, string phoneNumber, string address, decimal balance, decimal overdraftLimit)
            : base(fullName, nationalID, phoneNumber, address, balance)
        {
            OverdraftLimit = overdraftLimit;
        }
        public override decimal CalculateInterest()
        {
            return 0;
        }
        public override void ShowAccountDetails()
        {
            base.ShowAccountDetails();
            Console.WriteLine($"Overdraft Limit: {OverdraftLimit:C}");
            Console.WriteLine("------------------------------\n");
        }

    }
}
