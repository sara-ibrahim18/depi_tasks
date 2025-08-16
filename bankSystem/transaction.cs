using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bankSystem
{
   
        public enum TransactionType
        {
            Deposit,
            Withdrawal,
            TransferOut,
            TransferIn
        }

        public class Transaction
        {
            private static long _seq = 1;
            public string TransactionId { get; }
            public TransactionType Type { get; }
            public decimal Amount { get; }
            public DateTime DateUtc { get; }
            public string Description { get; }
            public decimal BalanceAfter { get; }
            public string? FromAccountNumber { get; set; }
            public string? ToAccountNumber { get; set; }

            public Transaction(TransactionType type, decimal amount, DateTime dateUtc, string description, decimal balanceAfter,
                string? fromAccountNumber = null, string? toAccountNumber = null)
            {
                TransactionId = $"TX{_seq++}";
                Type = type;
                Amount = amount;
                DateUtc = dateUtc;
                Description = description ?? "";
                BalanceAfter = balanceAfter;
                FromAccountNumber = fromAccountNumber;
                ToAccountNumber = toAccountNumber;
            }
        }
    }
