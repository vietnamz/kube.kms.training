using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

using WF.Server.Business;

namespace WF.Server.Api
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
            WorkflowInit.ConnectionString = Configuration["ConnectionStrings:DefaultConnection"];
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddMvc();
            var hostname = Environment.GetEnvironmentVariable("SQLSERVER_HOST") 
            ?? "mydatabase,1433";
            var password = Environment.GetEnvironmentVariable("SQLSERVER_SA_PASSWORD")
            ?? "Work4fun";
            var connString = $"Server={hostname};Initial Catalog=WFTemp;User ID=sa;Password={password};";
            WorkflowInit.ConnectionString = connString ;
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseMvc();
        }
    }
}
