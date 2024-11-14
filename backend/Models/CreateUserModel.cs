namespace PublicPatch.Models
{
    public class CreateUserModel
    {
        public CreateUserModel(string username, string email, string password, string phoneNumber, string role)
        {
            Username = username;
            Email = email;
            Password = password;
            PhoneNumber = phoneNumber;
            Role = role;
        }
        public string Username { get; set; }
        public string Email { get; set; }
        public string Password { get; }
        public string PhoneNumber { get; set; }
        public string Role { get; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    }
}
