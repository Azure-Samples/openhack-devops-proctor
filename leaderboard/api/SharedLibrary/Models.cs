using System;
using Newtonsoft.Json;

namespace Models
{
    public interface IDocument
    {
        string Id { get; set; }
    }

    public class Team : IDocument
    {

        [JsonProperty(PropertyName = "id")]
        public string Id { get; set; }
        public string Name { get; set; }
        public int Score { get; set; }
        public Challenge[] Challenges { get; set; }
        public string[] ServiceId { get; set; }
    }
    public class Challenge
    {
        public string Id { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string Status { get; set; }
    }

    public enum ChallengeStatus
    {
        NotStarted,
        Started,
        Completed
    }


    public class Service : IDocument
    {
        [JsonProperty(PropertyName = "id")]
        public string Id { get; set; }
        public string Name { get; set; }
        public string Uri { get; set; }
        public bool CurrentStatus { get; set; }
    }

    public class History
    {
        public string TeamId { get; set;}
        public string ServiceId { get; set; }
        public DateTime Date { get; set; }
        public int StatusCode { get; set; }
    }

    public class DowntimeReport
    {
        public string TeamId { get; set; }
        public string ServiceId { get; set; }
        public DateTime Date { get; set; }
        public int StatusCode { get; set; }
        /// <summary>
        /// Status is the report if the service is recovered or not. If it recovered, it says true.
        /// </summary>
        public Boolean Status { get; set; }

        public History GetHistory()
        {
            var history = new History();
            history.TeamId = this.TeamId;
            history.ServiceId = this.ServiceId;
            history.Date = this.Date;
            history.StatusCode = this.StatusCode;
            return history;
        }
    }

}
