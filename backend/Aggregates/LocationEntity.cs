using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;

namespace PublicPatch.Aggregates
{
    public class LocationEntity
    {
        public LocationEntity()
        {
        }
        public LocationEntity(double longitude, double latitude, string address)
        {
            Longitude = longitude;
            Latitude = latitude;
            Address = address;
        }

        [Key]
        public int Id { get; set; }
        public double Longitude { get; set; }
        public double Latitude { get; set; }
        public string Address { get; set; }
    }
}