namespace WF.Fpt.Application.Models
{
    public class ItemResponse
    {
        public string CurrentState { get; set; }

        public string[] AvailableCommands { get; set; }
    }
}