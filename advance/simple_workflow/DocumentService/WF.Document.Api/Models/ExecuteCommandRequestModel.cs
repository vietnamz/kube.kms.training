using System;

namespace WF.Fpt.Application.Models
{
    public class ExecuteCommandRequestModel
    {
        public Guid WorkflowId { get; set; }

        public string Executor { get; set; }

        public string CommandName { get; set; }

        public CreateOTRequestModel OtRequest { get; set; }
    }
}