using AutoMapper;
using PublicPatch.Aggregates;
using PublicPatch.Models;

namespace PublicPatch.Profiles
{
    public class FCMTokenProfile:Profile
    {
        public FCMTokenProfile()
        {
            CreateMap<FCMTokenEntity, GetFCMTokenModel>().ConvertUsing<GetFCMTokenConverter>();
            CreateMap<IEnumerable<FCMTokenEntity>, IEnumerable<GetFCMTokenModel>>().ConvertUsing<GetFCMTokenListConverter>();

        }

    }

    public class GetFCMTokenListConverter : ITypeConverter<IEnumerable<FCMTokenEntity>, IEnumerable<GetFCMTokenModel>>
    {
        public IEnumerable<GetFCMTokenModel> Convert(IEnumerable<FCMTokenEntity> source, IEnumerable<GetFCMTokenModel> destination, ResolutionContext context)
        {
            return source.Select(x => new GetFCMTokenModel
            {
                Id = x.Id,
                FCMKey = x.FCMKey,
                UserId = x.UserId,
                IsActive = x.IsActive,
                DeviceType = x.DeviceType
            }).ToList();
        }
    }

    public class GetFCMTokenConverter : ITypeConverter<FCMTokenEntity, GetFCMTokenModel>
    {
        public GetFCMTokenModel Convert(FCMTokenEntity source, GetFCMTokenModel destination, ResolutionContext context)
        {
            return new GetFCMTokenModel
            {
                Id = source.Id,
                FCMKey = source.FCMKey,
                UserId = source.UserId,
                IsActive = source.IsActive,
                DeviceType = source.DeviceType
            };
        }
    }
    
}
