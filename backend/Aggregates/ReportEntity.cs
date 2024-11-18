using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace PublicPatch.Aggregates
{
    public class ReportEntity
    {
        [Key]
        public int Id { get; set; }
        public string Title { get; set; }
        public int LocationId { get; set; }
        [ForeignKey("LocationId")]
        public LocationEntity Location { get; set; }
        public int CategoryId { get; set; }
        public string Description { get; set; }
        public int UserId { get; set; }
        public int StatusId { get; set; }
        [ForeignKey("StatusId")]
        public Status Status { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        public DateTime? ResolvedAt { get; set; }

        public int Upvotes { get; set; }
        public int Downvotes { get; set; }

        public IList<string> ReportImages { get; set; } = new List<string>();
    }
}
