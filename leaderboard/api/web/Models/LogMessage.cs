// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for details.
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations.Schema;

namespace Sentinel.Models
{

    public enum EndpointType
    {
        POI = 1,
        USER = 2,
        TRIPS = 3
    }

    public class LogMessage
    {
        public String Id {get;set;}
        public string TeamName { get; set; }
        public string EndpointUri { get; set; }
        public DateTime CreatedDate { get; set; }
        public EndpointType Type { get; set; }
        public int StatusCode { get; set; }

        public LogMessage()
        {
            Id = Guid.NewGuid().ToString();
        }
    }
}