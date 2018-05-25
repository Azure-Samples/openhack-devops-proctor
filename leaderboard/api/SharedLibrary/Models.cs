﻿using System;
using Newtonsoft.Json;

namespace Models
{
    /// <summary>
    /// Interface for the Document
    /// </summary>
    public interface IDocument
    {
        string Id { get; set; }
    }

    /// <summary>
    /// Document for a Team.
    /// NOTE: Service seems duplicated with Service Document. It has several reason.
    /// Team.Service is a current snap shot of the Service. It will be updated only when it has change. 
    /// Service document is flequently updated. However, in the near feature, we can remove Service document.
    /// Eventually I'll do it.
    /// </summary>
    public class Team : IDocument
    {

        [JsonProperty(PropertyName = "id")]
        public string Id { get; set; }
        public string Name { get; set; }
        public int Score { get; set; }
        public Challenge[] Challenges { get; set; }
        public Service[] Services { get; set; }

        public void UpdateService(Service service)
        {
            var hasUpdated = false;
            for(int i = 0; i < Services.Length; i++)
            {
                if (Services[i].Id == service.Id)
                {
                    Services[i] = service;
                    hasUpdated = true;
                }
            }
            if (!hasUpdated)
            {
                throw new InvalidOperationException($"Can not find the target Service: {service.Id}");
            }
        }

        public bool GetTotalStatus()
        {
            var currentStatus = true;
            foreach(var service in Services)
            {
                if (!service.CurrentStatus)
                {
                    currentStatus = false;
                }
            }
            return currentStatus;
        }
    }

    /// <summary>
    /// It manages challenges for each team. 
    /// </summary>
    public class Challenge
    {
        public string Id { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string Status { get; set; }
    }

    /// <summary>
    /// Status enum for Challenge status.
    /// </summary>
    public enum ChallengeStatus
    {
        NotStarted,
        Started,
        Completed
    }

    /// <summary>
    /// Service doucment. Eventrually it might removed. 
    /// </summary>
    public class Service : IDocument
    {
        [JsonProperty(PropertyName = "id")]
        public string Id { get; set; }
        public string Name { get; set; }
        public string Uri { get; set; }
        public bool CurrentStatus { get; set; }
    }

    /// <summary>
    /// History document for record every status every time we receive a Downtime Report.
    /// </summary>
    public class History
    {
        public string TeamId { get; set;}
        public string ServiceId { get; set; }
        public DateTime Date { get; set; }
        public int StatusCode { get; set; }
    }
    /// <summary>
    /// Store the record of the OpenHack. This collection has only one document. 
    /// </summary>
    public class Openhack
    {
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }
    }

    /// <summary>
    /// Downtime Report is a report from sentinels. 
    /// </summary>
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
