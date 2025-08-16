using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bankSystem
{


    public abstract class Account
    {
        private static long _accSeq = 2000000000; // long for uniqueness
        public string AccountNumber { get; }
        public string CustomerId { get; }
        public DateTime DateOpened { get; }
        public decimal Balance { get; protected set; }

        public List<Transaction> Transactions { get; } = new();

        protected Account(string customerId)
        {
            CustomerId = customerId ?? throw new ArgumentNullException(nameof(customerId));
            AccountNumber = $"AC{_accSeq++}";
            DateOpened = DateTime.UtcNow;
            Balance = 0m;
        }

        public virtual void Deposit(decimal amount, string description = "Deposit", string? counterpartyAccount = null)
        {
            if (amount <= 0) throw new ArgumentException("Deposit amount must be positive.");
            Balance += amount;
            AddTx(TransactionType.Deposit, amount, description, counterpartyAccount);
        }

        public abstract void Withdraw(decimal amount, string description = "Withdrawal", string? counterpartyAccount = null);

        protected void AddTx(TransactionType type, decimal amount, string description, string? counterpartyAccount)
        {
            var tx = new Transaction(type, amount, DateTime.UtcNow, description, Balance,
                type == TransactionType.TransferOut ? AccountNumber : null,
                type == TransactionType.TransferIn ? AccountNumber : null);

            // override from/to when provided:
            if (type == TransactionType.TransferOut && counterpartyAccount != null)
                tx.ToAccountNumber = counterpartyAccount;
            if (type == TransactionType.TransferIn && counterpartyAccount != null)
                tx.FromAccountNumber = counterpartyAccount;

            Transactions.Add(tx);
        }

        protected void AddTransferOut(decimal amount, string description, string? toAccount)
        {
            AddTx(TransactionType.TransferOut, amount, description, toAccount);
        }

        protected void AddTransferIn(decimal amount, string description, string? fromAccount)
        {
            AddTx(TransactionType.TransferIn, amount, description, fromAccount);
        }
    }
}