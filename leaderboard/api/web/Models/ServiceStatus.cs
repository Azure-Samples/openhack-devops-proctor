using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Newtonsoft.Json;

namespace Sentinel.Models
{
    [Table("ServiceStatus")]
    public class ServiceStatus {
        public String TeamId {get;set;}

        [JsonIgnore]
        public Team Team { get;set;}

        public EndpointType ServiceType {get;set;}
        public string Status { get; set; }
    }
}