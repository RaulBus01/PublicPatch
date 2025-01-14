using AutoMapper;
using Microsoft.EntityFrameworkCore;
using PublicPatch.Aggregates;
using PublicPatch.Data;
using PublicPatch.Models;

namespace PublicPatch.Services
{
    public interface IFCMTokenService
    {
        
        Task AddFCMToken(SaveFCMTokenModel saveFCMTokenModel);

        Task UpdateFCMToken(SaveFCMTokenModel saveFCMTokenModel);

        Task DeleteFCMToken(int userId);

        Task<GetFCMTokenModel> getFCMTokenModelByUserId(int userId,string device);
        Task<IEnumerable<GetFCMTokenModel>> getFCMTokenModelByUserIdList(int userId);

        Task<IEnumerable<GetFCMTokenModel>> getFCMTokenModelByDeviceType(string device);



    }
    public class FCMTokenService : IFCMTokenService
    {
        private readonly ILogger<IReportService> logger;
        private readonly IServiceScopeFactory serviceScopeFactory;
        private readonly IMapper mapper;

        public FCMTokenService(ILogger<IReportService> logger,
            IServiceScopeFactory serviceScopeFactory,
            IMapper mapper
            )
        {
            this.logger = logger;
            this.serviceScopeFactory = serviceScopeFactory;
            this.mapper = mapper;
        }
        public async Task AddFCMToken(SaveFCMTokenModel saveFCMTokenModel)
        {
            try
            {
                var scope = serviceScopeFactory.CreateScope();
                using var dbContext = scope.ServiceProvider.GetRequiredService<PPContext>();

                var existingToken = TokenExists(saveFCMTokenModel.Token).Result;
                if (existingToken == true)
                {
                    throw new ArgumentException("Token already exists");
                }
                if (!await dbContext.Users.AnyAsync(e => e.Id == saveFCMTokenModel.UserId))
                {
                    throw new ArgumentException("User not found");
                }
                if(saveFCMTokenModel.DeviceType != "Android" && saveFCMTokenModel.DeviceType != "iOS")
                {
                    throw new ArgumentException("Invalid device type");
                }

                var fcmToken = new FCMTokenEntity()
                {
                    UserId = saveFCMTokenModel.UserId,
                    FCMKey = saveFCMTokenModel.Token,
                    deviceType = saveFCMTokenModel.DeviceType
                };

                dbContext.FCMTokenEntities.Add(fcmToken);
                await dbContext.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Error adding FCM token");
                throw;
            }
        }

        public async Task<bool> TokenExists(string token)
        { 
            var scope = serviceScopeFactory.CreateScope();
            using var dbContext = scope.ServiceProvider.GetRequiredService<PPContext>();
            return await dbContext.FCMTokenEntities.AnyAsync(e => e.FCMKey == token);
        }

        public async Task DeleteFCMToken(int userId)
        {
            try
            {
                var scope = serviceScopeFactory.CreateScope();
                using var dbContext = scope.ServiceProvider.GetRequiredService<PPContext>();
                var fcmToken = await dbContext.FCMTokenEntities.SingleOrDefaultAsync(e => e.UserId == userId);
                if (fcmToken == null)
                {
                    throw new ArgumentException("FCM token not found");
                }
                dbContext.FCMTokenEntities.Remove(fcmToken);
                await dbContext.SaveChangesAsync();


            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Error deleting FCM token");
                throw;
            }
        }

        public async Task<GetFCMTokenModel> getFCMTokenModelByUserId(int userId,string device)
        {
            try
            {
                var scope = serviceScopeFactory.CreateScope();
                using var dbContext = scope.ServiceProvider.GetRequiredService<PPContext>();
                var fcmToken = await dbContext.FCMTokenEntities.FirstOrDefaultAsync(e => e.UserId == userId && e.deviceType == device);
                if (fcmToken == null)
                {
                    throw new ArgumentException("FCM token not found");
                }
                fcmToken.LastUsedAt = DateTime.Now;
                return mapper.Map<GetFCMTokenModel>(fcmToken);
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Error getting FCM token");
                throw;

            }
        }



        public async Task UpdateFCMToken(SaveFCMTokenModel saveFCMTokenModel)
        {
            try
            {
                var scope = serviceScopeFactory.CreateScope();
                using var dbContext = scope.ServiceProvider.GetRequiredService<PPContext>();
                var fcmToken = await dbContext.FCMTokenEntities.SingleOrDefaultAsync(e => e.UserId == saveFCMTokenModel.UserId);
                if (fcmToken == null)
                {
                    throw new ArgumentException("FCM token not found");
                }
                fcmToken.FCMKey = saveFCMTokenModel.Token;
                fcmToken.deviceType = saveFCMTokenModel.DeviceType;
                fcmToken.LastUpdatedAt = DateTime.Now;
                await dbContext.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Error updating FCM token");
                throw;
            }
        }

        public async Task<IEnumerable<GetFCMTokenModel>> getFCMTokenModelByUserIdList(int userId)
        {
            try
            {
                var scope = serviceScopeFactory.CreateScope();
                using var dbContext = scope.ServiceProvider.GetRequiredService<PPContext>();
                var fcmToken = await dbContext.FCMTokenEntities.Where(e => e.UserId == userId).ToListAsync();
                return mapper.Map<IEnumerable<GetFCMTokenModel>>(fcmToken);
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Error getting FCM token");
                throw;
            }
        }

        public async Task<IEnumerable<GetFCMTokenModel>> getFCMTokenModelByDeviceType(string device)
        {
            try
            {
                var scope = serviceScopeFactory.CreateScope();
                using var dbContext = scope.ServiceProvider.GetRequiredService<PPContext>();
                var fcmToken = await dbContext.FCMTokenEntities.Where(e => e.deviceType == device).ToListAsync();
                return mapper.Map<IEnumerable<GetFCMTokenModel>>(fcmToken);
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Error getting FCM token");
                throw;
            }
        }

    }
}
