using PublicPatch.Aggregates;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace PublicPatch.Models
{
    public class CreateReportModel
    {
        public string Title { get; set; }
        public LocationEntity location { get; set; }
        public Category Category { get; set; }
        public string Description { get; set; }
        public int UserId { get; set; }
        public Status Status { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
        public DateTime? ResolvedAt { get; set; }
        public int Upvotes { get; set; }
        public int Downvotes { get; set; }
        public ICollection<string> ReportImagesUrls { get; set; } = new List<string>();
    }
}
