using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bankSystem
{
    
    
        public class Bank
        {
            public string Name { get; }
            public string BranchCode { get; }

            private readonly Dictionary<string, Customer> _customers = new();
            private readonly Dictionary<string, Account> _accounts = new();

            public Bank(string name, string branchCode)
            {
                Name = string.IsNullOrWhiteSpace(name) ? throw new ArgumentException("Bank name required") : name.Trim();
                BranchCode = string.IsNullOrWhiteSpace(branchCode) ? throw new ArgumentException("Branch code required") : branchCode.Trim();
            }

            // ==== Customers ====
            public Customer AddCustomer(string fullName, string nationalId, DateTime dateOfBirth)
            {
                if (string.IsNullOrWhiteSpace(fullName)) throw new ArgumentException("Full name required.");
                if (string.IsNullOrWhiteSpace(nationalId)) throw new ArgumentException("National ID required.");

                if (_customers.Values.Any(c => c.NationalId.Equals(nationalId, StringComparison.OrdinalIgnoreCase)))
                    throw new InvalidOperationException("National ID already exists.");

                var customer = new Customer(fullName.Trim(), nationalId.Trim(), dateOfBirth);
                _customers[customer.CustomerId] = customer;
                return customer;
            }

            public void UpdateCustomer(string customerId, string? newFullName, DateTime? newDob)
            {
                var c = GetCustomer(customerId);
                if (!string.IsNullOrWhiteSpace(newFullName)) c.FullName = newFullName.Trim();
                if (newDob.HasValue) c.DateOfBirth = newDob.Value;
            }

            public void RemoveCustomer(string customerId)
            {
                var c = GetCustomer(customerId);
                var custAccounts = _accounts.Values.Where(a => a.CustomerId == customerId).ToList();
                if (custAccounts.Any(a => a.Balance != 0))
                    throw new InvalidOperationException("Cannot remove customer: all accounts must have zero balance.");

                // Close and remove accounts (should all be zero)
                foreach (var acc in custAccounts)
                    _accounts.Remove(acc.AccountNumber);

                _customers.Remove(customerId);
            }

            public List<Customer> SearchCustomers(string query)
            {
                query = query?.Trim() ?? "";
                return _customers.Values
                    .Where(c => c.FullName.Contains(query, StringComparison.OrdinalIgnoreCase)
                                || c.NationalId.Equals(query, StringComparison.OrdinalIgnoreCase))
                    .OrderBy(c => c.FullName)
                    .ToList();
            }

            public Customer GetCustomer(string customerId)
            {
                if (!_customers.TryGetValue(customerId, out var c))
                    throw new KeyNotFoundException("Customer not found.");
                return c;
            }

            // ==== Accounts ====
            public SavingsAccount OpenSavingsAccount(string customerId, decimal initialBalance, decimal monthlyInterestRate)
            {
                var c = GetCustomer(customerId);
                var acc = new SavingsAccount(c.CustomerId, monthlyInterestRate);
                if (initialBalance > 0) acc.Deposit(initialBalance, "Initial deposit");
                _accounts[acc.AccountNumber] = acc;
                return acc;
            }

            public CurrentAccount OpenCurrentAccount(string customerId, decimal initialBalance, decimal overdraftLimit)
            {
                var c = GetCustomer(customerId);
                var acc = new CurrentAccount(c.CustomerId, overdraftLimit);
                if (initialBalance != 0) acc.Deposit(initialBalance, "Initial deposit"); // allow negative? initial deposit should be >=0; enforce:
                _accounts[acc.AccountNumber] = acc;
                return acc;
            }

            public Account GetAccount(string accountNumber)
            {
                if (!_accounts.TryGetValue(accountNumber, out var acc))
                    throw new KeyNotFoundException("Account not found.");
                return acc;
            }

            // ==== Operations ====
            public void Deposit(string accountNumber, decimal amount, string description = "Deposit")
            {
                var acc = GetAccount(accountNumber);
                acc.Deposit(amount, description);
            }

            public void Withdraw(string accountNumber, decimal amount, string description = "Withdrawal")
            {
                var acc = GetAccount(accountNumber);
                acc.Withdraw(amount, description);
            }

            public void Transfer(string fromAccountNo, string toAccountNo, decimal amount, string description = "Transfer")
            {
                if (fromAccountNo == toAccountNo) throw new ArgumentException("Cannot transfer to the same account.");
                var from = GetAccount(fromAccountNo);
                var to = GetAccount(toAccountNo);

                // Withdraw then deposit atomically (as much as possible in-memory)
                from.Withdraw(amount, $"{description} -> {to.AccountNumber}", toAccountNo);
                to.Deposit(amount, $"{description} <- {from.AccountNumber}", from.AccountNumber);
            }

            // ==== Reporting & Calculations ====
            public decimal GetCustomerTotalBalance(string customerId)
            {
                GetCustomer(customerId); // validate exists
                return _accounts.Values.Where(a => a.CustomerId == customerId).Sum(a => a.Balance);
            }

            /// <summary>
            /// Calculates and APPLIES monthly interest for all savings accounts for the given year/month.
            /// Returns the total applied interest.
            /// </summary>
            public decimal ApplyMonthlyInterestToAllSavings(int year, int month)
            {
                if (month < 1 || month > 12) throw new ArgumentOutOfRangeException(nameof(month));
                var total = 0m;
                foreach (var s in _accounts.Values.OfType<SavingsAccount>())
                {
                    var interest = s.CalculateMonthlyInterest(year, month);
                    if (interest != 0)
                    {
                        s.Deposit(interest, $"Monthly interest {year}-{month:00}");
                        total += interest;
                    }
                }
                return total;
            }

            public string GenerateBankReport()
            {
                var sb = new StringBuilder();
                sb.AppendLine($"Bank Report - {Name} (Branch {BranchCode}) - Generated {DateTime.UtcNow:u}");
                sb.AppendLine(new string('-', 70));

                foreach (var cust in _customers.Values.OrderBy(c => c.FullName))
                {
                    sb.AppendLine($"Customer: {cust.FullName} | ID: {cust.CustomerId} | NID: {cust.NationalId} | DOB: {cust.DateOfBirth:yyyy-MM-dd}");
                    var custAccs = _accounts.Values.Where(a => a.CustomerId == cust.CustomerId).OrderBy(a => a.AccountNumber).ToList();
                    if (custAccs.Count == 0)
                    {
                        sb.AppendLine("  (No accounts)");
                    }
                    else
                    {
                        foreach (var acc in custAccs)
                        {
                            sb.AppendLine($"  - {acc.GetType().Name} #{acc.AccountNumber} | Opened: {acc.DateOpened:yyyy-MM-dd} | Balance: {acc.Balance}");
                            if (acc is SavingsAccount sa)
                                sb.AppendLine($"      MonthlyInterestRate: {sa.MonthlyInterestRate:P}");
                            if (acc is CurrentAccount ca)
                                sb.AppendLine($"      OverdraftLimit: {ca.OverdraftLimit}");
                        }
                        var total = custAccs.Sum(a => a.Balance);
                        sb.AppendLine($"  >> Total Customer Balance: {total}");
                    }
                    sb.AppendLine();
                }

                return sb.ToString();
            }
        }
    }
