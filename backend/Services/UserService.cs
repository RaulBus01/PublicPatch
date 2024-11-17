using AutoMapper;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using PublicPatch.Aggregates;
using PublicPatch.Data;
using PublicPatch.Models;
namespace PublicPatch.Services
{
    public interface IUserService
    {
        Task AddUser(UserEntity user);
        Task DeleteUser(int id);
        Task UpdateUser(UpdateUserModel user);
        Task<GetUserModel> GetUserById(int id);
        Task<string> Login(string email, string password);
        Task<string> RegisterAdmin(RegisterModel register);
        Task<string> RegisterUser(RegisterModel register);
        Task<string> RegisterInstitution(RegisterModel register, string role);
        Task<bool> UserExistsByEmail(string email);
        IEnumerable<GetUserModel> GetUsers(int skip, int take);
    }
    public class UserService : IUserService
    {

        private readonly ILogger<IUserService> logger;
        private readonly IServiceScopeFactory serviceScopeFactory;
        private readonly IMapper mapper;
        private readonly ITokenProvider tokenProvider;
        private readonly PasswordHasher<string> passwordHasher;

        public UserService(ILogger<IUserService> logger,
            IServiceScopeFactory serviceScopeFactory,
            IMapper mapper,
            ITokenProvider tokenProvider
            )
        {
            this.logger = logger;
            this.serviceScopeFactory = serviceScopeFactory;
            this.mapper = mapper;
            this.tokenProvider = tokenProvider;
            passwordHasher = new PasswordHasher<string>();
        }

        public async Task<bool> UserExistsByEmail(string email)
        {
            var scope = serviceScopeFactory.CreateScope();
            using var dbContext = scope.ServiceProvider.GetRequiredService<PPContext>();
            return await dbContext.Users.AnyAsync(e => e.Email == email);
        }

        public async Task AddUser(UserEntity user)
        {
            try
            {
                var scope = serviceScopeFactory.CreateScope();
                using var dbContext = scope.ServiceProvider.GetRequiredService<PPContext>();

                await dbContext.Users.AddAsync(user);

                await dbContext.SaveChangesAsync();
            }
            catch (Exception e)
            {
                var msg = "Adding user failed: ";
                logger.LogError(msg, e, e.Message);
            }
        }

        public async Task DeleteUser(int id)
        {
            try
            {
                var scope = serviceScopeFactory.CreateScope();
                using var dbContext = scope.ServiceProvider.GetRequiredService<PPContext>();

                var user = await dbContext.Users.SingleOrDefaultAsync(e => e.Id == id);

                if (user != null)
                    dbContext.Users.Remove(user);
                await dbContext.SaveChangesAsync();
            }
            catch (Exception e)
            {
                var msg = "Removing user failed: ";
                logger.LogError(msg, e, e.Message);
            }
        }

        public async Task<GetUserModel> GetUserById(int id)
        {
            try
            {
                var scope = serviceScopeFactory.CreateScope();
                using var dbContext = scope.ServiceProvider.GetRequiredService<PPContext>();

                var user = await dbContext.Users.SingleOrDefaultAsync(e => e.Id == id);
                return mapper.Map<GetUserModel>(user);
            }
            catch (Exception e)
            {
                var msg = "Getting user failed: ";
                logger.LogError(msg, e, e.Message);
                throw e;
            }
        }
        public async Task<UserEntity> GetUserByEmail(string email)
        {
            try
            {
                var scope = serviceScopeFactory.CreateScope();
                using var dbContext = scope.ServiceProvider.GetRequiredService<PPContext>();

                var user = await dbContext.Users.FirstOrDefaultAsync(e => e.Email == email);
                if (user != null)
                    return user;
                else
                    throw new UnauthorizedAccessException("This user does not exists");
            }
            catch (Exception e)
            {
                var msg = "Getting user failed: ";
                logger.LogError(msg, e, e.Message);
                throw e;
            }
        }


        public async Task<string> Login(string email, string password)
        {
            var scope = serviceScopeFactory.CreateScope();
            using var dbContext = scope.ServiceProvider.GetRequiredService<PPContext>();
            var user = await GetUserByEmail(email);
            if (await ValidatePassword(email, user.Password, password))
            {
                return tokenProvider.GetToken(user);
            }
            throw new UnauthorizedAccessException("Incorect credentials");
        }

        public async Task UpdateUser(UpdateUserModel user)
        {
            try
            {
                var scope = serviceScopeFactory.CreateScope();
                using var dbContext = scope.ServiceProvider.GetRequiredService<PPContext>();

                var oldUser = await dbContext.Users.SingleOrDefaultAsync(e => e.Id == user.Id);
                if (oldUser != null)
                {
                    oldUser.Username = user.Username;
                    oldUser.Email = user.Email;
                    oldUser.UpdatedAt = user.UpdatedAt;

                    dbContext.Update(oldUser);
                    await dbContext.SaveChangesAsync();
                }
            }
            catch (Exception e)
            {
                var msg = "Updating user failed: ";
                logger.LogError(msg, e, e.Message);
            }
        }

        private async Task<string> Register(RegisterModel register, string role)
        {
            try
            {
                var scope = serviceScopeFactory.CreateScope();
                using var dbContext = scope.ServiceProvider.GetRequiredService<PPContext>();
                string hash = passwordHasher.HashPassword(register.Email, register.Password);
                var user = new UserEntity(
                    register.Username,
                    register.Email,
                    role,
                    hash);

                await dbContext.Users.AddAsync(user);
                await dbContext.SaveChangesAsync();

                return (await Login(register.Email, register.Password));
            }
            catch (Exception e)
            {
                var msg = "Adding user failed: ";
                logger.LogError(msg, e, e.Message);
                throw e;
            }
        }

        public async Task<string> RegisterAdmin(RegisterModel register)
        {
            return (await Register(register, "Admin"));
        }

        public async Task<string> RegisterUser(RegisterModel register)
        {
            return (await Register(register, "User"));
        }

        public async Task<string> RegisterInstitution(RegisterModel register, string role)
        {
            return (await Register(register, role));
        }

        private async Task<bool> ValidatePassword(string email, string hash, string passowrd)
        {
            return passwordHasher.VerifyHashedPassword(email, hash, passowrd) ==
            PasswordVerificationResult.Success;
        }

        public IEnumerable<GetUserModel> GetUsers(int skip, int take)
        {
            var scope = serviceScopeFactory.CreateScope();
            var dbContext = scope.ServiceProvider.GetRequiredService<PPContext>();

            var users = mapper.Map<IEnumerable<GetUserModel>>(dbContext.Users.Skip(skip).Take(take).AsEnumerable());
            return users;
        }
    }
}
