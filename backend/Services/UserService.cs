﻿using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
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
        Task<UserEntity> Login(string email, string password);
        Task<bool> UserExistsByEmail(string email);

    
    }
    public class UserService : IUserService
    {
        
        private readonly ILogger<IUserService> logger;
        private readonly IServiceScopeFactory serviceScopeFactory;
        private readonly IMapper mapper;
   

  

        public UserService(ILogger<IUserService> logger,
            IServiceScopeFactory serviceScopeFactory,
            IMapper mapper
  
   
            )
        {
            this.logger = logger;
            this.serviceScopeFactory = serviceScopeFactory;
            this.mapper = mapper;
  
   
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


        public async Task<UserEntity> Login(string email, string password)
        {
            var scope = serviceScopeFactory.CreateScope();
            using var dbContext = scope.ServiceProvider.GetRequiredService<PPContext>();
            var user = await dbContext.Users.SingleOrDefaultAsync(u => u.Email == email && u.Password == password);
            return user;
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
    }
}
