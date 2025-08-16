using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bankSystem
{
    public class SavingsAccount : Account
    {
        public decimal MonthlyInterestRate { get; }

        public SavingsAccount(string customerId, decimal monthlyInterestRate) : base(customerId)
        {
            if (monthlyInterestRate < 0) throw new ArgumentException("Monthly interest rate cannot be negative.");
            MonthlyInterestRate = monthlyInterestRate;
        }

        public override void Withdraw(decimal amount, string description = "Withdrawal", string? counterpartyAccount = null)
        {
            if (amount <= 0) throw new ArgumentException("Withdrawal amount must be positive.");
            if (amount > Balance) throw new InvalidOperationException("Insufficient funds for savings account.");
            Balance -= amount;

            if (counterpartyAccount == null)
                Transactions.Add(new Transaction(TransactionType.Withdrawal, amount, DateTime.UtcNow, description, Balance));
            else
                AddTransferOut(amount, description, counterpartyAccount);
        }

       
        public decimal CalculateMonthlyInterest(int year, int month)
        {
            if (month < 1 || month > 12) throw new ArgumentOutOfRangeException(nameof(month));
           
            return Math.Round(Balance * MonthlyInterestRate, 2, MidpointRounding.AwayFromZero);
        }
    }
}