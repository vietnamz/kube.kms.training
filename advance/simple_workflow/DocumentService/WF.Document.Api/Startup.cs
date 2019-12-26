using System;
using System.IO;

using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

using Swashbuckle.AspNetCore.Swagger;

using WF.Document.Data.DbContext;

namespace WF.Fpt.Application
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {

            services.AddSwaggerGen(c =>
                {
                    c.SwaggerDoc("v1", new Info { Title = "WF API", Version = "v1" });
                    c.DescribeAllEnumsAsStrings();
                });
            
            services.AddCors();
            var hostname = Environment.GetEnvironmentVariable("SQLSERVER_HOST") 
            ?? "mydatabase,1433";
            var password = Environment.GetEnvironmentVariable("SQLSERVER_SA_PASSWORD")
            ?? "Work4fun";
            var connString = $"Server={hostname};Initial Catalog=DemoWF_Distribute_Database;User ID=sa;Password={password};";
            services.AddEntityFrameworkSqlServer()
                .AddDbContext<DemoDbContext>(
                    options =>
                    {
                        options.UseSqlServer(connString);
                    });

            services.AddMvc();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            app.UseCors(c =>
            {
                c.AllowAnyHeader();
                c.AllowAnyMethod();
                c.AllowAnyOrigin();
            });

            app.UseAuthentication();
            app.UseMvc();

            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseSwagger();
            app.UseSwaggerUI(
                c =>
                    {
                        c.SwaggerEndpoint("/swagger/v1/swagger.json", "API V1");
                    });
        }
    }
}