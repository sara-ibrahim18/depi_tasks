namespace bank
{
    internal class Program
    {
        static void Main(string[] args)
        {
            BankAccount account1 = new BankAccount();
            account1.ShowAccountDetails();

          
            BankAccount account2 = new BankAccount(
                fullName: "Sara Ibrahim",
                nationalID: "29805250123456",
                phoneNumber: "01271158619",
                address: "Cairo, Egypt",
                balance: 1500.75m
            );
            account2.ShowAccountDetails();

         
            Console.WriteLine($"Is National ID Valid? {account2.IsValidNationalID()}");
            Console.WriteLine($"Is Phone Number Valid? {account2.IsValidPhoneNumber()}");
        }
    }
}




public class BankAccount
{
   
    public const string BankCode = "BNK001";

   
    public readonly DateTime CreatedDate;


    private int _accountNumber;
    private string _fullName;
    private string _nationalID;
    private string _phoneNumber;
    private string _address;
    private decimal _balance;

    
    public string FullName
    {
        get
        {
            return _fullName;
        }
        set
        {
            if (string.IsNullOrWhiteSpace(value))
                throw new ArgumentException("Full name cannot be empty.");
            _fullName = value;
        }
    }

    public string NationalID
    {
        get
        {
            return _nationalID;
        }
        set
        {
            if (value.Length != 14 || !ulong.TryParse(value, out _))
                throw new ArgumentException("National ID must be exactly 14 digits.");
            _nationalID = value;
        }
    }

    public string PhoneNumber
    {
        get
        {
            return _phoneNumber;
        }
        set
        {
            if (value.Length != 11 || !value.StartsWith("01") || !ulong.TryParse(value, out _))
                throw new ArgumentException("Phone number must start with '01' and be 11 digits.");
            _phoneNumber = value;
        }
    }

    public decimal Balance
    {
        get
        {
            return _balance;
        }
        set
        {
            if (value < 0)
                throw new ArgumentException("Balance cannot be negative.");
            _balance = value;
        }
    }

    public string Address
    {
        get
        {
            return _address;
        }
        set
        {
            _address= value;
        }
    }

  
    public BankAccount()
    {
        _accountNumber = 0;
        FullName = "Unknown";
        NationalID = "00000000000000";
        PhoneNumber = "01000000000";
        Address = "Not Provided";
        Balance = 0;
        CreatedDate = DateTime.Now;
    }

   
    public BankAccount(string fullName, string nationalID, string phoneNumber, string address, decimal balance)
    {
        FullName = fullName;
        NationalID = nationalID;
        PhoneNumber = phoneNumber;
        Address = address;
        Balance = balance;
        CreatedDate = DateTime.Now;
    }


    public BankAccount(string fullName, string nationalID, string phoneNumber, string address)
    {
        FullName = fullName;
        NationalID = nationalID;
        PhoneNumber = phoneNumber;
        Address = address;
        Balance = 0;
        CreatedDate = DateTime.Now;
    }


    public void ShowAccountDetails()
    {
        Console.WriteLine("---- Account Information ----");
        Console.WriteLine($"Bank Code: {BankCode}");
        Console.WriteLine($"Account Holder: {FullName}");
        Console.WriteLine($"National ID: {NationalID}");
        Console.WriteLine($"Phone Number: {PhoneNumber}");
        Console.WriteLine($"Address: {Address}");
        Console.WriteLine($"Balance: {Balance:C}");
        Console.WriteLine($"Created Date: {CreatedDate}");
        Console.WriteLine("------------------------------\n");
    }

    public bool IsValidNationalID()
    {
        return NationalID.Length == 14 && ulong.TryParse(NationalID, out _);
    }

    public bool IsValidPhoneNumber()
    {
        return PhoneNumber.StartsWith("01") && PhoneNumber.Length == 11 && ulong.TryParse(PhoneNumber, out _);
    }
}
