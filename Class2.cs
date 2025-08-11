using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bank_version2
{
    internal class SavingAccount:BankAccount
    {
        public decimal InterestRate
        {
            get;set;
        }
       
        public SavingAccount(string fullName, string nationalID, string phoneNumber, string address, decimal balance ,decimal interestRate):base ( fullName,  nationalID,  phoneNumber,  address,  balance)
        {
            InterestRate = interestRate;
        }
        public override decimal CalculateInterest()
        {
            return (Balance * InterestRate / 100);
        }
        public override void ShowAccountDetails()
        {
            base.ShowAccountDetails();
            Console.WriteLine($"Interest Rate: {InterestRate}%");
            Console.WriteLine("------------------------------\n");
        }

    }
}
