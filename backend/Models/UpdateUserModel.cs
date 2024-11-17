namespace PublicPatch.Models
{
    public class UpdateUserModel
    {
        public UpdateUserModel(int id, string username, string email, string phoneNumber)
        {
            Id = id;
            Username = username;
            Email = email;
        }
        public int Id { get; set; }
        public string Username { get; set; }
        public string Email { get; set; }
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    }
}
