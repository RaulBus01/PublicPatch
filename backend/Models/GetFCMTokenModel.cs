namespace PublicPatch.Models
{
    public class GetFCMTokenModel
    {
        public int Id { get; set; }
        public string Token { get; set; }
        public int UserId { get; set; }

        public bool IsActive { get; set; }

       public string DeviceType { get; set; }



    }
}
