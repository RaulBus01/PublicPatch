using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

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