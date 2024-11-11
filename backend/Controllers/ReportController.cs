using Microsoft.AspNetCore.Mvc;

namespace PublicPatch.Controllers
{
    [ApiController]
    [Route("api/[controller]/reports")]
    public class ReportController : ControllerBase
    {
        private readonly ILogger<WeatherForecastController> _logger;
        public ReportController(ILogger<WeatherForecastController> logger)
        {
            _logger = logger;
        }
    }
}
