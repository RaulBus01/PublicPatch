using System.ComponentModel.DataAnnotations;

namespace PublicPatch.Aggregates
{
    public class LocationEntity
    {
        [Key]
        public int Id { get; set; }

        public decimal Longitude { get; set; }
        public decimal Latitude { get; set; }
        public string StreetAddress { get; set; }
        public string PostalCode { get; set; }

        public ICollection<ReportEntity> Reports { get; set; } = new List<ReportEntity>();
    }
}