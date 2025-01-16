using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using PublicPatch.Aggregates;
using PublicPatch.Models;
using PublicPatch.Services;

namespace PublicPatch.Controllers
{
    [ApiController]
    [Route("fcm-token")]
    public class FCMTokenController : ControllerBase
    {
        private readonly ILogger<WeatherForecastController> _logger;
        private readonly IMapper mapper;
        private readonly IFCMTokenService fcmTokenService;
        public FCMTokenController(ILogger<WeatherForecastController> logger,
            IMapper mapper,
            IFCMTokenService fcmTokenService)
        {
            _logger = logger;
            this.mapper = mapper;
            this.fcmTokenService = fcmTokenService;
        }

        [HttpPost("AddFCMToken")]
        public async Task<IActionResult> AddFCMToken([FromBody] SaveFCMTokenModel saveFCMTokenModel)
        {
            await fcmTokenService.AddOrUpdateFCMToken(saveFCMTokenModel);
            return Ok(saveFCMTokenModel);
        }

       

        [HttpDelete("DeleteFCMToken")]
        public async Task<IActionResult> DeleteFCMToken([FromBody] int userId)
        {
            await fcmTokenService.DeleteFCMToken(userId);
            return Ok();
        }

        [HttpGet("GetFCMTokenByUserId/{userId}/{device}")]
        public async Task<IActionResult> GetFCMTokenByUserId(int userId, string device)
        {
            var fcmToken = await fcmTokenService.getFCMTokenModelByUserId(userId, device);
            if (fcmToken == null)
            {
                return NotFound();
            }
            return Ok(fcmToken);
        }

        [HttpGet("GetFCMTokenByUserIdList/{userId}")]
        public async Task<IActionResult> GetFCMTokenByUserIdList(int userId)
        {
            var fcmTokens = await fcmTokenService.getFCMTokenModelByUserIdList(userId);
            if (fcmTokens.Count() == 0)
            {
                return NotFound();
            }
            return Ok(fcmTokens);
        }

        [HttpGet("GetFCMTokenByDeviceType/{device}")]
        public async Task<IActionResult> GetFCMTokenByDeviceType(string device)
        {
            var fcmTokens = await fcmTokenService.getFCMTokenModelByDeviceType(device);
            if (fcmTokens.Count() == 0)
            {
                return NotFound();
            }
            return Ok(fcmTokens);
        }




    }
}
