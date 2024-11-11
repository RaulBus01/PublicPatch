using Microsoft.AspNetCore.Mvc;

namespace PublicPatch.Controllers
{
    [ApiController]
    [Route("admin")]
    public class AdminController : ControllerBase
    {
        private readonly ILogger<SettingsController> _logger;
        public AdminController(ILogger<SettingsController> logger)
        {
            _logger = logger;
        }

        [HttpPost(Name = "CreateCategory")]
        public IActionResult CreateCategory()
        {
            return Ok();
        }

        [HttpPut(Name = "UpdateCategory")]
        public IActionResult UpdateCategory()
        {
            return Ok();
        }

        [HttpDelete(Name = "DeleteCategory")]
        public IActionResult DeleteCategory()
        {
            return Ok();
        }

        [HttpGet(Name = "GetCategories")]
        public IActionResult GetCategories()
        {
            return Ok();
        }
    }
}

