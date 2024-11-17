using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using Microsoft.EntityFrameworkCore;

namespace PublicPatch.Aggregates
{
    [Index(nameof(Email), IsUnique = true)]

    public class UserEntity
    {
        public UserEntity() { }
        public UserEntity(string username, string email, string role, string password) {
            this.Username = username;
            this.Email = email;
            this.Role = role;
            this.Password = password;
        }

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [Required]
        [MaxLength(50)]
        public string Username { get; set; }

        [Required]
        [EmailAddress]
        
        [MaxLength(100)]
        public string Email { get; set; }

        [Required]
        public string Password { get; set; }

        [MaxLength(20)]
        public string Role { get; set; }

        [Phone]
        [MaxLength(15)]


        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    }
}
