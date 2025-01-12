using AutoMapper;
using PublicPatch.Aggregates;
using PublicPatch.Models;

namespace PublicPatch.Profiles
{
    public class ReportProfile : Profile
    {
        public ReportProfile()
        {
            CreateMap<ReportEntity, GetReportModel>().ConvertUsing<GetReportConverter>();
            CreateMap<IEnumerable<ReportEntity>, IEnumerable<GetReportModel>>().ConvertUsing<GetReportModelEnumerableConverter>();
        }
    }

    internal class GetReportConverter : ITypeConverter<ReportEntity, GetReportModel>
    {
        public GetReportModel Convert(ReportEntity source, GetReportModel destination, ResolutionContext context)
        {
            return new GetReportModel
            {
                Id =  source.Id,
                Title = source.Title,
                Location = source.Location,
                Category = source.Category,
                Description = source.Description,
                UserId = source.UserId,
                Status = source.Status,
                CreatedAt = source.CreatedAt,
                UpdatedAt = source.UpdatedAt,
                ResolvedAt = source.ResolvedAt,
                Upvotes = source.Upvotes,
                Downvotes = source.Downvotes,
                ReportImagesUrls = source.ReportImages.ToList()
            };
        }
    }
    public class GetReportModelEnumerableConverter : ITypeConverter<IEnumerable<ReportEntity>, IEnumerable<GetReportModel>>
    {
        public IEnumerable<GetReportModel> Convert(IEnumerable<ReportEntity> source, IEnumerable<GetReportModel> destination, ResolutionContext context)
        {
            return source.Select(report => new GetReportModel
            {
                Id = report.Id,
                Title = report.Title,
                Location = report.Location,
                Category = report.Category,
                Description = report.Description,
                UserId = report.UserId,
                Status = report.Status,
                CreatedAt = report.CreatedAt,
                UpdatedAt = report.UpdatedAt,
                ResolvedAt = report.ResolvedAt,
                Upvotes = report.Upvotes,
                Downvotes = report.Downvotes,
                ReportImagesUrls = report.ReportImages.ToList()
            }).ToList();
        }
    }
}
