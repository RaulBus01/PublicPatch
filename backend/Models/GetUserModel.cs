using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Identity;

namespace PublicPatch.Models
{
    public class GetUserModel
    {
        public GetUserModel(int id, string username, string email,string role, DateTime createdAt, DateTime updatedAt)
        {
            Id = id;
            Username = username;
            Email = email;
            Role = role;
            CreatedAt = createdAt;
            UpdatedAt = updatedAt;
        }

        public int Id { get; set; }
        public string Username { get; set; }
        public string Email { get; set; }

        public string Role { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    }
}
