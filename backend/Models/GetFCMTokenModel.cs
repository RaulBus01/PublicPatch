namespace PublicPatch.Models
{
    public class GetFCMTokenModel
    {
        public int Id { get; set; }
        public  string FCMKey { get; set; }
        public int UserId { get; set; }

        public bool IsActive { get; set; }

       public  string DeviceType { get; set; }



    }
}
