using AutoMapper;
using Microsoft.EntityFrameworkCore;
using PublicPatch.Aggregates;
using PublicPatch.Data;
using PublicPatch.Models;

namespace PublicPatch.Services
{
    public interface IFCMTokenService
    {
        
        Task AddOrUpdateFCMToken(SaveFCMTokenModel saveFCMTokenModel);

       

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
        public async Task AddOrUpdateFCMToken(SaveFCMTokenModel saveFCMTokenModel)
        {
            try
            {
                var scope = serviceScopeFactory.CreateScope();
                using var dbContext = scope.ServiceProvider.GetRequiredService<PPContext>();

                if (!await dbContext.Users.AnyAsync(e => e.Id == saveFCMTokenModel.UserId))
                {
                    throw new ArgumentException("User not found");
                }
                if (saveFCMTokenModel.DeviceType != "Android" && saveFCMTokenModel.DeviceType != "iOS")
                {
                    throw new ArgumentException("Invalid device type");
                }

                var existingToken = await dbContext.FCMTokenEntities
                    .SingleOrDefaultAsync(e => e.UserId == saveFCMTokenModel.UserId && e.DeviceType == saveFCMTokenModel.DeviceType);

               

                if (existingToken != null)
                {
                    if (existingToken.FCMKey != saveFCMTokenModel.Token)
                    {
                        existingToken.FCMKey = saveFCMTokenModel.Token;
                        existingToken.LastUpdatedAt = DateTime.UtcNow;
                        dbContext.FCMTokenEntities.Update(existingToken);
                    }
                }
                else
                {
                    var fcmToken = new FCMTokenEntity()
                    {
                        UserId = saveFCMTokenModel.UserId,
                        FCMKey = saveFCMTokenModel.Token,
                        DeviceType = saveFCMTokenModel.DeviceType
                    };

                    dbContext.FCMTokenEntities.Add(fcmToken);
                }

                await dbContext.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Error adding or updating FCM token");
                throw;
            }
        }

        public async Task<string> GetTokenForUser(int userId, string device)
        {
            var scope = serviceScopeFactory.CreateScope();
            using var dbContext = scope.ServiceProvider.GetRequiredService<PPContext>();
            var fcmToken = await dbContext.FCMTokenEntities.SingleOrDefaultAsync(e => e.UserId == userId && e.DeviceType == device);
            return fcmToken?.FCMKey;
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
                var fcmToken = await dbContext.FCMTokenEntities.FirstOrDefaultAsync(e => e.UserId == userId && e.DeviceType == device);
                if (fcmToken == null)
                {
                    throw new ArgumentException("FCM token not found");
                }
                fcmToken.LastUsedAt = DateTime.UtcNow;
                dbContext.FCMTokenEntities.Update(fcmToken);
                return mapper.Map<GetFCMTokenModel>(fcmToken);
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Error getting FCM token");
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
                var fcmToken = await dbContext.FCMTokenEntities.Where(e => e.DeviceType == device).ToListAsync();
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
