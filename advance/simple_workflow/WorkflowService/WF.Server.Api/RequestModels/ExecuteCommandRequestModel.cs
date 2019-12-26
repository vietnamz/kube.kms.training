using System;

namespace WF.Server.Api.RequestModels
{
    public class ExecuteCommandRequestModel
    {
        public Guid WorkflowId { get; set; }

        public string Executor { get; set; }

        public string CommandName { get; set; }
    }
}