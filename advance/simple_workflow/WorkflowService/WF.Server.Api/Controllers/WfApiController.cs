using System;
using System.Linq;

using Microsoft.AspNetCore.Mvc;

using Newtonsoft.Json;

using WF.Server.Api.RequestModels;
using WF.Server.Business;

namespace WF.Server.Api.Controllers
{
    [Route("api/workflows")]
    public class WfApiController : Controller
    {
        [HttpPost]
        public string Create()
        {
            var workflowId = Guid.NewGuid();

            WorkflowInit.Runtime.CreateInstance("SimpleWF", workflowId);

            var currentState = WorkflowInit.Runtime.GetCurrentState(workflowId);

            return JsonConvert.SerializeObject(new { workFlowId = workflowId.ToString(), currentState = currentState.Name, });
        }

        [HttpPost, Route("execute-command")]
        public string ExecuteCommand([FromBody]ExecuteCommandRequestModel commandRequest)
        {
            var commands = WorkflowInit.Runtime.GetAvailableCommands(commandRequest.WorkflowId, commandRequest.Executor);

            var command = commands.FirstOrDefault(c => c.CommandName.Equals(commandRequest.CommandName, StringComparison.CurrentCultureIgnoreCase));

            if (command == null)
            {
                return "Not found command";
            }

            WorkflowInit.Runtime.ExecuteCommand(command, commandRequest.Executor, commandRequest.Executor);

            var currentState = WorkflowInit.Runtime.GetCurrentState(commandRequest.WorkflowId);
            return JsonConvert.SerializeObject(
                new { currentState = currentState.Name, });
        }

        [HttpGet, Route("{workflowId}")]
        public string Get(Guid workflowId, string userName)
        {
            var currentState = WorkflowInit.Runtime.GetCurrentState(workflowId).Name;
            var availableCommands = WorkflowInit.Runtime.GetAvailableCommands(workflowId, userName ?? Guid.NewGuid().ToString("N")).Select(x => x.CommandName);

            return JsonConvert.SerializeObject(new { currentState, availableCommands });
        }
    }
}
