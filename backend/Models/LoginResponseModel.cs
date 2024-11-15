namespace PublicPatch.Models
{
    public class LoginResponseModel
    {
        public LoginResponseModel(string token, string role)
        {
            Token = token;
            Role = role;
        }
        public string Token { get; set; }
        public string Role { get; set; }
    }
}
