using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PublicPatch.Aggregates;
using PublicPatch.Data;
using PublicPatch.Models;

namespace PublicPatch.Services
{
    public interface IReportService
    {
        Task<GetReportModel> GetReportById(int id);
        Task<IEnumerable<GetReportModel>> GetReportsByUser(int userId);
        Task CreateReport(CreateReportModel createReportModel);
    }
    public class ReportService : IReportService
    {
        private readonly ILogger<IReportService> logger;
        private readonly IServiceScopeFactory serviceScopeFactory;
        private readonly IMapper mapper;

        public ReportService(
            ILogger<IReportService> logger,
            IServiceScopeFactory serviceScopeFactory,
            IMapper mapper)
        {
            this.logger = logger;
            this.serviceScopeFactory = serviceScopeFactory;
            this.mapper = mapper;
        }
        public async Task<GetReportModel> GetReportById(int id)
        {
            try
            {
                var scope = serviceScopeFactory.CreateScope();
                using var dbContext = scope.ServiceProvider.GetRequiredService<PPContext>();
                return mapper.Map<GetReportModel>(
                    await dbContext.Reports.FirstOrDefaultAsync(e => e.Id == id));
            }
            catch (Exception e)
            {
                logger.LogError($"{nameof(GetReportById)}: Error while getting the report", e);
                throw;
            }

        }

        public async Task<IEnumerable<GetReportModel>> GetReportsByUser(int userId)
        {
            try
            {
                var scope = serviceScopeFactory.CreateScope();
                using var dbContext = scope.ServiceProvider.GetRequiredService<PPContext>();
                return mapper.Map<IEnumerable<GetReportModel>>(
                    await dbContext.Reports.AnyAsync(r => r.UserId == userId));
            }
            catch (Exception e)
            {
                logger.LogError($"{nameof(GetReportsByUser)}: Error while getting the report", e);
                throw;
            }
        }

        public async Task CreateReport(CreateReportModel createReportModel)
        {
            try
            {
                var scope = serviceScopeFactory.CreateScope();
                using var dbContext = scope.ServiceProvider.GetRequiredService<PPContext>();

                var report = new ReportEntity()
                {
                    Title = createReportModel.Title,
                    Location = createReportModel.location,
                    Category = createReportModel.Category,
                    Description = createReportModel.Description,
                    UserId = createReportModel.UserId,
                    Status = createReportModel.Status,
                    CreatedAt = createReportModel.CreatedAt,
                    UpdatedAt = createReportModel.UpdatedAt,
                    ResolvedAt = createReportModel.ResolvedAt,
                    Upvotes = createReportModel.Upvotes,
                    Downvotes = createReportModel.Downvotes,
                    ReportImages = createReportModel.ReportImagesUrls.ToList()
                };

                dbContext.Reports.Add(report);
                await dbContext.SaveChangesAsync();
            }
            catch (Exception e)
            {
                logger.LogError($"{nameof(CreateReport)}: Error while creating the report", e);
                throw;
            }
        }
    }
}
