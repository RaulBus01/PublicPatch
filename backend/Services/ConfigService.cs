
using System.Text;
namespace PublicPatch.Services
{
    public interface IConfigService
    {
        public string GetDbConnectionString();
    }

    public class ConfigService : IConfigService
    {
        public string GetDbConnectionString()
        {
            DotNetEnv.Env.Load();
            StringBuilder sb = new StringBuilder("Host=");

            sb.Append(Environment.GetEnvironmentVariable("DB_HOST"));
            sb.Append("; Database=");
            sb.Append(Environment.GetEnvironmentVariable("DB_NAME"));
            sb.Append("; Username=");
            sb.Append(Environment.GetEnvironmentVariable("DB_USERNAME"));
            sb.Append("; Password=");
            sb.Append(Environment.GetEnvironmentVariable("DB_PASSWORD"));

            return sb.ToString();
        }
    }
}