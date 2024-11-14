using PublicPatch.Data;
using PublicPatch.Profiles;
using PublicPatch.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddScoped<IConfigService, ConfigService>();
builder.Services.AddScoped<IUserService, UserService>();

builder.Services.AddScoped(typeof(PPContext));

builder.Services.AddScoped<GetUserModelConverter>();
builder.Services.AddAutoMapper(typeof(GetUserProfile));
var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
