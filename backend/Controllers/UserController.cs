using Microsoft.AspNetCore.Mvc;
using PublicPatch.Aggregates;
using PublicPatch.Models;
using PublicPatch.Services;

namespace PublicPatch.Controllers
{
    [ApiController]
    [Route("users")]
    public class UserController : ControllerBase
    {
        private readonly ILogger<WeatherForecastController> _logger;
        private readonly IUserService userService;

        public UserController(ILogger<WeatherForecastController> logger, IUserService userService)
        {
            _logger = logger;
            this.userService = userService;
        }

        [HttpPost("CreateUser")]
        public async Task<IActionResult> CreateUser([FromBody] CreateUserModel createUser)
        {

            var user = new UserEntity
            {
                Username = createUser.Username,
                Email = createUser.Email,
                Password = createUser.Password,
                Role = createUser.Role,
                PhoneNumber = createUser.PhoneNumber
            };

            await userService.AddUser(user);

            return CreatedAtAction(nameof(GetUser), new { id = user.Id }, user);
        }

        [HttpPost("UpdateUser")]
        public async Task<IActionResult> UpdateUser([FromBody] UpdateUserModel updateUser)
        {
            await userService.UpdateUser(updateUser);
            return Ok(updateUser);
        }

        [HttpDelete("DeleteUser")]
        public async Task<IActionResult> DeleteUser([FromBody] int id)
        {
            if (id <= 0)
            {
                return BadRequest("Invalid user ID provided.");
            }

            var user = await userService.GetUserById(id);
            if (user == null)
            {
                return NotFound($"User with ID {id} not found.");
            }

            await userService.DeleteUser(id);
            return NoContent();
        }

        [HttpGet("GetUser{id}")]
        public async Task<IActionResult> GetUser(int id)
        {
            try
            {
                var user = await userService.GetUserById(id);
                if (user == null)
                {
                    return NotFound();
                }
                return Ok(user);
            }
            catch (Exception e)
            {
                _logger.LogError(e.Message, e);
                return StatusCode(StatusCodes.Status500InternalServerError, "An error occurred while retrieving the user.");
            }
        }
    }
}
