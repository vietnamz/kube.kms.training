namespace WF.Fpt.Application.Models
{
    public class CreateOTRequestModel
    {
        public string UserName { get; set; }

        public string RequestForUser { get; set; }

        public string NumberOfRequestDays { get; set; }

        public string StartDate { get; set; }

        public string Comment { get; set; }
    }
}