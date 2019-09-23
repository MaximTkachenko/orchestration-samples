using System.Linq;
using System.Security.Claims;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;
using Ocelot.DependencyInjection;
using Ocelot.Middleware;

namespace SfSampleApp.ApiGateway
{
    public class Startup
    {
        // This method gets called by the runtime. Use this method to add services to the container.
        // For more information on how to configure your application, visit https://go.microsoft.com/fwlink/?LinkID=398940
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddOcelot();
            services.AddAuthentication(options =>
                {
                    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
                })
                .AddJwtBearer("myd", options =>
                {
                    options.Authority = "https://login.microsoftonline.com/6b9be1b6-4f80-4ce7-8479-16c4d7726470/";
                    options.RequireHttpsMetadata = true;

                    options.TokenValidationParameters = new TokenValidationParameters
                    {
                        ValidAudience = "api://34019183-153b-463f-9b32-528583498700",
                        ValidateAudience = true,
                        ValidateLifetime = true,
                        ValidateIssuer = true

                    };
                });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            var configuration = new OcelotPipelineConfiguration
            {
                AuthorisationMiddleware = async (ctx, next) =>
                {
                    var scope = ctx.DownstreamReRoute.AuthenticationOptions.AllowedScopes[0];
                    if (ctx.HttpContext.User.Claims.Any(x => x.Type == ClaimTypes.Role && x.Value == scope))
                    {
                        await next.Invoke();
                        return;
                    }

                    ctx.HttpContext.Response.StatusCode = StatusCodes.Status403Forbidden;
                }
            };

            app.UseAuthentication();
            app.UseOcelot(configuration).Wait();
        }
    }
}
