using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bankSystem
{
    public class CurrentAccount : Account
    {
        public decimal OverdraftLimit { get; }

        public CurrentAccount(string customerId, decimal overdraftLimit) : base(customerId)
        {
            if (overdraftLimit < 0) throw new ArgumentException("Overdraft limit cannot be negative.");
            OverdraftLimit = overdraftLimit;
        }

        public override void Withdraw(decimal amount, string description = "Withdrawal", string? counterpartyAccount = null)
        {
            if (amount <= 0) throw new ArgumentException("Withdrawal amount must be positive.");
            var newBalance = Balance - amount;
            if (newBalance < -OverdraftLimit)
                throw new InvalidOperationException("Overdraft limit exceeded.");

            Balance = newBalance;

            if (counterpartyAccount == null)
                Transactions.Add(new Transaction(TransactionType.Withdrawal, amount, DateTime.UtcNow, description, Balance));
            else
                AddTransferOut(amount, description, counterpartyAccount);
        }
    }
}