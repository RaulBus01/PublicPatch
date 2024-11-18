using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;

namespace PublicPatch.Aggregates
{
    public class LocationEntity
    {
        public LocationEntity()
        {
        }
        public LocationEntity(decimal longitude, decimal latitude, string address)
        {
            Longitude = longitude;
            Latitude = latitude;
            Address = address;
        }

        [Key]
        public int Id { get; set; }
        public decimal Longitude { get; set; }
        public decimal Latitude { get; set; }
        public string Address { get; set; }
    }
}