using Microsoft.AspNetCore.Mvc;

namespace PublicPatch.Controllers
{
    [ApiController]
    [Route("settings")]
    public class SettingsController : ControllerBase
    {
        private readonly ILogger<SettingsController> _logger;
        public SettingsController(ILogger<SettingsController> logger)
        {
            _logger = logger;
        }
    }
}

