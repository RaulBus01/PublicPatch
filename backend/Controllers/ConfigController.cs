using Microsoft.AspNetCore.Mvc;
using PublicPatch.Services;

namespace PublicPatch.Controllers
{
    [ApiController]
    [Route("config")]
    public class ConfigController : ControllerBase
    {
        private readonly ILogger<ConfigController> logger;
        private readonly IConfigService configService;

        public ConfigController(ILogger<ConfigController> logger, IConfigService configService)
        {
            this.logger = logger;
            this.configService = configService;
        }

        [HttpGet("GetDBConnectionString")]
        public IActionResult TestDbConnectionString()
        {
            return Ok(configService.GetDbConnectionString());
        }
    }
}
