using Amazon.S3.Model.Internal.MarshallTransformations;
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
        Task<IEnumerable<CategoryEntity>> GetCategories();
        Task<int> CreateCategory(CreateCategoryModel categoryModel);
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
                    await dbContext.Reports.Include(r => r.Location).FirstOrDefaultAsync(r => r.Id == id));

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
                if (!await dbContext.Users.AnyAsync(u => u.Id == userId))
                {
                    throw new ArgumentException("User not found");
                }
                
                var reports = await dbContext.Reports.Where(r => r.UserId == userId)
                    .Include(r => r.Location).ToListAsync();
                return mapper.Map<IEnumerable<GetReportModel>>(reports);
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

                if (!await dbContext.Users.AnyAsync(u => u.Id == createReportModel.UserId))
                {
                    throw new ArgumentException("User not found");
                }

                var report = new ReportEntity()
                {
                    Title = createReportModel.Title,
                    Location = createReportModel.location,
                    CategoryId = createReportModel.CategoryId,
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

        public async Task<IEnumerable<CategoryEntity>> GetCategories()
        {
            var scope = serviceScopeFactory.CreateScope();
            using var dbContext = scope.ServiceProvider.GetRequiredService<PPContext>();

            return await dbContext.Categories.ToListAsync();
        }

        public async Task<int> CreateCategory(CreateCategoryModel categoryModel)
        {
            var scope = serviceScopeFactory.CreateScope();
            using var dbContext = scope.ServiceProvider.GetRequiredService<PPContext>();

            var category = new CategoryEntity()
            {
                Name = categoryModel.Name,
                Description = categoryModel.Description
            };

            dbContext.Categories.Add(category);
            await dbContext.SaveChangesAsync();
            return category.Id;
        }
    }
}
