namespace PublicPatch.Models
{
    public class SaveFCMTokenModel
    {
        public string Token { get; set; }
        public int UserId { get; set; }
        public string DeviceType { get; set; }
    }
}
