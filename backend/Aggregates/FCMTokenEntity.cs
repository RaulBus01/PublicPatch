using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using Microsoft.EntityFrameworkCore;
using Microsoft.VisualStudio.Web.CodeGenerators.Mvc.Templates.BlazorIdentity.Pages.Manage;
using PublicPatch.Models;

namespace PublicPatch.Aggregates
{  
   
    public class FCMTokenEntity

    {
        
        public FCMTokenEntity() { }


        public FCMTokenEntity(int userId, string fcmKey, string deviceType)
        {
            this.UserId = userId;
            this.FCMKey = fcmKey;
            this.DeviceType = deviceType;
        }


        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        public int UserId { get; set; }

        [Required]
        [MaxLength(255)]
        public string FCMKey { get; set; }

        public string DeviceType { get; set; }

        public bool IsActive { get; set; } = true;

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime LastUpdatedAt { get; set;} = DateTime.UtcNow;

        public DateTime LastUsedAt { get; set; } = DateTime.UtcNow;


    }
}
