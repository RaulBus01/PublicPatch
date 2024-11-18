using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PublicPatch.Aggregates
{
    public class ReportImageEntity
    {
        [Key]
        public int Id { get; set; }

        public int ReportId { get; set; }
        [ForeignKey("ReportId")]
        public ReportEntity Report { get; set; }

        public string ImageUrl { get; set; }
    }
}