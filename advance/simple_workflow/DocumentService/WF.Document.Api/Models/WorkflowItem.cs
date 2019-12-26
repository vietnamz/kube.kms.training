using System;

namespace WF.Fpt.Application.Models
{
    public class WorkflowItem
    {
        public Guid WorkflowId { get; set; }

        public string CurrentState { get; set; }
    }
}