using System;
using Newtonsoft.Json;

namespace Sentinel.Models
{
    public class Healthcheck
    {
        public Healthcheck()
        {
            Message = "Seltinel Logging Service Healthcheck";
            Status = "Healthy";
        }
        [Newtonsoft.Json.JsonProperty(PropertyName = "message")]
        public string Message {get;set;}

        [Newtonsoft.Json.JsonProperty(PropertyName = "status")]
        public string Status { get; set; }
    }
}
