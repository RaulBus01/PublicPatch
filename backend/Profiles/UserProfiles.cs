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
        }
    }

    internal class GetUserModelConverter : ITypeConverter<UserEntity, GetUserModel>
    {
        public GetUserModel Convert(UserEntity source, GetUserModel destination, ResolutionContext context)
        {
            return new(
                id: source.Id,
                username: source.Username,
                email: source.Email,
                phoneNumber: source.PhoneNumber,
                createdAt: source.CreatedAt,
                updatedAt: source.UpdatedAt
                );       
        }
    }
}
