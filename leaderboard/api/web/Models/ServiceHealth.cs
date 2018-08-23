// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for details.
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations.Schema;

namespace Sentinel.Models
{
    public class ServiceHealth
    {
        public String TeamId {get;set;}
        public string TeamName { get; set; }
        public string HealthStatus { get; set; }
        public int MinutesDown { get; set; }

        public ServiceHealth()
        {
        }
    }
}
