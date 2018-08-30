using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Sentinel.Models
{
    public class SvcStatus {
        [Key, ForeignKey("Teams"), Column(Order = 0)]
        public String TeamId {get;set;}
        public EndpointType ServiceType {get;set;}
        public string Status { get; set; }
    }
}