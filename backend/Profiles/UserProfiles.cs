using AutoMapper;
using PublicPatch.Aggregates;
using PublicPatch.Models;

namespace PublicPatch.Profiles
{
    public class GetUserProfile : Profile
    {
        public GetUserProfile()
        {
            CreateMap<UserEntity, GetUserModel>().ConvertUsing<GetUserModelConverter>();
            CreateMap<IEnumerable<UserEntity>, IEnumerable<GetUserModel>>().ConvertUsing<GetUserModelEnumerableConverter>();
        }
    }

    internal class GetUserModelConverter : ITypeConverter<UserEntity, GetUserModel>
    {
        public GetUserModel Convert(UserEntity source, GetUserModel destination, ResolutionContext context)
        {
            return new(
                id: source.Id,
                username: source.Username,
                role: source.Role,
                email: source.Email,
                createdAt: source.CreatedAt,
                updatedAt: source.UpdatedAt
                );
        }
    }
    internal class GetUserModelEnumerableConverter : ITypeConverter<IEnumerable<UserEntity>, IEnumerable<GetUserModel>>
    {
        public IEnumerable<GetUserModel> Convert(IEnumerable<UserEntity> source, IEnumerable<GetUserModel> destination, ResolutionContext context)
        {
            return source.Select(user => new GetUserModel(
                id: user.Id,
                username: user.Username,
                role: user.Role,
                email: user.Email,
                createdAt: user.CreatedAt,
                updatedAt: user.UpdatedAt
            ));
        }
    }
}
