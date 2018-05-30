using System;
using System.Collections.Generic;
using System.Threading.Tasks;
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
        public Boolean CurrentState { get; set; }

        /// <summary>
        /// Update Current Status. If the current status and Services is different, 
        /// It update the Current Status, also execute parameter function.
        /// The primary purpose of the function is to insert a StatusHistory record.
        /// </summary>
        /// <param name="function"></param>
        /// <returns></returns>
        public async Task UpdateCurrentStateWithFunctionAsync(Func<Task> function)
        {
            if (GetTotalStatus() != this.CurrentState)
            {
                await function(); // function execution comes first. If it fails, don't want to change the state.
                this.CurrentState = GetTotalStatus();
            }
        }

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

        public double GetTotalAvailavility(TimeSpan serviceDownTime)
        {
            var totalTime = GetTotalTime().TotalSeconds;
            var downTime = serviceDownTime.TotalSeconds;
            return (double)(((totalTime - downTime) / totalTime) * 100);
        }
        public string GetTotalAvailavilityAsString(TimeSpan serviceDownTime)
        {
            var availability = GetTotalAvailavility(serviceDownTime);
            return availability.ToString("F6");
        }

        public TimeSpan GetTotalTime()
        {
            return EndTime.Subtract(StartTime);
        }
    }

    /// <summary>
    /// This document record when we've got a status change. 
    /// This table used for the downtime calcuration 
    /// </summary>
    public class StatusHistory : IComparable
    {
        public string TeamId { get; set; }
        public DateTime Date { get; set; }
        public DowntimeStatus Status { get; set; }

        public static TimeSpan GetServiceDowntimeTotal(IList<StatusHistory> statusHistories, DateTime? currentTime = null)
        {
            var list = new List<StatusHistory>();
            list.AddRange(statusHistories);
            // Sort by the Date. For the detail, please refer CompareTo method.
            list.Sort();
            // Loop and detect the downtime. 
            var downtime = TimeSpan.FromMinutes(0);
            StatusHistory current = null;
            // Set Default currentTime. In case of the downtime has been started but not finished.
            if (!currentTime.HasValue)
            {
                currentTime = DateTime.Now;
            }
            
            foreach(var history in list)
            {
                if (history.Status == DowntimeStatus.Started)
                {
                    current = history;
                } else
                {
                    // In case of DowntimeStatus.Finished
                    if (current == null)
                    {
                        throw new JsonFormatException("Invalid Data. Finished comes DowntimeStatus.Finsihed without Downtime.Started. Please check your document.");
                    }
                    downtime = downtime + history.Date.Subtract(current.Date);
                    current = null;
                }
                
            }
            // In case of DowntimeStatus.Started but not finished yet. 
            if (current != null)
            {
                
                downtime = downtime + ((DateTime)currentTime).Subtract(current.Date);
            }
            return downtime;
        }

        public int CompareTo(object obj)
        {
            var history = obj as StatusHistory;
            return this.Date.CompareTo(history.Date);
        }
    }

    /// <summary>
    /// DocumentFormatException is thorwn when you've got a wrong format document from CosmosDB.
    /// </summary>
    public class JsonFormatException : Exception
    {
        public JsonFormatException(string message) : base(message)
        {

        }
    }

    public enum DowntimeStatus{
        Started,
        Finished
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

    /// <summary>
    /// UptimeReport is report for SPA to report all Team uptime reports.
    /// </summary>
    public class UptimeReport
    {
        [JsonProperty(PropertyName = "name")]
        public string Name { get; set; }
        [JsonProperty(PropertyName = "uptime")]
        public int Uptime { get; set; }
        [JsonProperty(PropertyName = "uppercent")]
        public int Uppercent { get; set; }
        [JsonProperty(PropertyName = "point")]
        public int Point { get; set; }
    }

}
