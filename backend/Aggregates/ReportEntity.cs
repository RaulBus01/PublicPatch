using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PublicPatch.Aggregates
{
    public class ReportEntity
    {
        public ReportEntity()
        {
        }

        public ReportEntity(string title, LocationEntity location, int categoryId, Category category, string description, int userId, int upvotes, int downvotes, ICollection<string> reportImages)
        {
            Title = title;
            Location = location;
            Category = category;
            Description = description;
            UserId = userId;
            Status = Status.Pending;
            CreatedAt = DateTime.UtcNow;
            UpdatedAt = DateTime.UtcNow;
            Upvotes = upvotes;
            Downvotes = downvotes;
            ReportImages = reportImages;
        }

        [Key]
        public int Id { get; set; }
        public string Title { get; set; }
        [ForeignKey("LocationId")]
        public LocationEntity Location { get; set; }
        public Category Category { get; set; }
        public string Description { get; set; }
        public int UserId { get; set; }
        public Status Status { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime UpdatedAt { get; set; }
        public DateTime? ResolvedAt { get; set; }
        public int Upvotes { get; set; }
        public int Downvotes { get; set; }
        public ICollection<string> ReportImages { get; set; } = new List<string>();
    }
}
