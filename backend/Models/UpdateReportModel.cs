using PublicPatch.Aggregates;

namespace PublicPatch.Models
{
    public class UpdateReportModel
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public string Title { get; set; }
        public LocationEntity location { get; set; }
        public string Description { get; set; }
        public Status Status { get; set; }
        public IList<string> ReportImages { get; set; }
    }
}
