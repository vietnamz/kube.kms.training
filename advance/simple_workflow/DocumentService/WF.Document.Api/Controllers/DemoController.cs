using System;
using System.Linq;
using System.Threading.Tasks;

using Flurl;
using Flurl.Http;

using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

using Newtonsoft.Json;

using WF.Document.Data.DbContext;
using WF.Document.Data.Models;
using WF.Fpt.Application.Models;

namespace WF.Fpt.Application.Controllers
{
    [Route("api/demo")]
    public class DemoController : Controller
    {
        private readonly DemoDbContext _dbContext;

        private readonly IConfiguration _configuration;

        public DemoController(DemoDbContext dbContext, IConfiguration configuration)
        {
            _dbContext = dbContext;
            _configuration = configuration;
        }

        [HttpGet, Route("items")]
        public async Task<ActionResult> GetItemLog(string username)
        {
            var list = await _dbContext.OTItemHistories.ToListAsync();

            var items = list.GroupBy(x => x.WorkflowId).Select(x => x.OrderByDescending(tx => tx.Created).First())
                .OrderByDescending(x => x.Created);

            var users = await _dbContext.Users.OrderBy(x => x.UserName).ToListAsync();
            var workflowApi = Environment.GetEnvironmentVariable("WorkflowServerUrl")
                                ?? "http://wfapi:61511";

            var wfItems = items.Select(
                x => new
                         {
                             WorkflowId = x.WorkflowId,
                             AvailableCommands =
                                 $"{workflowApi}/workflows/{x.WorkflowId}"
                                     .SetQueryParams(new { username })
                                     .GetJsonAsync<ItemResponse>().Result
                         });

            return Ok(
                new
                    {
                        items = items.Join(
                            wfItems,
                            x => x.WorkflowId,
                            x => x.WorkflowId,
                            (item, wfitem) => new { item, wfItem = wfitem.AvailableCommands }),
                        users
                    });
        }

        [HttpGet("users")]
        public async Task<ActionResult> GetUsers()
        {
            return Ok(await _dbContext.Users.OrderBy(x=>x.UserName).ToListAsync());
        }

        [HttpGet("login")]
        public async Task<ActionResult> Login(string username)
        {
            var user = await _dbContext.Users.FirstOrDefaultAsync(x => x.UserName == username);
            if (user == null)
                return BadRequest();

            var users = await _dbContext.Users.OrderBy(x => x.UserName).ToListAsync();

            return Ok(new { username = user.UserName, Name = user.UserName + " :: Role: " + user.UserRoles, users });
        }

        [HttpGet("users/check-role")]
        public async Task<ActionResult> CheckRole(string userName, string role)
        {
            var user = _dbContext.Users.FirstOrDefault(x => x.UserName == userName);

            if (user == null)
                return Ok(false);

            return Ok(user.UserRoles.Contains(role));
        }

        [HttpPost, Route("ot-requests")]
        public async Task<ActionResult> CreateOtRequest([FromBody]CreateOTRequestModel model)
        {
            var workflowApi = Environment.GetEnvironmentVariable("WorkflowServerUrl")
            ?? "http://wfapi:61511";
            var wfItemHttpReponse = await $"{workflowApi}/api/workflows".PostJsonAsync(null);
            if (wfItemHttpReponse.IsSuccessStatusCode)
            {
                var wfItem = JsonConvert.DeserializeObject<WorkflowItem>(await wfItemHttpReponse.Content.ReadAsStringAsync());

                await _dbContext.OTItemHistories.AddAsync(
                    new OTItemHistoryEFModel
                        {
                            Id = Guid.NewGuid(),
                            WorkflowId = wfItem.WorkflowId,
                            RequestForUser = model.RequestForUser,
                            NumberOfRequestDays = model.NumberOfRequestDays,
                            Requester = model.UserName,
                            StartDate = model.StartDate,
                            Comment = model.Comment,
                            CurrentState = wfItem.CurrentState,
                            Created = DateTime.Now,
                        });

                await _dbContext.SaveChangesAsync();

                return Ok();
            }
            return BadRequest("Call WF Error");
        }

        [HttpPost, Route("execute-command")]
        public async Task<ActionResult> ExecuteCommand([FromBody]ExecuteCommandRequestModel command)
        {
            var workflowApi = Environment.GetEnvironmentVariable("WorkflowServerUrl")
            ?? "http://wfapi:61511" ;
            var wfItemHttpReponse = await $"{workflowApi}/api/workflows/execute-command".PostJsonAsync(
                                        new { command.WorkflowId, command.Executor, command.CommandName, });

            if (wfItemHttpReponse.IsSuccessStatusCode)
            {
                var contextData = await wfItemHttpReponse.Content.ReadAsStringAsync();
                var wfItem = JsonConvert.DeserializeObject<WorkflowItem>(contextData);

                if (command.OtRequest != null)
                {
                    await _dbContext.OTItemHistories.AddAsync(
                        new OTItemHistoryEFModel
                            {
                                Id = Guid.NewGuid(),
                                WorkflowId = command.WorkflowId,
                                RequestForUser = command.OtRequest.RequestForUser,
                                NumberOfRequestDays = command.OtRequest.NumberOfRequestDays,
                                Requester = command.OtRequest.UserName,
                                StartDate = command.OtRequest.StartDate,
                                Comment = command.OtRequest.Comment,
                                CurrentState = wfItem.CurrentState,
                                Executor = command.Executor,
                                Created = DateTime.Now,
                            });
                }
                else
                {
                    var lastedVersion = _dbContext
                        .OTItemHistories
                        .Where(x => x.WorkflowId == command.WorkflowId)
                        .GroupBy(x => x.WorkflowId)
                        .Select(x => x.OrderByDescending(t => t.Created).First()).First();

                    await _dbContext.OTItemHistories.AddAsync(
                        new OTItemHistoryEFModel
                            {
                                Id = Guid.NewGuid(),
                                WorkflowId = command.WorkflowId,
                                RequestForUser = lastedVersion.RequestForUser,
                                NumberOfRequestDays = lastedVersion.NumberOfRequestDays,
                                Requester = lastedVersion.Requester,
                                StartDate = lastedVersion.StartDate,
                                Comment = lastedVersion.Comment,
                                CurrentState = wfItem.CurrentState,
                                Executor = command.Executor,
                                Created = DateTime.Now,
                            });

                }

                await _dbContext.SaveChangesAsync();

                return Ok();
            }

            return BadRequest("Call WF Error");
        }
    }
}