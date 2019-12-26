using System;

namespace WF.Document.Data.Models
{
    public class OTItemHistoryEFModel
    {
        public Guid Id { get; set; }

        public Guid WorkflowId { get; set; }

        public string NumberOfRequestDays { get; set; }

        public string StartDate { get; set; }

        public string RequestForUser { get; set; }

        public string Comment { get; set; }

        public string Requester { get; set; }

        public string CurrentState { get; set; }

        public string Executor { get; set; }

        public DateTime Created { get; set; }
    }

    public class UserEFModel
    {
        public Guid Id { get; set; }
        public string UserName { get; set; }

        public string UserRoles { get; set; }
    }
}
