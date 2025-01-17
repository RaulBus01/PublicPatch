﻿using Amazon.S3;
using Amazon.S3.Model.Internal.MarshallTransformations;
using Amazon.S3.Transfer;
using AutoMapper;
using FirebaseAdmin.Messaging;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PublicPatch.Aggregates;
using PublicPatch.Data;
using PublicPatch.Models;
using System.Collections.Generic;

namespace PublicPatch.Services
{
    public interface IReportService
    {
        Task<GetReportModel> GetReportById(int id);
        Task<IEnumerable<GetReportModel>> GetReportsByUser(int userId);
        Task<IEnumerable<GetReportModel>> GetAllReports();
        Task CreateReport(CreateReportModel createReportModel);
        Task<IEnumerable<CategoryEntity>> GetCategories();
        Task<int> CreateCategory(CreateCategoryModel categoryModel);

        Task<GetReportModel> updateReportStatus(int reportId, Status status);
        Task DeleteReport(int id);

        Task<IEnumerable<GetReportModel>> GetReportsByZone(GetReportsLocation location);
        Task<ReportEntity> UpdateReport(UpdateReportModel newReport);
    }
    public class ReportService : IReportService
    {
        private readonly ILogger<IReportService> logger;
        private readonly IServiceScopeFactory serviceScopeFactory;
        private readonly IAmazonS3 s3Client;
        private readonly string bucketName = "publichpatch";
        private readonly IMapper mapper;

        public ReportService(
            ILogger<IReportService> logger,
            IServiceScopeFactory serviceScopeFactory,
            IAmazonS3 s3Client,
            IMapper mapper)
        {
            this.logger = logger;
            this.serviceScopeFactory = serviceScopeFactory;
            this.mapper = mapper;
            this.s3Client = s3Client;
        }
        public async Task<GetReportModel> GetReportById(int id)
        {
            try
            {
                var scope = serviceScopeFactory.CreateScope();
                using var dbContext = scope.ServiceProvider.GetRequiredService<PPContext>();
                return mapper.Map<GetReportModel>(
                    await dbContext.Reports.Include(r => r.Location).Include(r => r.Category).FirstOrDefaultAsync(r => r.Id == id));

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
                    .Include(r => r.Location).Include(r => r.Category).ToListAsync();
                return mapper.Map<IEnumerable<GetReportModel>>(reports);
            }
            catch (Exception e)
            {
                logger.LogError($"{nameof(GetReportsByUser)}: Error while getting the report", e);
                throw;
            }
        }

        public async Task<IEnumerable<GetReportModel>> GetAllReports()
        {
            try
            {
                var scope = serviceScopeFactory.CreateScope();
                using var dbContext = scope.ServiceProvider.GetRequiredService<PPContext>();
                var reports = await dbContext.Reports.Include(r => r.Location).Include(r => r.Category).OrderByDescending(r => r.CreatedAt).ToListAsync();

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
                if (!await dbContext.Categories.AnyAsync(u => u.Id == createReportModel.CategoryId))
                {
                    throw new ArgumentException("Category not found");
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
                    Upvotes = createReportModel.Upvotes,
                    Downvotes = createReportModel.Downvotes,
                    ReportImages = createReportModel.ReportImages
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
        public async Task DeleteReport(int id)
        {
            try
            {
                var scope = serviceScopeFactory.CreateScope();
                using var dbContext = scope.ServiceProvider.GetRequiredService<PPContext>();
                var report = await dbContext.Reports.FirstOrDefaultAsync(r => r.Id == id);
                if (report == null)
                {
                    throw new ArgumentException("Report not found");
                }
                dbContext.Reports.Remove(report);
                await dbContext.SaveChangesAsync();
            }
            catch (Exception e)
            {
                logger.LogError($"{nameof(DeleteReport)}: Error while deleting the report", e);
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
                Description = categoryModel.Description,
                Icon = categoryModel.Description
            };

            dbContext.Categories.Add(category);
            await dbContext.SaveChangesAsync();
            return category.Id;
        }

        public async Task<IEnumerable<GetReportModel>> GetReportsByZone(GetReportsLocation location)
        {
            try
            {
                var scope = serviceScopeFactory.CreateScope();
                using var dbContext = scope.ServiceProvider.GetRequiredService<PPContext>();
                var reports = await dbContext.Reports
                    .Include(r => r.Location) // Include the Location entity
                    .Include(r => r.Category)
                    .Where(r => r.Location.Latitude >= (double)location.Latitude - location.Radius
                                && r.Location.Latitude <= (double)location.Latitude + location.Radius
                                && r.Location.Longitude >= (double)location.Longitude - location.Radius
                                && r.Location.Longitude <= (double)location.Longitude + location.Radius)
                    .ToListAsync();



                return mapper.Map<IEnumerable<GetReportModel>>(reports);
            }
            catch (Exception e)
            {
                logger.LogError($"{nameof(GetReportsByZone)}: Error while getting the report", e);
                throw;

            }
        }

        public async Task<ReportEntity> UpdateReport(UpdateReportModel newReport)
        {
            var scope = serviceScopeFactory.CreateScope();
            using var dbContext = scope.ServiceProvider.GetRequiredService<PPContext>();
            var report = await dbContext.Reports.FirstOrDefaultAsync(r => r.Id == newReport.Id);

            if (report != null)
            {
                CompareAndUpdateReports(report, newReport);
            }
            else
            {
                throw new ArgumentException("Report not found");
            }

            await dbContext.SaveChangesAsync();
            return report;
        }

        private void CompareAndUpdateReports(ReportEntity report, UpdateReportModel newReport)
        {
            if (report.Title != newReport.Title)
            {
                report.Title = newReport.Title;
            }

            if (report.Location != newReport.location)
            {
                report.Location = newReport.location;
            }

            if (report.Description != newReport.Description)
            {
                report.Description = newReport.Description;
            }

            if (report.Status != newReport.Status)
            {
                report.Status = newReport.Status;
            }

            if (report.ReportImages != newReport.ReportImages)
            {
                report.ReportImages = newReport.ReportImages;
            }

            report.UpdatedAt = DateTime.UtcNow;
        }

        public async Task<GetReportModel> updateReportStatus(int reportId, Status status)
        {
            var scope = serviceScopeFactory.CreateScope();
            using var dbContext = scope.ServiceProvider.GetRequiredService<PPContext>();
            var report = await dbContext.Reports.FirstOrDefaultAsync(r => r.Id == reportId);
            
            if(report == null)
            {
                throw new ArgumentException("Report not found");
            }   
            
           
            if (status == Status.Resolved || status == Status.Rejected)
            {
                report.ResolvedAt = DateTime.UtcNow;
            }

            if(report.Status == status)
            {
                throw new ArgumentException("Status is already set to " + status);
            }
            report.Status = status;
            report.UpdatedAt = DateTime.UtcNow;

            await dbContext.SaveChangesAsync();

            var fcmToken = await dbContext.FCMTokenEntities.Where(e => e.UserId == report.UserId).Select(e => e.FCMKey).ToListAsync();
            

            var messageing = FirebaseMessaging.DefaultInstance;

            foreach (var i in fcmToken)
            {
                var message = new Message()
                {
                    Notification = new Notification()
                    {
                        
                        Title = "Report Status Update",
                        Body = $"Your report status has been updated to {status}"
                    },
                    Data = new Dictionary<string, string>()
                    {
                        ["reportId"] = reportId.ToString(),
                        ["status"] =  status.ToString()
                    },
                    Token = i
                };
                var result = await messageing.SendAsync(message);
            }
            
           

            return mapper.Map<GetReportModel>(report);
        }
    }
        
}
