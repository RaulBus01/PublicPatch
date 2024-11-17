using Microsoft.AspNetCore.Authorization;
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
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> CreateUser([FromBody] CreateUserModel createUser)
        {
            if (await userService.UserExistsByEmail(createUser.Email))
            {
                return BadRequest("User with this email already exists.");
            }

            var user = new UserEntity
            {
                Username = createUser.Username,
                Email = createUser.Email,
                Password = createUser.Password,
                Role = createUser.Role
            };

            await userService.AddUser(user);

            return CreatedAtAction(nameof(GetUser), new { id = user.Id } , user);
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

        [HttpGet("GetUsers{skip}/{take}")]
        public IActionResult GetUsers(int skip, int take)
        {
            try
            {
                return Ok(userService.GetUsers(skip, take));
            }
            catch (Exception e)
            {
                _logger.LogError(e.Message, e);
                return StatusCode(StatusCodes.Status500InternalServerError, "An error occurred while retrieving the user.");
            }
        }

        [HttpPost("Login")]
        public async Task<IActionResult> Login([FromBody] LoginModel login)
        {
            try
            {
                var user = await userService.Login(login.Email.ToLower(), login.Password);
                return Ok(user);
            }
            catch (Exception e)
            {
                _logger.LogError(e.Message, e);
                return StatusCode(StatusCodes.Status500InternalServerError, "Error Loggin In");
            }
        }

        [HttpPost("Register")]
        public async Task<IActionResult> Register([FromBody] RegisterModel register)
        {
            try
            {
                var jwt = await userService.RegisterUser(register);
                return Ok(jwt);
            }
            catch (Exception e)
            {
                _logger.LogError(e.Message, e);
                return StatusCode(StatusCodes.Status500InternalServerError, "Error registering user");
            }
        }

        [HttpPost("RegisterAdmin")]
        public async Task<IActionResult> RegisterAdmin([FromBody] RegisterModel register)
        {
            try
            {
                var jwt = await userService.RegisterAdmin(register);
                return Ok(jwt);
            }
            catch (Exception e)
            {
                _logger.LogError(e.Message, e);
                return StatusCode(StatusCodes.Status500InternalServerError, "Error registering user");
            }
        }
    }
}
